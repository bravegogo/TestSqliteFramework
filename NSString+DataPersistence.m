//
//  NSString+DataPersistence.m
//  TestSqliteFramework
//
//  Created by yj on 14-1-21.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import "NSString+DataPersistence.h"
#import "PersistenceConfig.h"
#import "DataPersistence.h"

@implementation NSString (DataPersistence)

+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData
{
    return columnData;
}
- (NSString *)sqlColumnRepresentationOfSelf
{
    return self;
}
+ (BOOL)canBeStoredInSQLite;
{
    return YES;
}
+ (NSString *)columnTypeForObjectStorage
{
    return kSQLiteColumnTypeText;
}
+ (BOOL)shouldBeStoredInBlob
{
    return NO;
}
@end
