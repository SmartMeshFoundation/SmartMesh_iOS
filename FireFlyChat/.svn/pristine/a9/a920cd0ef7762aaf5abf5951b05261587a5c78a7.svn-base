
//
//  NSDate+DDYExtension.m
//  DDYProject
//
//  Created by Starain on 15/8/3.
//  Copyright © 2015年 Starain. All rights reserved.
//

/**
  *  FDateFormatterStyle
  *  kCFDateFormatterNoStyle     无输出
  *  kCFDateFormatterShortStyle  10/29/12, 2:27 PM
  *  kCFDateFormatterMediumStyle 10,29,2012, 2:39:56 PM
  *  kCFDateFormatterLongStyle   10,29,2012, 2:39:56 PM GMT+08:00
  *  kCFDateFormatterFullStyle   星期日,10,29,2012, 2:39:56 PM China Standard Time
  *
  *
  *  G: 公元时代，例如AD公元
  *  yy: 年的后2位
  *  yyyy: 完整年
  *  MM: 月，显示为1-12
  *  MMM: 月，显示为英文月份简写,如 Jan
  *  MMMM: 月，显示为英文月份全称，如 Janualy
  *  dd: 日，2位数表示，如02
  *  d: 日，1-2位显示，如 2
  *  e: 1~7 (一周的第几天, 带0)
  *  EEE: 简写星期几，如Sun
  *  EEEE: 全写星期几，如Sunday
  *  aa: 上下午，AM/PM
  *  H: 时，24小时制，0-23
  *  K：时，12小时制，0-11
  *  m: 分，1-2位
  *  mm: 分，2位
  *  s: 秒，1-2位
  *  ss: 秒，2位
  *  S: 毫秒
  *  Q/QQ: 1~4 (0 padded Quarter) 第几季度
  *  QQQ: Q1/Q2/Q3/Q4 季度简写
  *  QQQQ: 1st quarter/2nd quarter/3rd quarter/4th quarter 季度全拼
  *  zzz表示时区
  *  timeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]
  *           [NSTimeZone timeZoneForSecondsFromGMT:0*3600]
  */

#import "NSDate+DDYExtension.h"

@implementation NSDate (DDYExtension)


+ (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateStyle = kCFDateFormatterShortStyle;
    
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    formatter.dateFormat = [dateStr rangeOfString:@"年"].location == NSNotFound?@"yyyy-MM-dd":@"yyyy年MM月dd日";
    
    NSDate *date = [formatter dateFromString:dateStr];
    
    return date;
}
#pragma mark 时间戳转字符串
+ (NSString *)strFromTimeStamp:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"MM.dd";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.doubleValue];
    
    return [formatter stringFromDate:date];
}

@end
