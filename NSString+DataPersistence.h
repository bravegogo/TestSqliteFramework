//
//  NSString+DataPersistence.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-21.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DataPersistence)
/*!
 This method initializes an NSString from TEXT colum data pulled from the database.
 */
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData;

/*!
 This method returns self.
 */
- (NSString *)sqlColumnRepresentationOfSelf;

/*!
 Returns YES to indicate it can be stored in a column of a database
 */
+ (BOOL)canBeStoredInSQLite;

/*!
 Returns TEXT to inidicate this object can be stored in a TEXT column
 */
+ (NSString *)columnTypeForObjectStorage;

+ (BOOL)shouldBeStoredInBlob;
@end
