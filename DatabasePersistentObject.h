//
//  DatabasePersistentObject.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@end
