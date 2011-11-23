//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import <Foundation/Foundation.h>
#import "EENavigationState.h"
#import "EENavigationBehaviors.h"
#import "EEStatusByResponder.h"
#import "EESingleton.h"

#define EENavigatorException @"EENavigatorException"

@class EENavigationState;

@interface EENavigator : EESingleton

@property (nonatomic, copy, readonly) EENavigationState *current;
@property (nonatomic, retain, readonly) NSMutableArray *history;

+ (EENavigator *)sharedNavigator;

- (void)add:(id <EENavigationBehavior>)responder toState:(EENavigationState *)state;
- (void)add:(id <EENavigationBehavior>)responder toState:(EENavigationState *)state forBehavior:(EENavigationBehaviorType)behavior;

- (void)remove:(id<EENavigationBehavior>)responder fromState:(EENavigationState *)state;
- (void)remove:(id <EENavigationBehavior>)responder fromState:(EENavigationState *)state forBehavior:(EENavigationBehaviorType)behavior;

- (void)request:(EENavigationState *)state;
- (EEResponderStatus)statusOfResponder:(id<EENavigationBehavior>)responder;

@end
