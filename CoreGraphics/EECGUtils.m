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

#pragma mark -
#pragma mark Image drawing

+ (void)drawImage:(CGImageRef)image inRect:(CGRect)rect ofContext:(CGContextRef)context 
{
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0, rect.origin.y);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -(rect.origin.y + rect.size.height));
    
    CGContextDrawImage(context, rect, image);
    
    CGContextRestoreGState(context);
}

+ (void)drawStretchableImage:(CGImageRef)sourceImage withLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight scale:(CGFloat)scale inRect:(CGRect)targetRect ofContext:(CGContextRef)context
{
    NSInteger imageWidth = CGImageGetWidth(sourceImage) / scale;
    NSInteger imageHeight = CGImageGetHeight(sourceImage) / scale;
    
    NSInteger cols[4];
    cols[0] = 0;
    cols[1] = leftCapWidth;
    cols[2] = (leftCapWidth + 1);
    cols[3] = imageWidth;
    
    NSInteger rows[4];
    rows[0] = 0;
    rows[1] = topCapHeight;
    rows[2] = (topCapHeight + 1);
    rows[3] = imageHeight;

    NSInteger dCols[4];
    dCols[0] = 0;
    dCols[1] = leftCapWidth;
    dCols[2] = MAX(targetRect.size.width - (imageWidth - 1 - leftCapWidth), leftCapWidth);
    dCols[3] = targetRect.size.width;
    
    // The rows are flipped to compensate for the flipped CurrentTransformMatrix.
    NSInteger dRows[4];
    dRows[3] = 0;
    dRows[2] = topCapHeight;
    dRows[1] = MAX(targetRect.size.height - (imageHeight - 1 - topCapHeight), topCapHeight);
    dRows[0] = targetRect.size.height;
    
    CGAffineTransform scaleUp = CGAffineTransformMakeScale(scale, scale);

    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0, targetRect.origin.y);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -(targetRect.origin.y + targetRect.size.height));

    for (NSInteger r = 0; r < 3; r++)
        for (NSInteger c = 0; c < 3; c++)
        {
            // Cut a slice from the image, corrected for retina images.
            CGRect sliceRect = CGRectMake(cols[c], rows[r], cols[c+1] - cols[c], rows[r+1] - rows[r]);
            CGImageRef sliceImage = CGImageCreateWithImageInRect(sourceImage, CGRectApplyAffineTransform(sliceRect, scaleUp));
            
            // Draw the slice into the target rect
            CGRect dSliceRect = CGRectMake(dCols[c], dRows[r], dCols[c+1] - dCols[c], dRows[r+1] - dRows[r]);
            CGContextDrawImage(context, dSliceRect, sliceImage);
            CGImageRelease(sliceImage);
        }
    
    CGContextRestoreGState(context);
}

@end
