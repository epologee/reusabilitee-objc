//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "EEInactivityTimer.h"

@interface EEInactivityTimer ()

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic) NSTimeInterval inactivity;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSDate *activity;

-(void)testInactivity:(NSTimer*)timer;

@end

@implementation EEInactivityTimer

@synthesize target = target_;
@synthesize selector = selector_;
@synthesize inactivity = inactivity_;
@synthesize timer = timer_;
@synthesize activity = activity_;

-(id)initWithInactivity:(NSTimeInterval)inactivity target:(id)target selector:(SEL)selector
{
    self = [super init];
    
    if (self)
    {
        self.inactivity = inactivity;
        self.target = target;
        self.selector = selector;
    }
    
    return self;
}

-(void)dealloc
{
    self.target = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.activity = nil;
    
    [super dealloc];
}

-(void)reportActivity
{
    self.activity = [NSDate date];
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:0.25 target:self selector:@selector(testInactivity:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)testInactivity:(NSTimer*)timer
{
    NSTimeInterval elapsed = -[self.activity timeIntervalSinceNow];
    if (elapsed > self.inactivity)
    {
        [self trigger];
    }
}

-(void)trigger 
{
    [self.timer invalidate];
    [self.target performSelector:self.selector withObject:nil];
}

@end
