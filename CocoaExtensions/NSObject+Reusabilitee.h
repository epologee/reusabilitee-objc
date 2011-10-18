//
//  Created by Eric-Paul Lecluse @ 2011.
//
//  References:
//  http://forrst.com/posts/Delayed_Blocks_in_Objective_C-0Fn

#import <Foundation/Foundation.h>

@interface NSObject (Reusabilitee)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
