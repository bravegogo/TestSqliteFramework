//
//  NSString+ColumnName.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-20.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ColumnName)
- (NSString *)stringAsSQLColumnName;
- (NSString *)stringAsPropertyString;
@end
