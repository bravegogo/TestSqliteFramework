//
//  DataPersistence.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-21.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataPersistence <NSObject>

/*!
 This protocol should be implemented by any object that needs to be stored in a database as a single column. This protocol is not for objects that will be persisted as a table, but only those that need to be persisted inside a column of a table. This is primarily for objects that store numbers, text, dates, and other values that can easily be represented in a column of a database table. For more complex objects, subclass SQLitePersistentObject
 */

@required
/*!
 This method is used to indicate whether this data object can be stored in a column of a SQLite3 table
 */
+ (BOOL)canBeStoredInSQLite;

/*!
 Returns the SQL data type to use to store this object in a SQLite3 database. Must be one of kSQLiteColumnTypeText, kSQLIteColumnTypeInteger, kSQLiteColumnTypeReal, kSQLiteColumnTypeBlob
 */
+ (NSString *)columnTypeForObjectStorage;
+ (BOOL)shouldBeStoredInBlob;

@optional
/*!
 This method needs to be implemented only if a class returns YES to shouldBeStoredInBlob. Inits an object from a blob.
 */
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData;
/*!
 This method needs to be implemented only if this class returns YES to shouldBeStoredInBlob. Returns an NSData containing the data to go in the blob. This method must be implemented by objects that return YES in canBeStoredInSQLite and YES in shouldBeStoredInBlob.
 */
- (NSData *)sqlBlobRepresentationOfSelf;

/*!
 This method returns an autoreleased object from column data pulled from the database. This is the reverse to sqlColumnRepresentationOfSelf and needs to be able to create a data from whatever is returned by that method. This method must be implemented by objects that return YES in canBeStoredInSQLite but YES in shouldBeStoredInBlob.  */
+ (id)objectWithSQLBlobRepresentation:(NSData *)data;

/*!
 This method returns a string that holds this object's data and which can be used to re-constitute the object using objectWithSqlColumnRepresentation:. This method must be implemented by objects that return YES in canBeStoredInSQLite but NO in shouldBeStoredInBlob.
 */
- (NSString *)sqlColumnRepresentationOfSelf;

 
@end
