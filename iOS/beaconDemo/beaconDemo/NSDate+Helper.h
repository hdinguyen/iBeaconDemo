//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import <Foundation/Foundation.h>

static NSString *kNSDateHelperFormatFullDateWithTime    = @"MMM d, yyyy h:mm a";
static NSString *kNSDateHelperFormatFullDate            = @"MMM d, yyyy";
static NSString *kNSDateHelperFormatShortDateWithTime   = @"MMM d h:mm a";
static NSString *kNSDateHelperFormatShortDate           = @"MMM d";
static NSString *kNSDateHelperFormatWeekday             = @"EEEE";
static NSString *kNSDateHelperFormatWeekdayWithTime     = @"EEEE h:mm a";
static NSString *kNSDateHelperFormatTime                = @"h:mm a";
static NSString *kNSDateHelperFormatTimeWithPrefix      = @"'at' h:mm a";
static NSString *kNSDateHelperFormatSQLDate             = @"yyyy-MM-dd";
static NSString *kNSDateHelperFormatSQLTime             = @"HH:mm:ss";
static NSString *kNSDateHelperFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm:ss";
static NSString *kNSDateHelperFormatDateDisplay         = @"dd MMM yyyy";
static NSString *kNSDateHelperFormatTimeDisplay         = @"H:mm a";
static NSString *kNSDateHelperFormatDateFeed            = @"MMM dd";

@interface NSDate (Helper)

+ (void)initializeStatics;

+ (NSCalendar *)sharedCalendar;
+ (NSDateFormatter *)sharedDateFormatter;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)year;
- (long int)utcTimeStamp; //full seconds since
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;
+ (NSString *)dateToEasyReaderString:(NSDate*)startDate;
- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

@end
