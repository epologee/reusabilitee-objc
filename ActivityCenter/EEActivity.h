//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>

typedef enum {
    kActivityStatusReady    = 0,
    kActivityStatusBusy     = 1,
    kActivityStatusSuccess  = 2,
    kActivityStatusFailure  = 3
} ActivityStatus;

typedef enum {
    kActivityFeedbackNone           = 0,
    kActivityFeedbackStart          = 1 << 0,
    kActivityFeedbackProgress       = 1 << 1,
    kActivityFeedbackFinish         = 1 << 2,
    kActivityFeedbackContinuous     = 1 << 3
} ActivityFeedbackOptions;

@protocol ActivityDelegate;

@interface EEActivity : NSObject

@property (nonatomic, copy, readonly) id context;
/**
 Names are for internal identification.
 */
@property (nonatomic, copy, readonly) NSString *name;
/**
 Labels may be presented to the user.
 */
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, readonly) ActivityStatus status;
@property (nonatomic, readonly, getter = isActive) BOOL active;
@property (nonatomic, retain) NSDate *dateStarted;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic) BOOL keepHistory;
@property (nonatomic) ActivityFeedbackOptions feedbackOptions;

/**
 You can opt to have the activityStarted: and activity:updatedProgress: fired
 immediately when adding a delegate to a running activity using this flag. 
 This way, you can always rely on the UI code in your delegate methods to handle
 the correct display settings of the activity.
 */
@property (nonatomic) BOOL instantDelegation;

+ (NSString *)identifierForName:(NSString *)name andContext:(id)context;

/**
 @param context will always be used as an NSString internally, but if you pass any other object, it's description-message will be used.
 */
- (id)initWithName:(NSString *)name andContext:(id)context;

#pragma mark -
#pragma mark Delegation

- (void)addDelegate:(id <ActivityDelegate>)delegate;
- (void)removeDelegate:(id <ActivityDelegate>)delegate;

#pragma mark -
#pragma mark Status changes

/**
 Set the status to `busy`. Can only be called once per instantiated activity.
 Will trigger the `activityStarted:` method on all delegates.
 */
- (void)started;

/**
 Updates the progress (percentage) to the supplied value.
 Will trigger the `activity:updatedProgress:` method on all delegates.
 */
- (void)updatedProgress:(CGFloat)progress;

/**
 Set the progress to 1 and the status to either `success` or `failure` based on the supplied value.
 Will trigger the `activity:finished:` method on all delegates.
 */
- (void)finished:(BOOL)success;

- (BOOL)endOfLife;

- (NSString *)statusDescription;

@end

@protocol ActivityDelegate <NSObject>

@optional

- (void)activityStarted:(EEActivity *)activity;
- (void)activity:(EEActivity *)activity updatedProgress:(CGFloat)progress;
- (void)activity:(EEActivity *)activity finished:(BOOL)success;

@end