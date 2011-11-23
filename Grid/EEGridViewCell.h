//
//  Created by Eric-Paul Lecluse on 18-11-11.
//

#import <UIKit/UIKit.h>

@class EEGridView, EEGridPosition;

@protocol EEGridViewCellDelegate;

@interface EEGridViewCell : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;
@property (nonatomic, retain) EEGridPosition *gridPosition;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL highlighted;
@property (nonatomic, assign) id <EEGridViewCellDelegate>delegate;

+ (id)createOrDequeueFromGridView:(EEGridView *)gridView withFeedback:(BOOL *)created;

/**
 Feels like home, doesn't it?
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 Override and do not call super.
 */
- (void)drawRect:(CGRect)rect selected:(BOOL)selected highlighted:(BOOL)highlighted;

/**
 For resetting stuff before reuse.
 */
- (void)prepareForReuse;

@end

@protocol EEGridViewCellDelegate <NSObject>

- (void)didSelectGridViewCell:(EEGridViewCell *)cell;
- (void)didDeselectGridViewCell:(EEGridViewCell *)cell;

@end