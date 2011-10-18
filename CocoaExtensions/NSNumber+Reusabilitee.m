//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSNumber+Reusabilitee.h"

@implementation NSNumber (Reusabilitee)

+ (BOOL)isEmpty:(NSNumber *)number
{
    return (number == nil) || [[NSNumber numberWithInt:0] isEqualToNumber:number];
}

+ (BOOL)isNotEmpty:(NSNumber *)number
{
    return ![self isEmpty:number];
}

@end
