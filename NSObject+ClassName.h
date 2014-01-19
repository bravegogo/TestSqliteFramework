//
//  NSObject+ClassName.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#if (TARGET_OS_IPHONE)

#import <Foundation/Foundation.h>

@interface NSObject (ClassName)

- (NSString *)className;
+ (NSString *)className;
@end
#endif