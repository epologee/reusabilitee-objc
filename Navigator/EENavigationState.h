//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import <Foundation/Foundation.h>

@interface EENavigationState : NSObject

+(EENavigationState *)stateWithString:(NSString *)path;
+(EENavigationState *)stateWithSegments:(NSArray *)segments;

@property (nonatomic, retain) NSMutableArray *segments;
@property (nonatomic, copy) NSString *path;

// Tests
-(BOOL)equals:(EENavigationState *)foreign;
-(BOOL)contains:(EENavigationState *)foreign;
-(BOOL)hasWildcards;

// Modifications
-(EENavigationState *)mask:(EENavigationState *)mask;
-(EENavigationState *)truncate:(EENavigationState *)operand;
-(EENavigationState *)append:(NSString *)path;
-(EENavigationState *)shortenTo:(NSUInteger)segmentLength;

@end

@interface NSString (EENavigationState)

-(EENavigationState *)toState;

@end

@implementation NSString (EENavigationState)

-(EENavigationState *)toState {
    return [EENavigationState stateWithString:self];
}

@end

@interface NSArray (EENavigationState)

-(EENavigationState *)toState;

@end

@implementation NSArray (EENavigationState)

-(EENavigationState *)toState {
    return [EENavigationState stateWithSegments:self];
}

@end