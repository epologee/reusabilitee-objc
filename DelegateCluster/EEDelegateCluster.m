//
//  EEDelegateCluster.m
//
//  Created by Eric-Paul Lecluse.
//

#import "EEDelegateCluster.h"

@interface EEDelegateCluster ()

@property (nonatomic, retain) NSMutableSet *delegatePointers;

@end
@implementation EEDelegateCluster

@synthesize delegatePointers = delegatePointers_;

- (id)init
{
    self = [super init];
    if (self) {
        self.delegatePointers = [NSMutableSet set];
    }
    
    return self;
}

- (void)dealloc {
    self.delegatePointers = nil;
    
    [super dealloc];
}

- (void)addDelegate:(id)delegate
{
    // Use NSValue pointers to break the retention on the delegate.
    // The reverse is [delegatePointer pointerValue].
    NSValue *delegateValue = [NSValue valueWithPointer:delegate];
    
    if ([self hasDelegate:delegate]) return;
    
    [self.delegatePointers addObject:delegateValue];
}

- (BOOL)hasDelegate:(id)delegate
{
    for (NSValue *delegateValue in self.delegatePointers) {
        if ([delegateValue pointerValue] == delegate) return YES;
    }
    
    return NO;
}

- (void)removeDelegate:(id)delegate
{
    NSMutableSet *remove = [NSMutableSet set];
    
    for (NSValue *delegateValue in self.delegatePointers) {
        if ([delegateValue pointerValue] == delegate)
        {
            [remove addObject:delegateValue];
        }
    }
    
    [self.delegatePointers minusSet:remove];
}

- (void)performBlockOnDelegates:(void (^)(id delegate))delegateBlock
{
    dispatch_queue_t main = dispatch_get_main_queue();
    
    for (NSValue *delegateValue in self.delegatePointers) {
        __block id delegate = [delegateValue pointerValue];
        dispatch_async(main, ^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            delegateBlock(delegate);
            [pool release];
        });
    }
}

- (NSInteger)count
{
    return [self.delegatePointers count];
}

@end
