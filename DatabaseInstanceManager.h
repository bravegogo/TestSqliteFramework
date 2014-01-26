//
//  DatabaseInstanceManager.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FMDatabase,FMDatabaseQueue;

@interface DatabaseInstanceManager : NSObject

@property(nonatomic,strong)NSString *databaseName;
@property (nonatomic, retain)FMDatabaseQueue *dbQueue;

+(id)shareInstanceManager;
- (FMDatabase *) getDatabase;
- (FMDatabaseQueue *) getDatabaseQueue;
- (NSString *) getSqliteFilePath ;
- (void) deleteDatabase;
- (NSString *) getTheDatabaseName;

@end
