//
//  Car.h
//  TestSqliteFramework
//
//  Created by yj on 14-1-20.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import "DatabasePersistentObject.h"

@interface Car : DatabasePersistentObject

@property(nonatomic,strong) NSString * wheel;
//@property(nonatomic,strong) NSString * kind;
//@property(nonatomic,strong) NSString * sudu;
@property(nonatomic,strong) NSString * koil;
@property(nonatomic,assign) int  mmm;
@end
