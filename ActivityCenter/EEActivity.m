//
//  EEActivity.m
//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "EEActivity.h"
#import "EEActivityCenter.h"
#import "../DelegateCluster/EEDelegateCluster.h"

@interface EEActivity ()

@property(nonatomic, copy, readwrite) id context;
@property(nonatomic, copy, readwrite) NSString *name;
@property(nonatomic, copy, readwrite) NSString *identifier;
@property(nonatomic, readwrite) ActivityStatus status;
@property(nonatomic, readwrite) CGFloat progress;

@property(nonatomic, retain) EEDelegateCluster *delegates;

@end

@implementation EEActivity

@synthesize context = context_;
@synthesize name = name_;
@synthesize label = label_;
@synthesize identifier = identifier_;
@synthesize status = status_;
@synthesize dateStarted = dateStarted_;
@synthesize progress = progress_;
@synthesize delegates = delegates_;
@synthesize keepHistory = keepHistory_;
@synthesize feedbackOptions = feedbackOptions_;
@synthesize instantDelegation = instantDelegation_;

+ (NSString *)identifierForName:(NSString *)name andContext:(id)context
{
    if (context != nil)
    {
        return [NSString stringWithFormat:@"%@/%@", context, name];
    }

    return [NSString stringWithFormat:@"%@", name];
}

- (id)initWithName:(NSString *)name andContext:(id)context
{
    self = [super init];

    if (self)
    {
        self.name = name;
        self.context = context;
        self.identifier = [[self class] identifierForName:name andContext:context];
        self.status = kActivityStatusReady;
        self.progress = 0;
        self.keepHistory = NO;
        self.feedbackOptions = kActivityFeedbackNone;
        self.instantDelegation = NO;

        self.delegates = [[[EEDelegateCluster alloc] init] autorelease];
    }

    return self;
}

- (BOOL)isActive
{
    return self.status == kActivityStatusBusy;
}

- (NSString *)label
{
    if (label_ != nil)
    {
        return label_;
    }
    return self.name;
}

- (void)dealloc
{
    self.identifier = nil;
    self.delegates = nil;
    self.name = nil;
    self.dateStarted = nil;
    self.label = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Delegation

- (void)addDelegate:(id <ActivityDelegate>)delegate
{
    [self.delegates addDelegate:delegate];

    if ([self isActive] && self.instantDelegation)
    {
        if ([delegate respondsToSelector:@selector(activityStarted:)])
        {
            [delegate activityStarted:self];
        }

        if ([delegate respondsToSelector:@selector(activity:updatedProgress:)])
        {
            [delegate activity:self updatedProgress:self.progress];
        }
    }
}

- (void)removeDelegate:(id <ActivityDelegate>)delegate
{
    [self.delegates removeDelegate:delegate];
}

#pragma mark -
#pragma mark Status changes

- (void)started
{
    self.dateStarted = [NSDate date];
    NSLog(@"%@", self);

    [self.delegates performBlockOnDelegates:^(id <ActivityDelegate> delegate)
                                            {
                                                if ([delegate respondsToSelector:@selector(activityStarted:)])
                                                {
                                                    [delegate activityStarted:self];
                                                }
                                            }];

    [self updatedProgress:0];
}

- (void)updatedProgress:(CGFloat)progress
{
    self.status = kActivityStatusBusy;
    self.progress = MIN(MAX(progress, 0), 1);
    NSLog(@"%@", self);

    [self.delegates performBlockOnDelegates:^(id <ActivityDelegate> delegate)
                                            {
                                                if ([delegate respondsToSelector:@selector(activity:updatedProgress:)])
                                                {
                                                    [delegate activity:self updatedProgress:progress];
                                                }
                                            }];
}

- (void)finished:(BOOL)success
{
    if (self.progress < 1)
    {
        [self updatedProgress:1];
    }

    self.status = success ? kActivityStatusSuccess : kActivityStatusFailure;
    NSLog(@"%@", self);

    [self.delegates performBlockOnDelegates:^(id <ActivityDelegate> delegate)
                                            {
                                                if ([delegate respondsToSelector:@selector(activity:finished:)])
                                                {
                                                    [delegate activity:self finished:success];
                                                }
                                            }];
}

- (BOOL)endOfLife
{
    // If the status is busy, someone is still working the activity.
    if (self.status == kActivityStatusBusy)
    {
        return NO;
    }

    // If multiple delegates are still listening, this activity is not done yet.
    if ([self.delegates count] > 1)
    {
        return NO;
    }

    // Since the ActivityCenter should always be the last active delegate, we're not done if there are others listening.
    if (([self.delegates count] == 1) && ![self.delegates hasDelegate:[EEActivityCenter instance]])
    {
        return NO;
    }

    // We're in limbo.
    return YES;
}

- (NSString *)statusDescription
{
    NSString *s = @"";

    switch (self.status)
    {
        case kActivityStatusReady:
            s = @"ready";
            break;
        case kActivityStatusBusy:
            s = @"busy";
            break;
        case kActivityStatusSuccess:
            s = @"success";
            break;
        case kActivityStatusFailure:
            s = @"failure";
            break;
    }

    return s;
}

- (NSString *)description
{
    NSString *p = @"";

    if (self.status == kActivityStatusBusy && 0 < self.progress && self.progress < 1)
    {
        p = [NSString stringWithFormat:@" (%0.0f%%)", round(self.progress * 1000) / 10.0];
    }

    return [NSString stringWithFormat:@"<%@ %@: %@%@>", [self class], self.identifier, [self statusDescription], p];
}

@end
