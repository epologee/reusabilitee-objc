//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "EEActivityCenter.h"

#define MAX_HISTORY 20

@interface EEActivityCenter ()

@property (nonatomic, retain) NSMutableSet *activities;
@property (nonatomic, retain) NSMutableArray *history;

- (void)addToHistory:(EEActivity *)activity;

@end

@implementation EEActivityCenter

@synthesize activities = activities_;
@synthesize history = history_;
@synthesize centralDelegate = centralDelegate_;

- (id)init
{
    self = [super init];
    if (self) {
        self.activities = [NSMutableSet set];
        self.history = [NSMutableArray array];
    }
    
    return self;
}

- (BOOL)isActive
{
    return [self.activities count] > 0;
}

- (void)dealloc {
    self.activities = nil;
    self.history = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Delegation

- (void)setDelegate:(id <ActivityDelegate>)delegate forActivity:(NSString *)name andContext:(NSString *)context
{
    [[self activityWithName:name context:context] addDelegate:delegate];
}

- (void)invalidateDelegate:(id <ActivityDelegate>)delegate
{
    NSMutableSet *remove = [NSMutableSet set];
    
    for (EEActivity *activity in self.activities) {
        [activity removeDelegate:delegate];
        
        if ([activity endOfLife])
        {
            [remove addObject:activity];
        }
    }
    
    [self.activities minusSet:remove];
}

- (EEActivity *)activityWithName:(NSString *)name
{
    return [self activityWithName:name context:nil];
}

- (EEActivity *)activityWithName:(NSString *)name context:(id)context
{
    NSString *identifier = [EEActivity identifierForName:name andContext:context];
    
    for (EEActivity *activity in self.activities) {
        if ([activity.identifier isEqualToString:identifier])
        {
            return activity;
        }
    }
    
    EEActivity *activity = [[[EEActivity alloc] initWithName:name andContext:context] autorelease];
    [self.activities addObject:activity];
    [activity addDelegate:self];
    return activity;
}

- (void)activityStarted:(EEActivity *)activity
{
    if ((activity.feedbackOptions & kActivityFeedbackStart) && [self.centralDelegate respondsToSelector:@selector(activityStarted:)])
    {
        [self.centralDelegate activityStarted:activity];
    }
}

- (void)activity:(EEActivity *)activity updatedProgress:(CGFloat)progress
{
    if ((activity.feedbackOptions & kActivityFeedbackProgress) && [self.centralDelegate respondsToSelector:@selector(activity:updatedProgress:)])
    {
        [self.centralDelegate activity:activity updatedProgress:progress];
    }
}

- (void)activity:(EEActivity *)activity finished:(BOOL)success
{
    [activity removeDelegate:self];
    
    if ((activity.feedbackOptions & kActivityFeedbackFinish) && [self.centralDelegate respondsToSelector:@selector(activity:finished:)])
    {
        [self.centralDelegate activity:activity finished:success];
    }
    
    if (activity.keepHistory)
    {
        [self addToHistory:activity];
    }
    
    [self.activities removeObject:activity];

    NSLog(@"Active: %i | History: %i", [self.activities count], [self.history count]);
}

- (void)addToHistory:(EEActivity *)activity
{
    [self.history insertObject:activity atIndex:0];
    
    while ([self.history count] > MAX_HISTORY)
    {
        [self.history removeLastObject];
    }
    
    NSLog(@"New history: \n%@", self.history);
}

@end
