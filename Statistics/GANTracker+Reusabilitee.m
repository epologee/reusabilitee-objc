//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "GANTracker+Reusabilitee.h"

@interface GANDelegateLogger : NSObject <GANTrackerDelegate>
@end

@implementation GANDelegateLogger

- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)eventsDispatched
              eventsFailedDispatch:(NSUInteger)eventsFailedDispatch
{
    if (eventsFailedDispatch > 0) {
        DLog(@"Tracker dispatch completed with errors (dispatched: %i failed: %i)", eventsDispatched, eventsFailedDispatch);
    } 
}

@end

@implementation GANTracker (Reusabilitee)

#if !TARGET_IPHONE_SIMULATOR

static GANDelegateLogger *logger;

#endif

static NSString *customPrefix;

+ (void)startWithAccountID:(NSString *)accountID andPrefix:(NSString *)prefix;
{
    customPrefix = [(prefix == nil) ? @"" : [NSString stringWithFormat:@"%@/", prefix] retain];
    
#if !TARGET_IPHONE_SIMULATOR
    
    logger = [[GANDelegateLogger alloc] init];
	DLog(@"GANTracker is in tracking mode, tracking %@", accountID);

    // We're intentionally leaking this object.
    [[GANTracker sharedTracker] startTrackerWithAccountID:accountID 
										   dispatchPeriod:10 // in seconds
												 delegate:logger];
    
#else
    
    ILog(@"GANTracker is in simulation mode");
    
#endif
}

+ (void)stop
{
    [customPrefix release];

#if !TARGET_IPHONE_SIMULATOR
    
    [[GANTracker sharedTracker] stopTracker];
    [logger release];
    
#endif
}

+ (void)trackPageview:(NSString *)page
{
    NSString *path = [NSString stringWithFormat:@"/%@%@", customPrefix, page];
    
#if !TARGET_IPHONE_SIMULATOR

    NSError *error;
    
    if ([[self sharedTracker] trackPageview:path withError:&error]) 
    {
        DLog(@"Tracked pageview: %@", path);
    }
    else
    {
        DLog(@"Error tracking pageview: %@\n↳ %@", path, error);
    }

#else

    ILog(@"Simulating pageview: %@", path);

#endif
}

+ (void)trackEventCategory:(NSString *)category action:(NSString *)action key:(NSString *)key value:(NSInteger)value
{
    NSString *path = [NSString stringWithFormat:@"%@%@", customPrefix, category];
    
#if !TARGET_IPHONE_SIMULATOR

    NSError *error;
    
    if ([[self sharedTracker] trackEvent:path action:action label:key value:value withError:&error]) 
    {
        DLog(@"Tracked event: %@/%@ | %@ = %i", path, action, key, value);
    }
    else
    {
        DLog(@"Error tracking event: : %@/%@ | %@ = %i\n↳ %@", path, action, key, value, error);
    }

#else

    ILog(@"Simulated event: %@/%@ | %@ = %i", path, action, key, value);

#endif
}

@end
