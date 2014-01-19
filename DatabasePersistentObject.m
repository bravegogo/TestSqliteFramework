//
//  DatabasePersistentObject.m
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import "DatabasePersistentObject.h"
#import "NSObject+ClassName.h"
#import "FMDatabase.h"
#import "DatabaseInstanceManager.h"

@implementation DatabasePersistentObject

-(id)init{
    self = [super init];
    if (self) {
       
        DatabaseInstanceManager * instanceManager = [DatabaseInstanceManager shareInstanceManager];
        self.db = [instanceManager getDatabase];
    }
    return self;
}
/*
 decription:
 param :
 */

+ (NSString *)tableName
{
    static NSMutableDictionary *tableNamesByClass = nil;
    
    if (tableNamesByClass == nil)
        tableNamesByClass = [[NSMutableDictionary alloc] init];
    
    if ([[tableNamesByClass allKeys] containsObject:[self className]])
        return [tableNamesByClass objectForKey:[self className]];
    
    // Note: Using a static variable to store the table name
    // will cause problems because the static variable will
    // be shared by instances of classes and their subclasses
    // Cache in the instances, not here...
    NSMutableString *ret = [NSMutableString string];
    NSString *className = [self className];
    for (int i = 0; i < className.length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *oneChar = [className substringWithRange:range];
        if ([oneChar isEqualToString:[oneChar uppercaseString]] && i > 0)
            [ret appendFormat:@"_%@", [oneChar lowercaseString]];
        else
            [ret appendString:[oneChar lowercaseString]];
    }
    
    [tableNamesByClass setObject:ret forKey:[self className]];
    return ret;
}
@end
