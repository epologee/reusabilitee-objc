//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>

@interface EEDelegateCluster : NSObject

@property (nonatomic) BOOL callDelegatesOnMainThread;

- (void)addDelegate:(id)delegate;
- (BOOL)hasDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)performBlockOnDelegates:(void (^)(id delegate))delegateBlock;
- (void)performBlockOnDelegates:(void (^)(id delegate))delegateBlock afterDelay:(NSTimeInterval)delay;
- (NSInteger)count;

@end

/**
* Implement this protocol if you want to keep a consistent API scheme
* when using the `EEDelegateCluster` to add multiple delegates to a class.
*/
@protocol EEClusterDelegation <NSObject>

@property (nonatomic, retain) EEDelegateCluster *delegateCluster;

@end