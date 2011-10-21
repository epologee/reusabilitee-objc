//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import "EEStatusByResponder.h"
#import "EENavigator.h"

@interface EEResponderStatusPair : NSObject

@property (nonatomic, retain) id<EENavigationBehavior> responder;
@property (nonatomic, readwrite) EEResponderStatus status;

@end

@implementation EEResponderStatusPair

@synthesize responder=responder_, status=status_;

@end

@interface EEStatusByResponder ()

@property (nonatomic, retain) NSMutableSet *listOfPairs;

-(EEResponderStatusPair *)pairOfResponder:(id<EENavigationBehavior>)responder autocreate:(BOOL)autocreate;

@end

@implementation EEStatusByResponder

@synthesize listOfPairs=responders_;

- (id)init {
    self = [super init];
    if (self) {
        self.listOfPairs = [[[NSMutableSet alloc] init] autorelease];
    }
    return self;
}

-(void)setStatus:(EEResponderStatus)status ofResponder:(id <EENavigationBehavior>)responder {
    [self pairOfResponder:responder autocreate:YES].status = status;
}

-(NSMutableSet *)respondersWithStatus:(EEResponderStatus)status {
    NSMutableSet *match = [[[NSMutableSet alloc] init] autorelease];
    
    for (EEResponderStatusPair *pair in self.listOfPairs) {
        if (pair.status & status) [match addObject:pair.responder];
    }
    
    return match;
}

-(EEResponderStatus)statusOfResponder:(id <EENavigationBehavior>)responder {
    EEResponderStatusPair *pair = [self pairOfResponder:responder autocreate:NO];
    if (pair == nil) return kEEResponderStatusUninitialized;
    return pair.status;
}

-(EEResponderStatusPair *)pairOfResponder:(id<EENavigationBehavior>)responder autocreate:(BOOL)autocreate {
    for (EEResponderStatusPair *pair in self.listOfPairs) {
        if (pair.responder == responder) return pair;
    }
    
    if (!autocreate) return nil;
    
    EEResponderStatusPair *pair = [[[EEResponderStatusPair alloc] init] autorelease];
    pair.responder = responder;
    pair.status = kEEResponderStatusUninitialized;
    [self.listOfPairs addObject:pair];
    return pair;
}

@end

