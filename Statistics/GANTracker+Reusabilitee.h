//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>
#import "GANTracker.h"

/**
 This is a category on the ready-made GANTracker.a library from Google.
 
 It makes analytics a lot easier with one-line calls to track pages and events.
 */
@interface GANTracker (Reusabilitee)

/**
 Single start call to fire up Google Analytics tracking.
 
 @param prefix should not contain any leading or trailing slashes.
 */
+ (void)startWithAccountID:(NSString *)accountID andPrefix:(NSString *)prefix;

/**
 Stops the analytics session. To be called in the dealloc of the app delegate.
 */
+ (void)stop;

/**
 Track a page view or action.
 
 @param page is a slash-delimited string without leading and trailing slashes. 
 */
+ (void)trackPageview:(NSString *)page;

/**
 Track an event.
 
 Events contain numeric values that Google Analytics will perform some arithmetic on, like cumulative values and averages.
 
 @param category should not contain any leading or trailing slashes.
 @param key describes the name of the numeric value. Should also contain the unit of the value, like '-kb' or '-mb'.
 @param value contains the numeric value itself.
 */
+ (void)trackEventCategory:(NSString *)category action:(NSString *)action key:(NSString *)key value:(NSInteger)value;

@end
