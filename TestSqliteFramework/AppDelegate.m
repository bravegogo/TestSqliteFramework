//
//  AppDelegate.m
//  TestSqliteFramework
//
//  Created by yj on 14-1-19.
//  Copyright (c) 2014年 yj. All rights reserved.
//

#import "AppDelegate.h"
#import "Car.h"
#import "home.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /*
     
     test ---- test ---- test
     
     test ---- test ---- test
     test ---- test ---- test
     test ---- test ---- test
     test ---- test ---- test
     test ---- test ---- test
     test ---- test ---- test
safasfasfasdfasdfasdfasdfasd
     
     */
    
    Car * car = [[Car alloc]init];
    car.wheel = @"09099090";
    car.koil = @"-09082736";
    car.mmm = 1000;
    [car valueForKey:@"wheel"];
    
    NSLog(@"*********** %@", [car valueForKey:@"wheel"]);
    NSLog(@"*********** %@", [car valueForKey:@"koil"]);
    NSLog(@"*********** %@", [car valueForKey:@"mmm"]);
//    [Car tableCheck];
    
//    NSLog(@"*********** %@",[Car tableName]);

    [car saveOp];
    [car saveOp];
    [car saveOp];
    [car deleteOp];
    
    home * car890 = [[home alloc]init];
    car890.wheel = @"09099090";
    car890.koil = @"-09082736";
    car890.mmm = 10000009;
    [car890 saveOp];
    NSLog(@"*********** %@",[home tableName]);

//    [car890 valueForKey:@"wheel"];
     NSLog(@"*********** end ***************");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
