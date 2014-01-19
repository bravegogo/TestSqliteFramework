//
//  DatabaseInstanceManager.m
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import "DatabaseInstanceManager.h"
#import "FMDatabase.h"

static DatabaseInstanceManager * databaseInstanceManager = nil;

@implementation DatabaseInstanceManager

+(id)shareInstanceManager{
    @synchronized(self){
        if (databaseInstanceManager == nil) {
            databaseInstanceManager = [[DatabaseInstanceManager alloc]init];
        }
    }
    return databaseInstanceManager;
}

- (FMDatabase *) getDatabase{
    return  [FMDatabase databaseWithPath:[self getSqliteFilePath:[self getTheDatabaseName]]];
}

/*
 
 param :@"linxunDb.sqlite"
 */

- (NSString*) getSqliteFilePath:(NSString *)fileName{
    NSArray* paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ;
    return [[paths objectAtIndex:0]stringByAppendingPathComponent:fileName] ;
}

/*
 
 param :
 */
- (void)deleteDatabase
{
    NSString* path = [self getTheDatabaseName];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:NULL];
 
}
/*
 
 param :
 */
- (NSString *)getTheDatabaseName
{
    if (!self.databaseName) {
        NSMutableString *ret = [NSMutableString string];
        NSString *appName = [[NSProcessInfo processInfo] processName];
        
        for (int i = 0; i < [appName length]; i++) {
            NSRange range = NSMakeRange(i, 1);
            NSString *oneChar = [appName substringWithRange:range];
            if (![oneChar isEqualToString:@" "])
                [ret appendString:[oneChar lowercaseString]];
        }
        self.databaseName = [ret stringByAppendingString:@".sqlite3"];
    }
    return self.databaseName;
}
@end
