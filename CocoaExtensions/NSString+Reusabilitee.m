//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSString+Reusabilitee.h"

@implementation NSString (Reusabilitee)

+ (BOOL)isEmpty:(NSString *)string
{
    return (string == nil) || [@"" isEqualToString:string];
}

+ (BOOL)isNotEmpty:(NSString *)string
{
    return (string != nil) && ![@"" isEqualToString:string];
}

- (NSString *)formattedWith:(NSString *)arguments, ...
{
    va_list list;
    va_start(list, arguments);
    NSString *formatted = [[[NSString alloc] initWithFormat:self arguments:list] autorelease];
    va_end(list);
    return formatted;
}

@end
