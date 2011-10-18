//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <UIKit/UIKit.h>

typedef enum {
    kAlignNone = 0,
    kAlignLeft = 1,
    kAlignCenterHorizontally = 1 << 1,
    kAlignRight = 1 << 2,
    kAlignTop = 1 << 3,
    kAlignCenterVertically = 1 << 4,
    kAlignBottom = 1 << 5,
} AlignOptions;

@interface EECGUtils : NSObject

+(CGRect)alignCenterRect:(CGRect)rectA toRect:(CGRect)rectB useOriginOffset:(BOOL)useOriginOffset;
+(CGRect)alignRect:(CGRect)rectA toRect:(CGRect)rectB options:(AlignOptions)options padding:(CGFloat)padding;
+(CGRect)expandRect:(CGRect)rect withHorizontal:(CGFloat)horizontal andVertical:(CGFloat)vertical;
+(CGRect)expandRect:(CGRect)rect withEqual:(CGFloat)margin;
+(CGRect)positionRect:(CGRect)rect at:(CGPoint)point;
+(CGRect)sizeRect:(CGRect)rect to:(CGSize)size;
+(CGRect)rectWithOrigin:(CGPoint)origin size:(CGSize)size;
+(CGRect)trimRect:(CGRect)rect top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;


@end
