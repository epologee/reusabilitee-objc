//
//  Created by Eric-Paul Lecluse - @epologee - 2011.
//


#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "EECTUtils.h"

@implementation EECTUtils

+ (void)drawText:(NSString *)text inRect:(CGRect)rect
{
    [self drawText:text inRect:rect ofContext:UIGraphicsGetCurrentContext()];
}

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context
{
    [self drawText:text inRect:rect ofContext:context withColor:[[UIColor blackColor] CGColor]];
}

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context withColor:(CGColorRef)color
{
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 13.0, NULL);
    [self drawText:text inRect:rect ofContext:context withColor:color font:font];
    CFRelease(font);
}

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context withColor:(CGColorRef)color font:(CTFontRef)font
{
    [self drawText:text inRect:rect ofContext:context withColor:color font:font center:YES];
}

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context withColor:(CGColorRef)color font:(CTFontRef)font center:(BOOL)center
{
    if (text == nil) return;

    @synchronized(self)
    {
        NSMutableAttributedString *composite = [[NSMutableAttributedString alloc] initWithString:text];
        
        // Color
        [composite addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color range:NSMakeRange(0, [text length])];
        
        // Font
        [composite addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:NSMakeRange(0, [text length])];
        
        /**
         TODO: Sometimes the compiler hangs here with an EXC_BAD_ACCESS(code=2, address=0x...)
         It claims that there is a pointer being freed without it being allocated, but what pointer is it and where is it freed???
         If and when it does, please check if it only happens on the simulator or also on iOS devices.
         Until now, this has only happened to me in the simulator :S
         */
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)composite);
        CGSize suggested = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, rect.size, NULL);
        
        if (suggested.width > rect.size.width)
        {
            // rect needs to be bigger.
            rect.size.width = suggested.width;
        }
        
        if (suggested.height < rect.size.height)
        {
            // Align to center
            rect.origin.y += (rect.size.height - suggested.height) / 2 - 1.0;
            // Add 1.0, for otherwise the text is not drawn :S
            rect.size.height = suggested.height + 1.0;
        }
        
        if (center)
        {
            // one row, center horizontally
            rect.origin.x += (rect.size.width - suggested.width) / 2 - 1.0;
            rect.size.width = suggested.width + 1.0;
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);
        CFRange compositeRange = CFRangeMake(0, [composite length]);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, compositeRange, path, NULL);
        CFRelease(framesetter);
        CFRelease(path);
        
        if (frame)
        {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, 0, rect.origin.y);
            CGContextScaleCTM(context, 1, -1);
            CGContextTranslateCTM(context, 0, -(rect.origin.y + rect.size.height));
            
            CTFrameDraw(frame, context);
            
            CGContextRestoreGState(context);
            CFRelease(frame);
        }
        
        [composite release];
    }
}

@end