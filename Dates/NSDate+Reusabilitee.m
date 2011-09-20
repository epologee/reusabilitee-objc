//
//  NSDate+GetTogether.m
//
//  Created by Eric-Paul Lecluse @ 2011
//

#import "NSDate+Reusabilitee.h"

@implementation NSDate (Reusabilitee)

+(NSInteger)firstWeekDay
{
    NSString *calendarId = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:calendarId];
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

- (NSDate *)weekStart
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSWeekCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the week: %@", self);
    }

    return beginning;
}

- (NSDate *)weekEnd
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *endOfWeek = nil;
    NSDate *nextWeek = [self dateByAddingTimeInterval:60 * 60 * 24 * 7];
    if (![cal rangeOfUnit:NSWeekCalendarUnit startDate:&endOfWeek interval:NULL forDate:nextWeek])
    {
        DLog(@"Could not get end of the week: %@", self);
    }
    
    return endOfWeek;
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
    
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
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
    
    NSDateComponents *oneYear = [[NSDateComponents alloc] init];
    [oneYear setYear:1];
    [oneYear setSecond:-1];
    
    return [cal dateByAddingComponents:oneYear toDate:[self firstSecondOfTheYear] options:0];
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
