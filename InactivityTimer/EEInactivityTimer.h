//
//  EEInactivityTimer.h
//
//  Created by Eric-Paul Lecluse @ 2011
//

#import <Foundation/Foundation.h>


@interface EEInactivityTimer : NSObject

-(id)initWithInactivity:(NSTimeInterval)inactivity target:(id)target selector:(SEL)selector;

-(void)reportActivity;
-(void)trigger;

@end
