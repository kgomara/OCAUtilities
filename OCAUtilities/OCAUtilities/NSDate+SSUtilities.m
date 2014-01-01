//
//  NSDateCategory.m
//  LiteratureRack
//
//  Created by KEVIN OMARA on 7/1/12.
//  Copyright (c) 2012-2013 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation NSDate (OCAUtilities)

//----------------------------------------------------------------------------------------------------------
- (NSString *)dateStringWithDateStyle: (NSDateFormatterStyle)dateStyle
                         andTimeStyle: (NSDateFormatterStyle)timeStyle;
{
    DLog();
    
    return [NSDateFormatter localizedStringFromDate: self
                                          dateStyle: dateStyle
                                          timeStyle: timeStyle];
}

//----------------------------------------------------------------------------------------------------------
- (NSString *)formattedTimeToDate: (NSDate *)secondDate
{
    DLog();
    
    NSString *formattedDifference = nil;
    unsigned flags = NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *difference = [gregorian components: flags 
                                                fromDate: self
                                                  toDate: secondDate
                                                 options: 0];
    
    if ([difference day] > 0) {
        formattedDifference = [NSString stringWithFormat: NSLocalizedString( @"%d days ago", @"%d days ago"), [difference day]];
    } else if ([difference hour] > 0) {
        formattedDifference = [NSString stringWithFormat: NSLocalizedString( @"%d hours ago", @"%d hours ago"), [difference hour]];
    } else if ([difference minute] > 0) {
        formattedDifference = [NSString stringWithFormat: NSLocalizedString( @"%d minutes ago", @"%d minutes ago"), [difference minute]];
    } else {
        formattedDifference = NSLocalizedString( @"A few seconds ago", @"A few seconds ago");
    }
    
    return formattedDifference;
}

//----------------------------------------------------------------------------------------------------------
+ (NSDate *)currentGMTDate
{
    DLog();
    
    NSDate *localDate               = [NSDate date];
    NSTimeInterval timeZoneOffset   = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSTimeInterval gmtTimeInterval  = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate                 = [NSDate dateWithTimeIntervalSinceReferenceDate: gmtTimeInterval];

    return gmtDate;
}

@end
