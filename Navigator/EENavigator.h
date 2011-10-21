//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import <Foundation/Foundation.h>
#import "EENavigationState.h"
#import "EENavigationBehaviors.h"
#import "EEStatusByResponder.h"

@class EENavigationState;

@interface EENavigator : NSObject

@property (nonatomic, retain) EENavigationState *current;

+ (EENavigator *)sharedNavigator;

- (void)add:(id <EENavigationBehavior>)responder toState:(EENavigationState *)state;
- (void)add:(id <EENavigationBehavior>)responder toState:(EENavigationState *)state forBehavior:(EENavigationBehaviorType)behavior;
- (void)request:(EENavigationState *)state;
- (EEResponderStatus)statusOfResponder:(id<EENavigationBehavior>)responder;

@end
