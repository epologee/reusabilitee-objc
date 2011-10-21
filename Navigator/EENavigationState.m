//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import "EENavigationState.h"

@interface EENavigationState ()

-(id)initWithString:(NSString *)path;
-(id)initWithSegments:(NSArray *)segments;

@end

@implementation EENavigationState

@synthesize segments=segments_;

+(EENavigationState *)stateWithString:(NSString *)path {
    return [[[EENavigationState alloc] initWithString:path] autorelease];
}

+(EENavigationState *)stateWithSegments:(NSArray *)segments {
    return [[[EENavigationState alloc] initWithSegments:segments] autorelease];
}

-(id)initWithString:(NSString *)path {
    self = [super init];
    
    if (self) {
        self.path = path;
    }
    
    return self;
}

-(id)initWithSegments:(NSArray *)segments {
    self = [super init];
    
    if (self) {
        self.segments = [[segments mutableCopy] autorelease];
    }
    
    return self;
}

-(void)dealloc {
    self.segments = nil;
    
    [super dealloc];
}

-(NSString *)path {
    if ([self.segments count] == 0) return @"/";
    return [NSString stringWithFormat:@"/%@/", [self.segments componentsJoinedByString:@"/"]];
}

-(void)setPath:(NSString *)path {
    self.segments = [[[[path stringByReplacingOccurrencesOfString:@" " withString:@"-"] componentsSeparatedByString:@"/"] mutableCopy] autorelease];
}

-(void)setSegments:(NSMutableArray *)segments {
    [segments_ release];

    if (segments != nil) {
        NSMutableArray *builder = [[NSMutableArray alloc] init];
        
        for (NSString *segment in segments) {
            if ([segment length] > 0) {
                [builder addObject:segment];
            }
        }
        
        segments_ = [builder mutableCopy];
        [builder release];
        return;
    }
    
    segments_ = nil;
}

-(BOOL)equals:(EENavigationState *)foreign {
    return [self contains:foreign] && [foreign contains:self];
}

-(BOOL)contains:(EENavigationState *)foreign {
    if ([foreign.segments count] > [self.segments count]) return NO;
    
    int index = 0;
    for (NSString *foreignSegment in foreign.segments) {
        NSString *nativeSegment = [self.segments objectAtIndex:index];
        index++;

        if ([foreignSegment isEqualToString:@"*"] || [nativeSegment isEqualToString:@"*"]) {
            // Matches because of the wildcard
        } else if (![foreignSegment isEqualToString:nativeSegment]) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)hasWildcards {
    NSUInteger index = [self.segments indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isEqualToString:@"*"];
    }];
    
    return index != NSNotFound;
}

-(EENavigationState *)mask:(EENavigationState *)mask {
    NSMutableArray *unmasked = [[self.segments mutableCopy] autorelease];
    
    int length = MIN([self.segments count], [mask.segments count]);
    for (int i = 0; i < length; i++) {
        if ([[unmasked objectAtIndex:i] isEqualToString:@"*"]) {
            [unmasked replaceObjectAtIndex:i withObject:[mask.segments objectAtIndex:i]];
        }
    }
    
    return [EENavigationState stateWithSegments:unmasked];
}

-(EENavigationState *)truncate:(EENavigationState *)operand {
    if (![self contains:operand]) return nil;
    
    EENavigationState *truncated = [EENavigationState stateWithSegments:self.segments];
    [truncated.segments removeObjectsInRange:NSMakeRange(0, [operand.segments count])];
    
    return truncated;
}

-(EENavigationState *)append:(NSString *)path {
    return [[self.path stringByAppendingString:path] toState];
}

-(EENavigationState *)shortenTo:(NSUInteger)segmentLength {
    EENavigationState *shortened = [self.segments toState];
    
    while ([shortened.segments count] > segmentLength) {
        [shortened.segments removeLastObject];
    }
    
    return shortened;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[State: %@]", self.path];
}

@end
