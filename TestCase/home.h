//
//  home.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-26.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabasePersistentObject.h"

@interface home : DatabasePersistentObject

@property(nonatomic,strong) NSString * wheel;
@property(nonatomic,strong) NSString * koil;
@property(nonatomic,assign) int  mmm;
@end
