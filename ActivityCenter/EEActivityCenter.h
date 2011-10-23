//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "../Singleton/EESingleton.h"
#import "EEActivity.h"

@protocol ActivityDelegate, ActivityContext;

@interface EEActivityCenter : EESingleton <ActivityDelegate>

@property(nonatomic, readonly) BOOL isActive;
@property(nonatomic, assign) id <ActivityDelegate> centralDelegate;

#pragma mark -
#pragma mark Delegation

- (void)setDelegate:(id <ActivityDelegate>)delegate forActivity:(NSString *)name context:(NSString *)context;

- (void)invalidateDelegate:(id <ActivityDelegate>)delegate;

- (EEActivity *)activityWithName:(NSString *)name;

/**
 Will look for an activity with matching name and context, and will
 create a new one if it didn't already exist. Usually the context is
 some kind of NSString, but you can also pass in other objects, like
 an [NSDate date] to force creating a new activity.
 */
- (EEActivity *)activityWithName:(NSString *)name context:(id)context;

@end