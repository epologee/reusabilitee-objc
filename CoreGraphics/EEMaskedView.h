//
//  Created by Eric-Paul Lecluse on 17-11-11.
//

#import <UIKit/UIKit.h>

@interface EEMaskedView : UIView

@property (nonatomic, retain) UIColor *iconColor;

- (void)setMaskFromImage:(UIImage *)image;

@end
