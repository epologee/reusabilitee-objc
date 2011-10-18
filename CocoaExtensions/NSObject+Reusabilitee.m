//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSObject+Reusabilitee.h"

@implementation NSObject (Reusabilitee)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

@end
