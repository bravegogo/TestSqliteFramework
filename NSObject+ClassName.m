//
//  NSObject+ClassName.m
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#if (TARGET_OS_IPHONE)

#import "NSObject+ClassName.h"
#import <objc/runtime.h>
@implementation NSObject (ClassName)

/*
 decription:
 param :
 */

- (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}
/*
 decription:
 param :
 */
+ (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName(self)];
}


@end

#endif