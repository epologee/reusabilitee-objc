//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSBundle+Reusabilitee.h"

@implementation NSBundle (Reusabilitee)

- (NSString *)stringWithContentsOfResource:(NSString *)resource ofType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
