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
#import <objc/objc-class.h>
#import "NSString+ColumnName.h"
#import  <objc/objc-runtime.h>

#import "NSObject-SQLitePersistence.h"
//#import "NSString-UppercaseFirst.h"
//#import "NSString-NumberStuff.h"

#import "NSString+DataPersistence.h"


NSMutableDictionary *objectMap;
NSMutableArray *checkedTables;

@implementation DatabasePersistentObject

-(id)init{
    self = [super init];
    if (self) {
//        DatabaseInstanceManager * instanceManager = [DatabaseInstanceManager shareInstanceManager];
//         db = [instanceManager getDatabase];
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

#ifdef TARGET_OS_COCOTRON
+ (NSArray *)getPropertiesList
{
    return [NSArray array];
}
#endif

+(NSDictionary *)propertiesWithEncodedTypes
{
    // Recurse up the classes, but stop at NSObject. Each class only reports its own properties, not those inherited from its superclass
    
    NSMutableDictionary *theProps;
    
    if ([self superclass] != [NSObject class])
        theProps = (NSMutableDictionary *)[[self superclass] propertiesWithEncodedTypes];
    else
        theProps = [NSMutableDictionary dictionary];
    
    unsigned int outCount;
    
#ifndef TARGET_OS_COCOTRON
    objc_property_t *propList = class_copyPropertyList([self class], &outCount);
#else
    NSArray *propList = [[self class] getPropertiesList];
    outCount = [propList count];
#endif
    int i;
    
    // Loop through properties and add declarations for the create
    for (i=0; i < outCount; i++)
    {
#ifndef TARGET_OS_COCOTRON
        objc_property_t oneProp = propList[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
        NSString *attrs = [NSString stringWithUTF8String: property_getAttributes(oneProp)];
        // Read only attributes are assumed to be derived or calculated
        // See http://developer.apple.com/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/chapter_8_section_3.html
        if ([attrs rangeOfString:@",R,"].location == NSNotFound)
        {
            NSArray *attrParts = [attrs componentsSeparatedByString:@","];
            if (attrParts != nil)
            {
                if ([attrParts count] > 0)
                {
                    NSString *propType = [[attrParts objectAtIndex:0] substringFromIndex:1];
                    [theProps setObject:propType forKey:propName];
                }
            }
        }
#else
        NSArray *oneProp = [propList objectAtIndex:i];
        NSString *propName = [oneProp objectAtIndex:0];
        NSString *attrs = [oneProp objectAtIndex:1];
        [theProps setObject:attrs forKey:propName];
#endif
    }
    
#ifndef TARGET_OS_COCOTRON  
    free( propList );
#endif
    
    return theProps;  
}
+(NSArray *)indices
{
    return nil;
}

+(NSArray *)transients
{
    return [NSMutableArray array];
}
#pragma mark -
#pragma mark Multi-DB Support
+ (FMDatabase *)database
{
    return [[DatabaseInstanceManager shareInstanceManager] getDatabase];
}

+ (DatabaseInstanceManager *)manager
{
    return [DatabaseInstanceManager shareInstanceManager];
}
+(void)tableCheck
{
    NSArray *theTransients = [[self class] transients];
    FMDatabase *database = [self database];
    if (checkedTables == nil)
        checkedTables = [[NSMutableArray alloc] init];
    
    if (![checkedTables containsObject:[self className]])
    {
        [checkedTables addObject:[self className]];
        
        // Do not use static variables to cache information in this method, as it will be
        // shared across subclasses. Do caching in instance methods.
//        FMDatabase *database = [self database];
        NSMutableString *createSQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (pk INTEGER PRIMARY KEY",[self tableName]];
        
        NSDictionary* props = [[self class] propertiesWithEncodedTypes];
        for (NSString *oneProp in props)
        {
            if ([theTransients containsObject:oneProp]) continue;
            
            NSString *propName = [oneProp stringAsSQLColumnName];
            
            NSString *propType = [props objectForKey:oneProp];
            // Integer Types
            if ([propType isEqualToString:@"i"] || // int
                [propType isEqualToString:@"I"] || // unsigned int
                [propType isEqualToString:@"l"] || // long
                [propType isEqualToString:@"L"] || // usigned long
                [propType isEqualToString:@"q"] || // long long
                [propType isEqualToString:@"Q"] || // unsigned long long
                [propType isEqualToString:@"s"] || // short
                [propType isEqualToString:@"S"] ||  // unsigned short
                [propType isEqualToString:@"B"] )   // bool or _Bool
            {
                [createSQL appendFormat:@", %@ INTEGER", propName];
            }
            // Character Types
            else if ([propType isEqualToString:@"c"] || // char
                     [propType isEqualToString:@"C"] )  // unsigned char
            {
                [createSQL appendFormat:@", %@ TEXT", propName];
            }
            else if ([propType isEqualToString:@"f"] || // float
                     [propType isEqualToString:@"d"] )  // double
            {
                [createSQL appendFormat:@", %@ REAL", propName];
            }
            else if ([propType hasPrefix:@"@"] ) // Object
            {
            NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
                if (isNSArrayType(className))
                {
                    
                }
                else if (isNSDictionaryType(className))
                {
                    
                }
                else if (isNSSetType(className))
                {
                    
                }
                else
                {
                    Class propClass = objc_lookUpClass([className UTF8String]);
                    
                    if ([propClass isSubclassOfClass:[DatabasePersistentObject class]])
                    {
                        // Store persistent objects as quasi foreign-key reference. We don't use
                        // datbase's referential integrity tools, but rather use the memory map
                        // key to store the table and fk in a single text field
                        [createSQL appendFormat:@", %@ TEXT", propName];
                    }
                    else if ([propClass canBeStoredInSQLite])
                    {
                        [createSQL appendFormat:@", %@ %@", propName, [propClass columnTypeForObjectStorage]];
                    }
                }
                
            }
  
        }
        [createSQL appendString:@")"];
        NSLog(@"**********************  %@",createSQL);
        
        if (![database open])
        {
            NSLog(@"OPEN FAIL");
        }else {
            [database executeUpdate:createSQL];
            
            [database executeUpdate:@"CREATE TABLE IF NOT EXISTS SQLITESEQUENCE (name TEXT PRIMARY KEY, seq INTEGER)" ];
           
            NSMutableString *addSequenceSQL = [NSMutableString stringWithFormat:@"INSERT OR IGNORE INTO SQLITESEQUENCE (name,seq) VALUES ('%@', 0)", [[self class] tableName]];
             [database executeUpdate:addSequenceSQL];
        }
   
        NSArray *theIndices = [self indices];
        if (theIndices != nil)
        {
            if ([theIndices count] > 0)
            {
                for (NSArray *oneIndex in theIndices)
                {
                    NSMutableString *indexName = [NSMutableString stringWithString:[self tableName]];
                    NSMutableString *fieldCondition = [NSMutableString string];
                    BOOL first = YES;
                    for (NSString *oneField in oneIndex)
                    {
                        [indexName appendFormat:@"_%@", [oneField stringAsSQLColumnName]];
                        
                        if (first)
                            first = NO;
                        else
                            [fieldCondition appendString:@", "];
                        [fieldCondition appendString:[oneField stringAsSQLColumnName]];
                    }
                    NSString *indexQuery = [NSString stringWithFormat:@"create index if not exists %@ on %@ (%@)", indexName, [self tableName], fieldCondition];
                    
                    [database executeQuery:indexQuery];
 
                }
            }
        }
        
        // Now, make sure that every property has a corresponding column, alter the table for any that are missing
        NSArray *tableCols = [self tableColumns];
        for (NSString *oneProp in props)
        {
            if ([theTransients containsObject:oneProp]) continue;
            
            NSString *propName = [oneProp stringAsSQLColumnName];
            if (![tableCols containsObject:propName])
            {
                // No underlying column - could be a collection
                NSString *propType = [[[self class] propertiesWithEncodedTypes] objectForKey:oneProp];
                if ([propType hasPrefix:@"@"])
                {
                    NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
                    if (isNSArrayType(className) || isNSDictionaryType(className) || isNSSetType(className))
                    {
 
                    } else  {
                        Class propClass = objc_lookUpClass([className UTF8String]);
                        NSString *colType = nil;
                        
                        if ([propClass isSubclassOfClass:[DatabasePersistentObject class]])
                            colType = @"TEXT";
                        else if ([propClass canBeStoredInSQLite])
                            colType = [propClass columnTypeForObjectStorage];
                        
//                        [[self manager] executeUpdateSQL:[NSString stringWithFormat:@"alter table %@ add column %@ %@", [self tableName], propName, colType]];
                        
                        [database executeUpdate:[NSString stringWithFormat:@"alter table %@ add column %@ %@", [self tableName], propName, colType]];
                    }
                }
                else
                {
                    // TODO: Refactor out the col-type for property type into a single method or inline function
                    NSString *colType = @"TEXT";
                    
                    if ([propType isEqualToString:@"i"] || // int
                        [propType isEqualToString:@"I"] || // unsigned int
                        [propType isEqualToString:@"l"] || // long
                        [propType isEqualToString:@"L"] || // usigned long
                        [propType isEqualToString:@"q"] || // long long
                        [propType isEqualToString:@"Q"] || // unsigned long long
                        [propType isEqualToString:@"s"] || // short
                        [propType isEqualToString:@"S"] ||  // unsigned short
                        [propType isEqualToString:@"B"] )   // bool or _Bool
                        
                        colType = @"INTEGER";
                    
                    else if ([propType isEqualToString:@"f"] || // float
                             [propType isEqualToString:@"d"] )  // double
                        colType = @"REAL";
                    
//                    [[self manager] executeUpdateSQL:[NSString stringWithFormat:@"alter table %@ add column %@ %@", [self tableName], propName, colType]];
                    
                     [database executeUpdate:[NSString stringWithFormat:@"alter table %@ add column %@ %@", [self tableName], propName, colType]];
                }
            }
            
        }
    }
    
    [database close];
}



+(NSArray *)tableColumns
{
    NSMutableArray *ret = [NSMutableArray array];
    // pragma table_info(i_c_project);
    FMDatabase *database = [self database];
    NSString *query = [NSString stringWithFormat:@"pragma table_info(%@);", [self tableName]];
  
    if(![database open]) {
        
    }else{
        FMResultSet *rs = [database executeQuery:query];
  
        while ([rs next]){
            NSString *  columnName = [rs stringForColumn:@"name"];
            [ret addObject:columnName];
        }
        
        [rs close];
        [database close];
    }
 
    return ret;
    
}

-(void)save
{
    if (alreadySaving)
        return;
    alreadySaving = YES;
    
    [[self class] tableCheck];
    
//    if (pk == 0)
//    {
//        NSLog(@"Object of type '%@' seems to be uninitialised, perhaps init does not call super init.", [[self class] description] );
//        return;
//    }
    
    NSDictionary *props = [[self class] propertiesWithEncodedTypes];
    
////    if (!dirty)
////    {
//        // Check child and owned objects to see if any of them are dirty
//        // Just tell children and composed objects to save themselves
//        
//        for (NSString *propName in props)
//        {
//            NSString *propType = [props objectForKey:propName];
//            //int colIndex = sqlite3_bind_parameter_index(stmt, [[propName stringAsSQLColumnName] UTF8String]);
//            id theProperty = [self valueForKey:propName];
//            if ([propType hasPrefix:@"@"] ) // Object
//            {
//                NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
//                
//                
//                if (! (isCollectionType(className)) )
//                {
////                    if ([[theProperty class] isSubclassOfClass:[DatabasePersistentObject class]])
////                        if ([theProperty isDirty])
////                            dirty = YES;
//                }
// 
//            }
//        }
////    }
    
    NSArray *theTransients = [[self class] transients];
    
//    if (dirty)
//    {
//        dirty = NO;
    
        FMDatabase *database = [[self class] database];
        [database open];
        // If this object is new, we need to figure out the correct primary key value,
        // which will be one higher than the current highest pk value in the table.
        
        if (pk < 0)
        {
              NSString *pkQuery = [NSString stringWithFormat:@"SELECT SEQ FROM SQLITESEQUENCE WHERE NAME='%@'", [[self class] tableName]];
            
              FMResultSet * rs = [database executeQuery:pkQuery];
              while ([rs next]){
                 pk =  [rs intForColumn:@"seq"] +1;
              }
             NSString *seqIncrementQuery = [NSString stringWithFormat:@"UPDATE SQLITESEQUENCE set seq=%d WHERE name='%@'", pk, [[self class] tableName]];
            [database executeUpdate:seqIncrementQuery];
        }
    
        NSMutableString *updateSQL = [NSMutableString stringWithFormat:@"INSERT OR REPLACE INTO %@ (pk", [[self class] tableName]];
        
        NSMutableString *bindSQL = [NSMutableString string];
        
        for (NSString *propName in props)
        {
            if ([theTransients containsObject:propName]) continue;
            
            NSString *propType = [props objectForKey:propName];
            NSString *className = @"";
            if ([propType hasPrefix:@"@"])
                className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
            if (! (isCollectionType(className)))
            {
                [updateSQL appendFormat:@", %@", [propName stringAsSQLColumnName]];
                [bindSQL appendString:@", ?"];
            }
        }
        
        [updateSQL appendFormat:@") VALUES (?%@)", bindSQL];
    
        NSLog(@" updateSQL*********  %@",updateSQL);
        NSMutableString * valueSQL = [NSMutableString string];
        NSMutableArray  *valueArray = [NSMutableArray array];
//            int colIndex = 1;
 
            for (NSString *propName in props)
            {
                if ([theTransients containsObject:propName]) continue;
                
                NSString *propType = [props objectForKey:propName];
                NSString *className = propType;
                if ([propType hasPrefix:@"@"]){
                    className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
                }
  
                id theProperty = [self valueForKey:propName];
                if (theProperty == nil && ! (isCollectionType(className)))
                {
 
                  NSString *theString = [theProperty stringValue];
                  [valueSQL appendFormat:@", %@", theString];
                  NSLog(@" theString*********  %@",theString);
                    [valueArray addObject:theString];
                }else if([propType isEqualToString:@"i"] || // int
                         [propType isEqualToString:@"I"] || // unsigned int
                         [propType isEqualToString:@"l"] || // long
                         [propType isEqualToString:@"L"] || // usigned long
                         [propType isEqualToString:@"q"] || // long long
                         [propType isEqualToString:@"Q"] || // unsigned long long
                         [propType isEqualToString:@"s"] || // short
                         [propType isEqualToString:@"S"] || // unsigned short
                         [propType isEqualToString:@"B"] || // bool or _Bool
                         [propType isEqualToString:@"f"] || // float
                         [propType isEqualToString:@"d"] )  // double
                {
 
                          [valueSQL appendFormat:@", %@", [theProperty stringValue]];
                          NSLog(@" theString*********  %@",[theProperty stringValue]);
                     [valueArray addObject:[theProperty stringValue]];

                }
                else if ([propType isEqualToString:@"c"] || // char
                         [propType isEqualToString:@"C"] ) // unsigned char
                    
                {
                     NSString *theString = [theProperty stringValue];
                     [valueSQL appendFormat:@", %@", theString];
                     NSLog(@" theString*********  %@",theString);
                    [valueArray addObject:[theProperty stringValue]];
         
                }
                else if ([propType hasPrefix:@"@"] ) // Object
                {
                    NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
                    
                    if (! (isCollectionType(className)) )
                    {
                        if ([[theProperty class] isSubclassOfClass:[DatabasePersistentObject class]])
                        {
                           //  
                        } else if([[theProperty class] shouldBeStoredInBlob]) {
                            NSData *data = [theProperty sqlBlobRepresentationOfSelf];
                            [valueArray addObject:data];

                        } else {
                          
                            id theValue = [theProperty sqlColumnRepresentationOfSelf];
                            [valueSQL appendFormat:@", %@", theValue];
                            NSLog(@" theString*********  %@",theValue);
                            [valueArray addObject:theValue];
                            

                        }
                    }
                    
                }

            }// for
    
    NSLog(@" *********  %@ - %@",updateSQL,valueSQL);
    
     BOOL ret = [database executeUpdate:updateSQL withArgumentsInArray:valueArray];
      NSLog(@" *********  %d - %d",ret,ret);
    [database close];
}
@end
