//
//  Created by Eric-Paul Lecluse on 17-11-11.
//

#import "EEMaskedView.h"
#import "EECGUtils.h"

@interface EEMaskedView ()

@end

@implementation EEMaskedView
{
    CGImageRef alphaMask_;
}

@synthesize iconColor = iconColor_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.iconColor = [UIColor yellowColor];
    }
    return self;
}

- (void)dealloc {
    CGImageRelease(alphaMask_);
    self.iconColor = nil;
    
    [super dealloc];
}

- (void)setIconColor:(UIColor *)iconColor
{
    [iconColor retain];
    [iconColor_ release];
    iconColor_ = iconColor;
    
    [self setNeedsDisplay];
}

- (void)setMaskFromImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaNone);

    // Clear the rect with white:
    CGContextSetFillColor(context, (CGFloat[]){1, 1, 1});
    CGContextFillRect(context, rect);
    
    // Draw the image on top (black shape with tranparency): 
    [EECGUtils drawImage:image.CGImage inRect:rect ofContext:context];

    // Cover the image with an all white layer with the difference blend mode, to invert the image.
    CGContextSetBlendMode(context, kCGBlendModeDifference);
    CGContextFillRect(context, rect);

    // Create an image mask from what we've drawn so far and release any previous ones.
    CGImageRelease(alphaMask_);
    alphaMask_ = CGBitmapContextCreateImage(context);

    CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (alphaMask_ != NULL) 
    {
        CGContextClipToMask(context, rect, alphaMask_);
        [self.iconColor setFill];
        CGContextFillRect(context, rect);
    }
}

@end
