//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>

@interface NSString (Reusabilitee)

+ (BOOL)isEmpty:(NSString *)string;

+ (BOOL)isNotEmpty:(NSString *)string;

- (NSString *)formattedWith:(NSString *)format, ...;

@end
