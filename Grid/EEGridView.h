//
//  Created by Eric-Paul Lecluse on 18-11-11.
//

#import <UIKit/UIKit.h>
#import "EEGridViewCell.h"
#import "EEGridPosition.h"

@class EEGridView;

#pragma mark -
#pragma mark Delegate and Data Source combined.

@protocol EEGridViewDelegateAndDataSource <NSObject, UIScrollViewDelegate>

@required
- (NSInteger)numberOfColumnsInGridView:(EEGridView *)gridView;
- (NSInteger)numberOfRowsInGridView:(EEGridView *)gridView;
- (EEGridViewCell *)gridView:(EEGridView *)gridView cellForGridPosition:(EEGridPosition *)gridPosition;
- (void)gridView:(EEGridView *)gridView didSelectCellAtGridPosition:(EEGridPosition *)gridPosition;

@optional
- (void)gridViewWillReloadData:(EEGridView *)gridView;

@end

#pragma mark -
#pragma mark Interface

@interface EEGridView : UIScrollView <EEGridViewCellDelegate>

@property (nonatomic, retain, readonly) NSMutableArray *visibleCells;
@property (nonatomic, assign) id <EEGridViewDelegateAndDataSource>delegate;

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger columns;

- (id)initWithFrame:(CGRect)frame gridSize:(CGSize)gridSize;
- (EEGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier;
- (EEGridPosition *)gridPositionForCellAtPoint:(CGPoint)point;
- (CGPoint)pointForGridPosition:(EEGridPosition *)gridPosition;

@end

