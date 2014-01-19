//
//  DatabaseInstanceManager.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface DatabaseInstanceManager : NSObject

@property(nonatomic,strong)NSString *databaseName;

+(id)shareInstanceManager;
- (FMDatabase *) getDatabase;
- (NSString *) getSqliteFilePath ;
- (void) deleteDatabase;
- (NSString *) getTheDatabaseName;

@end
