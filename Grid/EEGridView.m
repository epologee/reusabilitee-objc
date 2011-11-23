//
//  Created by Eric-Paul Lecluse on 18-11-11.
//

#import "EEGridView.h"

@interface EEGridView ()

@property (nonatomic, retain, readwrite) NSArray *gridPositionsForVisibleCells;
@property (nonatomic, retain, readwrite) NSMutableArray *visibleCells;
@property (nonatomic, retain) NSMutableSet *invisibleCells;
@property (nonatomic) CGSize gridSize;
@property (nonatomic) CGRect visibleArea;

- (void)updateCells;

@end

@implementation EEGridView

@synthesize gridPositionsForVisibleCells = gridPositionsForVisibleCells_;
@synthesize visibleCells = visibleCells_;
@synthesize invisibleCells = invisibleCells_;
@synthesize rows = rows_;
@synthesize columns = columns_;
@synthesize gridSize = gridSize_;
@synthesize visibleArea = visibleArea_;
@dynamic delegate;

- (id)initWithFrame:(CGRect)frame gridSize:(CGSize)gridSize
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.gridSize = gridSize;
        self.invisibleCells = [NSMutableSet set];
        self.gridPositionsForVisibleCells = [NSMutableArray array];
        self.visibleCells = [NSMutableArray array];
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)dealloc {
    self.gridPositionsForVisibleCells = nil;
    self.visibleCells = nil;
    self.invisibleCells = nil;
    
    [super dealloc];
}

- (void)reloadData
{
    if ([self.delegate respondsToSelector:@selector(gridViewWillReloadData:)])
    {
        [self.delegate gridViewWillReloadData:self];
    }
    
    self.columns = [self.delegate numberOfColumnsInGridView:self];
    self.rows = [self.delegate numberOfRowsInGridView:self];
    self.contentSize = CGSizeMake(self.columns * (self.bounds.size.width / self.gridSize.width), self.rows * (self.bounds.size.height / self.gridSize.height));
    
    DLog(@"Content size: %@", NSStringFromCGSize(self.contentSize));
    [self updateCells];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self reloadData];
}

- (void)updateCells
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGRect bounds = self.bounds;
    
    CGFloat columnWidth = self.bounds.size.width / self.gridSize.width;
    CGFloat rowHeight = self.bounds.size.height / self.gridSize.height;
    CGRect scaledGridRect = CGRectMake(bounds.origin.x / columnWidth, bounds.origin.y / rowHeight, self.gridSize.width, self.gridSize.height);
    CGRect clippedGridRect = scaledGridRect;
    clippedGridRect.origin.x = MAX(floor(CGRectGetMinX(scaledGridRect)), 0);
    clippedGridRect.origin.y = MAX(floor(CGRectGetMinY(scaledGridRect)), 0);
    clippedGridRect.size.width = ceil(CGRectGetMaxX(scaledGridRect) - CGRectGetMinX(clippedGridRect));
    clippedGridRect.size.height = ceil(CGRectGetMaxY(scaledGridRect) - CGRectGetMinY(clippedGridRect));
    
    NSInteger diff = self.columns - CGRectGetMaxX(clippedGridRect) + 1;
    if (diff < 0)
    {
        // we're peeking beyond the grid's bounds.
        clippedGridRect.size.width += diff;
    }
    
    diff = self.rows - CGRectGetMaxY(clippedGridRect) + 1;
    if (diff < 0)
    {
        // we're peeking beyond the grid's bounds.
        clippedGridRect.size.height += diff;
    }
    
    if (CGRectEqualToRect(clippedGridRect, visibleArea_))
    {
        return;
    }
    else
    {
        self.visibleArea = clippedGridRect;
    }
    
    NSMutableArray *gridPositions = [NSMutableArray array];
    for (NSInteger c = CGRectGetMinX(clippedGridRect); c < CGRectGetMaxX(clippedGridRect); c++)
        for (NSInteger r = CGRectGetMinY(clippedGridRect); r < CGRectGetMaxY(clippedGridRect); r++)
        {
            EEGridPosition *position = [EEGridPosition gridPositionForColumn:c row:r];
            [gridPositions addObject:position];
        }
    
    self.gridPositionsForVisibleCells = gridPositions;
    
    // Remove cells out of bounds
    for (EEGridViewCell *cell in [[self.visibleCells copy] autorelease]) {
        if (!CGRectContainsPoint(clippedGridRect, cell.gridPosition.point))
        {
            [invisibleCells_ addObject:cell];
            [visibleCells_ removeObject:cell];
            [cell removeFromSuperview];
            //            QuietLog(@"Removed cell at %@", cell.gridPosition);
        }
    }
    
    // Show visible cells
    for (EEGridPosition *gridPosition in gridPositions) {
        BOOL alreadyVisible = NO;
        for (EEGridViewCell *cell in visibleCells_) {
            if ([cell.gridPosition isEqual:gridPosition])
            {
                alreadyVisible = YES;
                break;
            }
        }
        
        if (!alreadyVisible)
        {
            EEGridViewCell *cell = [self.delegate gridView:self cellForGridPosition:gridPosition];
            cell.frame = CGRectMake(gridPosition.column * columnWidth, gridPosition.row * rowHeight, columnWidth, rowHeight);
            cell.gridPosition = gridPosition;
            cell.delegate = self;
            [self.visibleCells addObject:cell];
            [self addSubview:cell];
        }
    }
    
    [pool release];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self updateCells];
}

- (EEGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    EEGridViewCell *cell = nil;
    
    if ([self.invisibleCells count])
    {
        cell = [[[self.invisibleCells anyObject] retain] autorelease];
        [self.invisibleCells removeObject:cell];
        [cell prepareForReuse];
    }
    
    return cell;
}

- (EEGridPosition *)gridPositionForCellAtPoint:(CGPoint)point
{
    CGFloat columnWidth = self.bounds.size.width / self.gridSize.width;
    CGFloat rowHeight = self.bounds.size.height / self.gridSize.height;
    CGPoint downScaledPoint = CGPointMake(floor(point.x / columnWidth), floor(point.y / rowHeight));
    return [EEGridPosition gridPositionFromPoint:downScaledPoint];
}

- (CGPoint)pointForGridPosition:(EEGridPosition *)gridPosition
{
    CGFloat columnWidth = self.bounds.size.width / self.gridSize.width;
    CGFloat rowHeight = self.bounds.size.height / self.gridSize.height;
    CGPoint upScaledPoint = CGPointMake(gridPosition.column * columnWidth, gridPosition.row * rowHeight);
    return upScaledPoint;
}

- (void)didSelectGridViewCell:(EEGridViewCell *)cell
{
    [self.delegate gridView:self didSelectCellAtGridPosition:cell.gridPosition];
}

- (void)didDeselectGridViewCell:(EEGridViewCell *)cell
{
    // void.
}

@end