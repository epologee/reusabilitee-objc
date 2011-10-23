//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import "EENavigator.h"
#import "EEStatusByResponder.h"

@interface EENavigator () 

@property (nonatomic, retain) NSMutableDictionary *showByPath;
@property (nonatomic, retain) NSMutableDictionary *updateByPath;
@property (nonatomic, retain) NSMutableDictionary *validateByPath;
@property (nonatomic, retain) EEStatusByResponder *statusByResponder;

- (BOOL)validate:(EENavigationState *)state;
- (void)grantRequest:(EENavigationState *)state;

- (void)addResponder:(id<EENavigationBehavior>)responder to:(NSMutableDictionary *)dictionary forState:(EENavigationState *)state;
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

+ (EENavigator *)sharedNavigator 
{
    return [self instance];
}

- (id)init 
{
    self = [super init];
    
    if (self) {
        self.showByPath = [[[NSMutableDictionary alloc] init] autorelease];
        self.updateByPath = [[[NSMutableDictionary alloc] init] autorelease];
        self.validateByPath = [[[NSMutableDictionary alloc] init] autorelease];
        self.statusByResponder = [[[EEStatusByResponder alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.current = nil;
    self.showByPath = nil;
    self.updateByPath = nil;
    self.validateByPath = nil;
    self.statusByResponder = nil;
    
    [super dealloc];
}

- (void)add:(id<EENavigationBehavior>)responder toState:(EENavigationState *)state 
{
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

- (EEResponderStatus)statusOfResponder:(id<EENavigationBehavior>)responder 
{
    return [self.statusByResponder statusOfResponder:responder];
}

- (void)request:(EENavigationState *)state 
{
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
        if ([state contains:[path toState]]) {
            return YES;
        }
    }
    
    // Hard wiring EEUpdateBehavior
    for (NSString *path in self.updateByPath) {
        if ([state equals:[path toState]]) {
            return YES;
        }
    }
    
    // Custom wiring EEValidateBehavior
    BOOL customGranted = NO;
    BOOL customDenied = NO;
    for (NSString *path in self.validateByPath) {
        EENavigationState *checkState = [path toState];
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

- (void)grantRequest:(EENavigationState *)state {
    self.current = state;
    DLog(@"Granted %@", state);
    
    [self startTransition];
}

- (void)addResponder:(id<EENavigationBehavior>)responder to:(NSMutableDictionary *)dictionary forState:(EENavigationState *)state {
    NSMutableSet *responders = [dictionary objectForKey:state.path];
    
    if (responders == nil) {
        responders = [[[NSMutableSet alloc] init] autorelease];
        [dictionary setObject:responders forKey:state.path];
    }
    
    [responders addObject:responder];
    DLog(@"Responders: %@", responders);
}

- (NSMutableSet *)responderSetIn:(NSMutableDictionary *)dictionary containingState:(EENavigationState *)state {
    NSMutableSet *responders = [[[NSMutableSet alloc] init] autorelease];
    
    for (NSString *path in dictionary) {
        EENavigationState *checkState = [path toState];
        if ([state contains:checkState]) {
            [responders unionSet:[dictionary objectForKey:path]];
        }
    }
    
    return responders;
}

- (void)startTransition {
    [self transitionOut];
}

- (void)transitionOut {
    NSMutableSet *visible = [self.statusByResponder respondersWithStatus:kEEResponderStatusShown | kEEResponderStatusAppearing];
    NSMutableSet *toShow = [self responderSetIn:self.showByPath containingState:self.current];
    [visible minusSet:toShow];
    
    for (id<EETransitionBehavior> responder in visible) {
        [self.statusByResponder setStatus:kEEResponderStatusHidden ofResponder:responder];
        [responder transitionOut];
    }
    
    [self performUpdates];
}

- (void)performUpdates {
    for (NSString *path in self.updateByPath) {
        EENavigationState *checkState = [path toState];
        if ([self.current contains:checkState]) {
            NSSet *responders = [self.updateByPath objectForKey:path];
            EENavigationState *truncated = [self.current truncate:checkState];
            for (id<EEUpdateBehavior>responder in responders) {
                if ([responder respondsToSelector:@selector(update:)]) {
                    [responder update:truncated];
                } else if ([responder respondsToSelector:@selector(updateFull:truncated:)]) {
                    [responder updateFull:self.current truncated:truncated];
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
    
    for (id<EETransitionBehavior> responder in toShow) {
        [self.statusByResponder setStatus:kEEResponderStatusShown ofResponder:responder];
        [responder transitionIn];
    }
    
    [self finishTransition];
}

- (void)finishTransition {
    // nothing
}

@end
