//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>


@interface NSDate (Reusabilitee)

+ (NSInteger)firstWeekDay;

- (NSDate *)firstSecondOfTheDay;
- (NSDate *)lastSecondOfTheDay;

- (NSDate *)firstSecondOfTheWeek;
- (NSDate *)lastSecondOfTheWeek;

- (NSDate *)firstSecondOfTheMonth;
- (NSDate *)lastSecondOfTheMonth;

- (NSDate *)firstSecondOfTheYear;
- (NSDate *)lastSecondOfTheYear;

- (NSDate *)units:(NSInteger)units laterForCalendarUnit:(NSCalendarUnit)calendarUnit;

- (BOOL)isOnSameDayAs:(NSDate *)date;

@end

@interface NSDateFormatter (Reusabilitee)

+(NSDateFormatter *)formatterWithFormat:(NSString *)format;

@end
