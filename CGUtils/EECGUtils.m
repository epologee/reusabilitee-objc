//
//  EPCGUtils.m
//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "EECGUtils.h"


@implementation EECGUtils

#pragma mark -
#pragma mark Class methods
+(CGRect)alignCenterRect:(CGRect)rectA toRect:(CGRect)rectB useOriginOffset:(BOOL)useOriginOffset {
	rectA.origin.x = rectB.size.width / 2 - rectA.size.width / 2;
	rectA.origin.y = rectB.size.height / 2 - rectA.size.height / 2;
	
	if (useOriginOffset) {
		rectA.origin.x += rectB.origin.x;
		rectA.origin.y += rectB.origin.y;
	}
	
	rectA.origin.x = round(rectA.origin.x);
	rectA.origin.y = round(rectA.origin.y);
	
	return rectA;
}

+(CGRect)alignRect:(CGRect)rectA toRect:(CGRect)rectB options:(AlignOptions)options padding:(CGFloat)padding
{
    if (options & kAlignLeft)
    {
        rectA.origin.x = rectB.origin.x + padding;
    }
    else if (options & kAlignCenterHorizontally)
    {
        rectA.origin.x = rectB.origin.x + (rectB.size.width - rectA.size.width) / 2;
    }
    else if (options & kAlignRight)
    {
        rectA.origin.x = rectB.origin.x + rectB.size.width - rectA.size.width - padding;
    }
    
    if (options & kAlignTop)
    {
        rectA.origin.y = rectB.origin.y + padding;
    }
    else if (options & kAlignCenterVertically)
    {
        rectA.origin.y = rectB.origin.y + (rectB.size.height - rectA.size.height) / 2;
    }
    else if (options & kAlignBottom)
    {
        rectA.origin.y = rectB.origin.y + rectB.size.height - rectA.size.height - padding;
    }
    
    return rectA;
}

+(CGRect)expandRect:(CGRect)rect withHorizontal:(CGFloat)horizontal andVertical:(CGFloat)vertical {
	rect.origin.x -= horizontal;
	rect.origin.y -= vertical;
	rect.size.width += horizontal * 2;
	rect.size.height += vertical * 2;
	return rect;
}

+(CGRect)expandRect:(CGRect)rect withEqual:(CGFloat)margin {
	return [self expandRect:rect withHorizontal:margin andVertical:margin];
}

+(CGRect)sizeRect:(CGRect)rect to:(CGSize)size {
	rect.size.width = size.width;
	rect.size.height = size.height;
	return rect;
}

+(CGRect)positionRect:(CGRect)rect at:(CGPoint)point {
	rect.origin.x = point.x;
	rect.origin.y = point.y;
	return rect;
}

+(CGRect)rectWithOrigin:(CGPoint)origin size:(CGSize)size {
	return CGRectMake(origin.x, origin.y, size.width, size.height);
}

+(CGRect)trimRect:(CGRect)rect top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
	rect.origin.y += top;
	rect.size.height -= top;
	rect.size.height -= bottom;
	
	rect.origin.x += left;
	rect.size.width -= left;
	rect.size.width -= right;
	
	return rect;
}

@end
