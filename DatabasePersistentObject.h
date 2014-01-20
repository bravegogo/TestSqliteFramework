//
//  DatabasePersistentObject.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseInstanceManager.h"



#define isCollectionType(x) (isNSSetType(x) || isNSArrayType(x) || isNSDictionaryType(x))
#define isNSArrayType(x) ([x isEqualToString:@"NSArray"] || [x isEqualToString:@"NSMutableArray"])
#define isNSDictionaryType(x) ([x isEqualToString:@"NSDictionary"] || [x isEqualToString:@"NSMutableDictionary"])
#define isNSSetType(x) ([x isEqualToString:@"NSSet"] || [x isEqualToString:@"NSMutableSet"])


@class FMDatabase;

@interface DatabasePersistentObject : NSObject{
    
@private
    NSInteger pk;
    BOOL    dirty;
    BOOL    alreadySaving;
    BOOL    alreadyDeleting;
}

@property(nonatomic,strong)FMDatabase * db;
+ (NSString *)tableName;
+ (FMDatabase *)database;
+ (DatabaseInstanceManager *)manager;
+(void)tableCheck;

@end
