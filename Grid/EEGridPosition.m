//
//  EEGridPosition.m
//
//  Created by Eric-Paul Lecluse on 18-11-11.
//

#import "EEGridPosition.h"

@implementation EEGridPosition

@synthesize row = row_;
@synthesize column = column_;

+ (EEGridPosition *)gridPositionFromPoint:(CGPoint)point
{
    return [EEGridPosition gridPositionForColumn:floor(point.x) row:floor(point.y)];
}

+ (EEGridPosition *)gridPositionForColumn:(NSInteger)column row:(NSInteger)row
{
    EEGridPosition *position = [[[EEGridPosition alloc] init] autorelease];
    position.row = row;
    position.column = column;
    return position;
}

- (CGPoint)point
{
    return CGPointMake(column_, row_);
}

- (BOOL)isEqual:(EEGridPosition *)object
{
    return object.row == self.row && object.column == self.column;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<GridPosition (c%i, r%i)>", self.column, self.row];
}

@end
