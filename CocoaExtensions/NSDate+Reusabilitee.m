//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSDate+Reusabilitee.h"

@implementation NSDate (Reusabilitee)

+ (NSInteger)firstWeekDay
{
    NSString *calendarId = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:calendarId] autorelease];
    return [calendar firstWeekday];
}

- (NSDate *)firstSecondOfTheDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSDayCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the day: %@", self);
    }
    
    return beginning;
}

- (NSDate *)lastSecondOfTheDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *oneDay = [[[NSDateComponents alloc] init] autorelease];
    [oneDay setDay:1];
    [oneDay setSecond:-1];
    
    return [cal dateByAddingComponents:oneDay toDate:[self firstSecondOfTheDay] options:0];
}

- (NSDate *)firstSecondOfTheWeek
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSWeekCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the week: %@", self);
    }

    return beginning;
}

- (NSDate *)lastSecondOfTheWeek
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *oneWeek = [[[NSDateComponents alloc] init] autorelease];
    [oneWeek setWeek:1];
    [oneWeek setSecond:-1];

    return [cal dateByAddingComponents:oneWeek toDate:[self firstSecondOfTheWeek] options:0];
}

- (NSDate *)firstSecondOfTheMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSMonthCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the month: %@", self);
    }
    
    return beginning;
}

- (NSDate *)lastSecondOfTheMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *oneMonth = [[[NSDateComponents alloc] init] autorelease];
    [oneMonth setMonth:1];
    [oneMonth setSecond:-1];
    
    return [cal dateByAddingComponents:oneMonth toDate:[self firstSecondOfTheMonth] options:0];
}

- (NSDate *)firstSecondOfTheYear
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSYearCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the month: %@", self);
    }
    
    return beginning;
}

- (NSDate *)lastSecondOfTheYear
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *oneYear = [[[NSDateComponents alloc] init] autorelease];
    [oneYear setYear:1];
    [oneYear setSecond:-1];
    
    return [cal dateByAddingComponents:oneYear toDate:[self firstSecondOfTheYear] options:0];
}

- (NSDate *)units:(NSInteger)units laterForCalendarUnit:(NSCalendarUnit)calendarUnit
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *oneUnit = [[[NSDateComponents alloc] init] autorelease];
    switch (calendarUnit) {
        case NSDayCalendarUnit:
            oneUnit.day = units;
            break;
        case NSWeekCalendarUnit:
            oneUnit.week = units;
            break;
        case NSMonthCalendarUnit:
            oneUnit.month = units;
            break;
        case NSYearCalendarUnit:
            oneUnit.year = units;
            break;
    }
    
    return [cal dateByAddingComponents:oneUnit toDate:self options:0];
}

- (BOOL)isOnSameDayAs:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *simpleSelf = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    NSDateComponents *simpleDate = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];

    return [simpleSelf isEqual:simpleDate];
}

@end

@implementation NSDateFormatter (Reusabilitee)

+(NSDateFormatter *)formatterWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:format];
    return formatter;
}

@end
