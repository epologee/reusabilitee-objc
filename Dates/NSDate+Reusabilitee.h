//
//  NSDate+GetTogether.h
//
//  Created by Eric-Paul Lecluse @ 2011
//

#import <Foundation/Foundation.h>


@interface NSDate (Reusabilitee)

+ (NSInteger)firstWeekDay;
- (NSDate *)firstSecondOfTheDay;
- (NSDate *)weekStart;
- (NSDate *)weekEnd;
- (NSDate *)firstSecondOfTheMonth;
- (NSDate *)lastSecondOfTheMonth;
- (NSDate *)firstSecondOfTheYear;
- (NSDate *)lastSecondOfTheYear;

@end

@interface NSDateFormatter (Reusabilitee)

+(NSDateFormatter *)formatterWithFormat:(NSString *)format;

@end
