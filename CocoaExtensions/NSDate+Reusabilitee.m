//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSDate+Reusabilitee.h"

@implementation NSCalendar (Reusabilitee)

static NSCalendar *cal_ = nil;

+ (NSCalendar *)fastCalendar
{
    @synchronized(self)
    {
        if (cal_ == nil)
        {
            cal_ = [[NSCalendar currentCalendar] retain];
        }
        
        return cal_;
    }
}

+ (void)releaseFastCalendar
{
    [cal_ release];
    cal_ = nil;
}

@end

@implementation NSDate (Reusabilitee)

+ (NSInteger)firstWeekDay
{
    NSString *calendarId = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:calendarId] autorelease];
    return [calendar firstWeekday];
}

- (NSDate *)firstSecondOfTheDay
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSDayCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the day: %@", self);
    }
    
    return beginning;
}

- (NSDate *)lastSecondOfTheDay
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDateComponents *oneDay = [[[NSDateComponents alloc] init] autorelease];
    [oneDay setDay:1];
    [oneDay setSecond:-1];
    
    return [cal dateByAddingComponents:oneDay toDate:[self firstSecondOfTheDay] options:0];
}

- (NSDate *)firstSecondOfTheWeek
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSWeekCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the week: %@", self);
    }

    return beginning;
}

- (NSDate *)lastSecondOfTheWeek
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDateComponents *oneWeek = [[[NSDateComponents alloc] init] autorelease];
    [oneWeek setWeek:1];
    [oneWeek setSecond:-1];

    return [cal dateByAddingComponents:oneWeek toDate:[self firstSecondOfTheWeek] options:0];
}

- (NSDate *)firstSecondOfTheMonth
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSMonthCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the month: %@", self);
    }
    
    return beginning;
}

- (NSDate *)lastSecondOfTheMonth
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDateComponents *oneMonth = [[[NSDateComponents alloc] init] autorelease];
    [oneMonth setMonth:1];
    [oneMonth setSecond:-1];
    
    return [cal dateByAddingComponents:oneMonth toDate:[self firstSecondOfTheMonth] options:0];
}

- (NSDate *)firstSecondOfTheYear
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDate *beginning = nil;
    if (![cal rangeOfUnit:NSYearCalendarUnit startDate:&beginning interval:NULL forDate:self])
    {
        DLog(@"Could not get beginning of the month: %@", self);
    }
    
    return beginning;
}

- (NSDate *)lastSecondOfTheYear
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDateComponents *oneYear = [[[NSDateComponents alloc] init] autorelease];
    [oneYear setYear:1];
    [oneYear setSecond:-1];
    
    return [cal dateByAddingComponents:oneYear toDate:[self firstSecondOfTheYear] options:0];
}

- (NSDate *)units:(NSInteger)units laterForCalendarUnit:(NSCalendarUnit)calendarUnit
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
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

- (NSDate *)units:(NSInteger)units earlierForCalendarUnit:(NSCalendarUnit)calendarUnit
{
    return [self units:-units laterForCalendarUnit:calendarUnit];
}

- (BOOL)isEqualToDate:(NSDate *)otherDate forUnits:(NSCalendarUnit)units
{
    NSCalendar *cal = [NSCalendar fastCalendar];
    
    NSDateComponents *simpleSelf = [cal components:units fromDate:self];
    NSDateComponents *simpleOtherDate = [cal components:units fromDate:otherDate];
    
    return [simpleSelf isEqual:simpleOtherDate];
}

- (BOOL)isOnSameDayAs:(NSDate *)date
{
    return [self isEqualToDate:date forUnits:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit];
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
