//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import <Foundation/Foundation.h>

typedef enum {
    kEENavigationBehaviorShow,
    kEENavigationBehaviorUpdate,
    kEENavigationBehaviorValidate
} EENavigationBehaviorType;

@class EENavigationState;

@protocol EENavigationBehavior <NSObject>
@end

@protocol EETransitionBehavior <EENavigationBehavior>

-(void)transitionIn;
-(void)transitionOut;

@end

@protocol EEUpdateBehavior <EENavigationBehavior>

@optional
// Only one of these methods will be called, so don't implement both.
-(void)update:(EENavigationState *)truncated;
-(void)updateFull:(EENavigationState *)full andTruncated:(EENavigationState *)truncated;

@end

@protocol EEValidateBehavior <EENavigationBehavior>

@optional
// Only one of these methods will be called, so don't implement both.
-(BOOL)validate:(EENavigationState *)truncated;
-(BOOL)validateFull:(EENavigationState *)full andTruncated:(EENavigationState *)truncated;

@end
