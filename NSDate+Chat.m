//
//  NSDate+Chat.m
//  Pelebit
//
//  Created by Shahar Barsheshet on 26/10/2015.
//  Copyright © 2015 PeleBit. All rights reserved.
//
//  This class was created to add chat like date for messaging and posts
//  The dates are as follow:
//
//  1min>   "Just now"
//  1hr>    "xx minutes ago"        -   "25 minutes ago"
//  1day>   "xx hours ago:          -   "5 hours ago"
//  2days>  "Yesterdat at hh:mm"    -   "Yesterday at 14:32"
//  <2days  "MM dd at hh:mm"        -   "October 29 at 6:45"
//

#import "NSDate+Chat.h"

@implementation NSDate (Chat)

/**
 *  create a date string for chat
 *
 *  @return -   the chat like date string 
 */
- (NSString*)chatDate
{
    return [self chatDateWithOrdinal:YES monthLength:-1];
}

- (NSString*)chatDateWithOrdinal:(BOOL)useOrdinal monthLength:(int)minLength
{
    // get the time interval from now
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self];
    // use the en_US locale
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    // check if there are more than two days different
    if (interval > 172800) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.locale = locale;
        // get month name
        NSString* monthName = [[df monthSymbols] objectAtIndex:([self month])];
        if (minLength != -1) {
            monthName = [monthName substringToIndex:MIN(minLength, monthName.length)];
        }
        // get day suffix
        NSDateFormatter* dayFormatter = [[NSDateFormatter alloc] init];
        dayFormatter.locale = locale;
        dayFormatter.dateFormat = @"d";
        // get the day string
        NSString* dayStr = [dayFormatter stringFromDate:self];
        NSString* dateFormat;

        if (useOrdinal) {
            char rightDigit = [dayStr characterAtIndex:dayStr.length - 1];
            // add a ordinal according to the last number
            NSString* ordinal;

            switch (rightDigit) {
            case '1':
                ordinal = @"st";
                break;
            case '2':
                ordinal = @"nd";
                break;
            case '3':
                ordinal = @"rd";
                break;
            default:
                ordinal = @"th";
                break;
            }
            dateFormat = stringWithFormat(@"'%@' d'%@' 'at' HH:mm", monthName, ordinal);
        }
        else
            dateFormat = stringWithFormat(@"'%@' d 'at' HH:mm", monthName);

        df.dateFormat = dateFormat;

        return [df stringFromDate:self];
    }
    // less than 60 seconds
    else if (interval < 60) {
        return NSLocalizedString(@"Just now", @"");
    }
    // less than an hour, show how many minutes
    else if (interval < 3600) {
        uint mins = (uint)floor(interval / 60);
        return stringWithFormat(NSLocalizedString(@"%d minute%@ ago", @""), mins,
            (mins == 1) ? @"" : @"s");
    }
    // less than a day - show number of hours
    else if (interval < 86400) {
        uint hours = (uint)floor(interval / 60 / 60);
        return stringWithFormat(NSLocalizedString(@"%d hour%@ ago", @""), hours,
            (hours == 1) ? @"" : @"s");
    }
    // yesterday, show Yesterday and the hour.
    else if (interval < 172800) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.locale = locale;
        df.dateFormat = @"HH:mm";

        return stringWithFormat(NSLocalizedString(@"yesterday at %@", @""),
            [df stringFromDate:self]);
    }

    return nil;
}
@end
