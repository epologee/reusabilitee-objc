//
//  EEDelegateCluster.h
//
//  Created by Eric-Paul Lecluse.
//

#import <Foundation/Foundation.h>

@interface EEDelegateCluster : NSObject

- (void)addDelegate:(id)delegate;
- (BOOL)hasDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)performBlockOnDelegates:(void (^)(id delegate))delegateBlock;
- (NSInteger)count;

@end
