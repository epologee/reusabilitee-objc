//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import <Foundation/Foundation.h>

@interface EENavigationState : NSObject <NSCopying>

@property (nonatomic, retain) NSMutableArray *segments;
@property (nonatomic, copy) NSString *path;

+ (EENavigationState *)stateWithString:(NSString *)path;
+ (EENavigationState *)stateWithSegments:(NSArray *)segments;

#pragma mark -
#pragma mark Comparisons & logic tests

- (BOOL)equals:(EENavigationState *)foreign;
- (BOOL)contains:(EENavigationState *)foreign;
- (BOOL)hasWildcards;

#pragma mark -
#pragma mark Modifications

/**
 Overwrite wildcard segments "*" in this state with segments from the mask.
 The length of the result will not be altered by the masking. 
 */
/// `/*/*/c` masked with `/a/b/` results in `/a/b/c/`
/// `*/*/c` masked with `a/*/d` results in `/a/*/c/`
/// `*/*/c` masked with `a/b/c/d` results in `/a/b/c/`
- (EENavigationState *)mask:(EENavigationState *)mask;

/**
 Chop segments off the *beginning* of the current state, so the tail of a state remains.
 */
- (EENavigationState *)truncate:(EENavigationState *)operand;

/**
 Chop segments off the *end* of the current state, so the head of a state remains.
 */
- (EENavigationState *)shortenTo:(NSUInteger)segmentLength;

/**
 Append segments to the *end* of the current state. 
 */
- (EENavigationState *)append:(NSString *)path;


@end

@interface NSString (EENavigationState)

- (EENavigationState *)stateFromPath;

@end

@interface NSArray (EENavigationState)

- (EENavigationState *)stateFromSegments;

@end