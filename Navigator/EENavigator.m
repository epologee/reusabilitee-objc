//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import "EENavigator.h"
#import "EEStatusByResponder.h"

#define MAX_HISTORY_COUNT 20

@interface EENavigator () 

@property (nonatomic, copy, readwrite) EENavigationState *current;
@property (nonatomic, retain) NSMutableDictionary *showByPath;
@property (nonatomic, retain) NSMutableDictionary *updateByPath;
@property (nonatomic, retain) NSMutableDictionary *validateByPath;
@property (nonatomic, retain) EEStatusByResponder *statusByResponder;
@property (nonatomic, retain) NSMutableArray *history;
@property (nonatomic) NSInteger transitionId;
@property (nonatomic) NSInteger transitionCounter;
@property (nonatomic) BOOL transitionsQueued;

- (BOOL)validate:(EENavigationState *)state;
- (void)grantRequest:(EENavigationState *)state;

- (void)addResponder:(id<EENavigationBehavior>)responder to:(NSMutableDictionary *)dictionary forState:(EENavigationState *)state;
- (void)removeResponder:(id<EENavigationBehavior>)responder from:(NSMutableDictionary *)dictionary forState:(EENavigationState *)state;
- (NSMutableSet *)responderSetIn:(NSMutableDictionary *)dictionary containingState:(EENavigationState *)state;

@end

@interface EENavigator (TransitionFlow)

// primary
- (void)startTransition;
- (void)transitionOut;
- (void)performUpdates;
- (void)transitionIn;
- (void)finishTransition;

// secondary
- (NSSet *)respondersToShow;

@end

@implementation EENavigator

@synthesize current = current_;
@synthesize showByPath = showByPath_;
@synthesize updateByPath = updateByPath_;
@synthesize validateByPath = validateByPath_;
@synthesize statusByResponder = statusByResponder_;
@synthesize history = history_;
@synthesize transitionId = transitionId_;
@synthesize transitionCounter = transitionCounter_;
@synthesize transitionsQueued = transitionsQueued_;

+ (EENavigator *)sharedNavigator 
{
    return [self instance];
}

- (id)init 
{
    self = [super init];
    
    if (self) {
        self.showByPath = [NSMutableDictionary dictionary];
        self.updateByPath = [NSMutableDictionary dictionary];
        self.validateByPath = [NSMutableDictionary dictionary];
        self.statusByResponder = [[[EEStatusByResponder alloc] init] autorelease];
        self.history = [NSMutableArray array];
    }
    
    return self;
}

- (void)setTransitionId:(NSInteger)transitionId
{
    transitionId_ = transitionId;
    
    // reset the transition counter
    if (self.transitionCounter > 0)
    {
        WLog(@"Seems like not all transtions called their completion blocks correctly.");
    }
    
    self.transitionCounter = 0;
}

- (void)dealloc {
    self.current = nil;
    self.showByPath = nil;
    self.updateByPath = nil;
    self.validateByPath = nil;
    self.statusByResponder = nil;
    self.history = nil;
    
    [super dealloc];
}

- (void)add:(id<EENavigationBehavior>)responder toState:(EENavigationState *)state 
{
    [self add:responder toState:state forBehavior:kEENavigationBehaviorValidate];
    [self add:responder toState:state forBehavior:kEENavigationBehaviorUpdate];
    [self add:responder toState:state forBehavior:kEENavigationBehaviorShow];
}

- (void)add:(id <EENavigationBehavior>)responder toState:(EENavigationState *)state forBehavior:(EENavigationBehaviorType)behavior 
{
    switch (behavior) {
        case kEENavigationBehaviorShow:
            if ([responder conformsToProtocol:@protocol(EETransitionBehavior)]) 
            {
                [self addResponder:responder to:self.showByPath forState:state];
            }
            break;
            
        case kEENavigationBehaviorUpdate:
            if ([responder conformsToProtocol:@protocol(EEUpdateBehavior)]) 
            {
                [self addResponder:responder to:self.updateByPath forState:state];
            }
            break;
            
        case kEENavigationBehaviorValidate:
            if ([responder conformsToProtocol:@protocol(EEValidateBehavior)]) 
            {
                [self addResponder:responder to:self.validateByPath forState:state];
            }
            break;
    }
}

- (void)remove:(id<EENavigationBehavior>)responder fromState:(EENavigationState *)state 
{
    [self remove:responder fromState:state forBehavior:kEENavigationBehaviorValidate];
    [self remove:responder fromState:state forBehavior:kEENavigationBehaviorUpdate];
    [self remove:responder fromState:state forBehavior:kEENavigationBehaviorShow];
}

- (void)remove:(id <EENavigationBehavior>)responder fromState:(EENavigationState *)state forBehavior:(EENavigationBehaviorType)behavior 
{
    switch (behavior) {
        case kEENavigationBehaviorShow:
            if ([responder conformsToProtocol:@protocol(EETransitionBehavior)]) 
            {
                [self removeResponder:responder from:self.showByPath forState:state];
            }
            break;
            
        case kEENavigationBehaviorUpdate:
            if ([responder conformsToProtocol:@protocol(EEUpdateBehavior)]) 
            {
                [self removeResponder:responder from:self.updateByPath forState:state];
            }
            break;
            
        case kEENavigationBehaviorValidate:
            if ([responder conformsToProtocol:@protocol(EEValidateBehavior)]) 
            {
                [self removeResponder:responder from:self.validateByPath forState:state];
            }
            break;
    }
}

- (EEResponderStatus)statusOfResponder:(id<EENavigationBehavior>)responder 
{
    return [self.statusByResponder statusOfResponder:responder];
}

- (void)request:(EENavigationState *)state 
{
    if ([state equals:self.current]) 
    {
        return;
    }
    
    if ([self validate:state]) 
    {
        
        [self grantRequest:state];
        return;
        
    }
    else if ([state hasWildcards] && self.current != nil) 
    {
        
        EENavigationState *maskedState = [state mask:self.current];
        if ([self validate:maskedState]) 
        {
            [self grantRequest:maskedState];
            return;
        }
        
    }
    
    DLog(@"Request denied for %@", state);
}

- (BOOL)validate:(EENavigationState *)state 
{
    // Never allow a state with wildcards to be granted
    if ([state hasWildcards]) return NO;
    
    // Hard wiring EETransitionBehavior
    for (NSString *path in self.showByPath) {
        if ([state contains:[path stateFromPath]]) {
            return YES;
        }
    }
    
    // Hard wiring EEUpdateBehavior
    for (NSString *path in self.updateByPath) {
        if ([state equals:[path stateFromPath]]) {
            return YES;
        }
    }
    
    // Custom wiring EEValidateBehavior
    BOOL customGranted = NO;
    BOOL customDenied = NO;
    for (NSString *path in self.validateByPath) {
        EENavigationState *checkState = [path stateFromPath];
        if ([state contains:checkState]) {
            NSSet *responders = [self.validateByPath objectForKey:path];
            
            for (id <EEValidateBehavior> responder in responders) {
                BOOL valid = NO;
                EENavigationState *truncated = [state truncate:checkState];
                
                if ([responder respondsToSelector:@selector(validate:)]) {
                    valid = [responder validate:truncated];
                } else if ([responder respondsToSelector:@selector(validateFull:truncated:)]) {
                    valid = [responder validateFull:self.current truncated:truncated];
                }
                
                if (valid) {
                    customGranted = YES;
                } else {
                    customDenied = YES;
                }
            }
        }
    }
    
    if (customDenied) return NO;    
    return customGranted;
}

- (void)saveCurrentToHistory
{
    if (self.current)
    {
        for (NSInteger index = [self.history count]; --index >= 0;) {
            EENavigationState *state = [self.history objectAtIndex:index];
            if ([state equals:self.current])
            {
                [self.history removeObjectAtIndex:index];
                break;
            }
        }
        
        [self.history insertObject:self.current atIndex:0];
        while ([self.history count] > MAX_HISTORY_COUNT)
        {
            [self.history removeLastObject];
        }
    }
}

- (void)grantRequest:(EENavigationState *)state {
    [self saveCurrentToHistory];

    self.current = state;
    
    DLog(@"Granted %@ (history: %@)", state, [self.history subarrayWithRange:NSMakeRange(0, MIN([self.history count], 5))]);
    
    [self startTransition];
}

- (void)addResponder:(id<EENavigationBehavior>)responder to:(NSMutableDictionary *)dictionary forState:(EENavigationState *)state 
{
    NSMutableSet *responders = [dictionary objectForKey:state.path];
    
    if (responders == nil) {
        responders = [[[NSMutableSet alloc] init] autorelease];
        [dictionary setObject:responders forKey:state.path];
    }
    
    [responders addObject:responder];
    //    DLog(@"Responders: %@", responders);
}

- (void)removeResponder:(id<EENavigationBehavior>)responder from:(NSMutableDictionary *)dictionary forState:(EENavigationState *)state 
{
    NSMutableSet *responders = [dictionary objectForKey:state.path];
    
    if (responders != nil) {
        [responders removeObject:responder];
    }
    
    //    DLog(@"Responders: %@", responders);
}

- (NSMutableSet *)responderSetIn:(NSMutableDictionary *)dictionary containingState:(EENavigationState *)state 
{
    NSMutableSet *responders = [[[NSMutableSet alloc] init] autorelease];
    
    for (NSString *path in dictionary) {
        EENavigationState *checkState = [path stateFromPath];
        if ([state contains:checkState]) {
            [responders unionSet:[dictionary objectForKey:path]];
        }
    }
    
    return responders;
}

- (void)notifyCompleteTransition:(NSInteger)transitionId forResponder:(id<EETransitionBehavior>)responder withStatus:(EEResponderStatus)status
{
    if (self.transitionId == transitionId)
    {
        [self.statusByResponder setStatus:status ofResponder:responder];
        self.transitionCounter--;
        if (self.transitionCounter == 0 && self.transitionsQueued)
        {
            if (status == kEEResponderStatusShown)
            {
                DLog(@"Transition in complete.");
                [self finishTransition];
            }
            else if (status == kEEResponderStatusHidden)
            {
                DLog(@"Transition out complete.");
                [self performUpdates];
            }
        }
    }
    else
    {
        // ignore callbacks of 'old' transitions.
    }
}

- (void)startTransition {
    [self transitionOut];
}

- (void)transitionOut {
    NSMutableSet *visible = [self.statusByResponder respondersWithStatus:kEEResponderStatusShown | kEEResponderStatusAppearing];
    NSMutableSet *toShow = [self responderSetIn:self.showByPath containingState:self.current];
    [visible minusSet:toShow];
    
    BOOL asyncTransitions = NO;
    self.transitionId++;

    for (id<EETransitionBehavior> responder in visible) {
        
        if ([responder respondsToSelector:@selector(transitionOutWithCompletionBlock:)])
        {
            asyncTransitions = YES;
            self.transitionCounter++;
            [self.statusByResponder setStatus:kEEResponderStatusDisappearing ofResponder:responder];
            [responder transitionOutWithCompletionBlock:^{
                [self notifyCompleteTransition:transitionId_ forResponder:responder withStatus:kEEResponderStatusHidden];
            }];
        }
        else if ([responder respondsToSelector:@selector(transitionOut)])
        {
            [responder transitionOut];
            [self.statusByResponder setStatus:kEEResponderStatusHidden ofResponder:responder];
        }
        else
        {
            [NSException raise:EENavigatorException format:@"Transition responder did not implement a transitionOut~ method: %@", responder];
        }
    }

    if (!asyncTransitions || self.transitionCounter == 0)
    {
        [self performUpdates];
    }
    else
    {
        self.transitionsQueued = YES;
    }
}

- (void)performUpdates {
    for (NSString *path in self.updateByPath) {
        EENavigationState *checkState = [path stateFromPath];
        if ([self.current contains:checkState]) 
        {
            NSSet *responders = [self.updateByPath objectForKey:path];
            EENavigationState *truncated = [self.current truncate:checkState];
            for (id<EEUpdateBehavior>responder in responders) 
            {
                if ([responder respondsToSelector:@selector(updateWithTruncated:)]) 
                {
                    [responder updateWithTruncated:truncated];
                } 
                else if ([responder respondsToSelector:@selector(updateWithFull:)]) 
                {
                    [responder updateWithFull:self.current];
                }
                else if ([responder respondsToSelector:@selector(updateWithFull:truncated:)]) 
                {
                    [responder updateWithFull:self.current truncated:truncated];
                }
                else
                {
                    [NSException raise:EENavigatorException format:@"update responder did not implement the protocol correctly."];
                }
            }
        }
    }
    
    [self transitionIn];
}

- (void)transitionIn {
    NSMutableSet *toShow = [self responderSetIn:self.showByPath containingState:self.current];
    NSMutableSet *visible = [self.statusByResponder respondersWithStatus:kEEResponderStatusShown & kEEResponderStatusAppearing];
    [toShow minusSet:visible];
    
    BOOL asyncTransitions = NO;
    self.transitionId++;
    
    for (id<EETransitionBehavior> responder in toShow) {
        BOOL showing = [self.statusByResponder statusOfResponder:responder] == kEEResponderStatusShown;
        BOOL appearing = [self.statusByResponder statusOfResponder:responder] == kEEResponderStatusAppearing;
        if (!showing && !appearing)
        {
            if ([responder respondsToSelector:@selector(transitionInWithFull:)])
            {
                [responder transitionInWithFull:self.current];
                [self.statusByResponder setStatus:kEEResponderStatusShown ofResponder:responder];
            }
            else if ([responder respondsToSelector:@selector(transitionInWithCompletionBlock:)])
            {
                asyncTransitions = YES;
                self.transitionCounter++;
                [self.statusByResponder setStatus:kEEResponderStatusAppearing ofResponder:responder];
                [responder transitionInWithCompletionBlock:^{
                    [self notifyCompleteTransition:transitionId_ forResponder:responder withStatus:kEEResponderStatusShown];
                }];
            }
            else if ([responder respondsToSelector:@selector(transitionIn)])
            {
                [responder transitionIn];
                [self.statusByResponder setStatus:kEEResponderStatusShown ofResponder:responder];
            }
            else
            {
                [NSException raise:EENavigatorException format:@"Transition responder did not implement a transitionIn~ method: %@", responder];
            }
        }
    }
    
    if (!asyncTransitions || self.transitionCounter == 0)
    {
        [self finishTransition];
    }
    else
    {
        self.transitionsQueued = YES;
    }
}

- (void)finishTransition {
    // nothing
}

@end
