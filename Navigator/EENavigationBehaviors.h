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

@optional
// Only one transitionIn~ and one transitionOut~ method will be called, so don't implement multiple.

/**
 Assumes instant completion
 */
- (void)transitionIn;
- (void)transitionInWithFull:(EENavigationState *)full;
- (void)transitionInWithFull:(EENavigationState *)full truncated:(EENavigationState *)truncated;

/**
 Call the completion block when your transition is complete, notifyTransitionComplete();
 */
- (void)transitionInWithCompletionBlock:(void (^)())notifyTransitionComplete;

/**
 Assumes instant completion
 */
- (void)transitionOut;
/**
 Call the completion block when your transition is complete, notifyTransitionComplete();
 */
- (void)transitionOutWithCompletionBlock:(void (^)())notifyTransitionComplete;

@end

@protocol EEUpdateBehavior <EENavigationBehavior>

@optional
// Only one of these methods will be called, so don't implement both.
- (void)updateWithTruncated:(EENavigationState *)truncated;
- (void)updateWithFull:(EENavigationState *)full;
- (void)updateWithFull:(EENavigationState *)full truncated:(EENavigationState *)truncated;

@end

@protocol EEValidateBehavior <EENavigationBehavior>

@optional
// Only one of these methods will be called, so don't implement both.
- (BOOL)validate:(EENavigationState *)truncated;
- (BOOL)validateFull:(EENavigationState *)full truncated:(EENavigationState *)truncated;

@end