//
//  NSString+ColumnName.m
//  TestSqliteFramework
//
//  Created by yj on 14-1-20.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import "NSString+ColumnName.h"

@implementation NSString (ColumnName)

- (NSString *)stringAsSQLColumnName
{
    if ([self isEqualToString:[self lowercaseString]]) {
        return self;
    }
    NSMutableString *ret = [NSMutableString string];
    for (int i=0; i < [self length]; i++)
    {
        NSRange sRange = NSMakeRange(i,1);
        NSString *oneChar = [self substringWithRange:sRange];
        if ([oneChar isEqualToString:[oneChar uppercaseString]] && i > 0)
            [ret appendFormat:@"_%@", [oneChar lowercaseString]];
        else
            [ret appendString:[oneChar lowercaseString]];
    }
    return ret;
}

- (NSString *)stringAsPropertyString
{
    if ([self rangeOfString:@"_"].location == NSNotFound) {
        return self;
    }
    BOOL lastWasUnderscore = NO;
    NSMutableString *ret = [NSMutableString string];
    for (int i=0; i < [self length]; i++)
    {
        NSRange sRange = NSMakeRange(i,1);
        NSString *oneChar = [self substringWithRange:sRange];
        if ([oneChar isEqualToString:@"_"])
            lastWasUnderscore = YES;
        else
        {
            if (lastWasUnderscore)
                [ret appendString:[oneChar uppercaseString]];
            else
                [ret appendString:oneChar];
            
            lastWasUnderscore = NO;
        }
    }
    return ret;
}

@end
