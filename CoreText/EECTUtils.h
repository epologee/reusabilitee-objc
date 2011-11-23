//
//  Created by Eric-Paul Lecluse - @epologee - 2011.
//


#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface EECTUtils : NSObject

+ (void)drawText:(NSString *)text inRect:(CGRect)rect;

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context;

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context withColor:(CGColorRef)color;

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context withColor:(CGColorRef)color font:(CTFontRef)font;

+ (void)drawText:(NSString *)text inRect:(CGRect)rect ofContext:(CGContextRef)context withColor:(CGColorRef)color font:(CTFontRef)font center:(BOOL)center;

@end