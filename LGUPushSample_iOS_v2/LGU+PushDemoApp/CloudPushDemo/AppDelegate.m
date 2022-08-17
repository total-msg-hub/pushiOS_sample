//
//  AppDelegate.m
//  DbSteelPush
//
//  Created by 정종현 on 2017. 7. 12..
//  Copyright © 2017년 정종현. All rights reserved.
//

#import "AppDelegate.h"
#import "Controller.h"
#import "CommonHandler.h"
#import "CommonFunctions.h"
#import <MPushLibrary/MPushLibrary.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.uracle.push.demo.lgu"];
    NSArray *messageArray = [userDefault objectForKey:@"PUSH_MESSAGE_DATA_FOR_DB"];
    if(messageArray)
    {
        for(NSDictionary *messageDic in messageArray)
        {
            [CommonFunctions updateItemsDB:@"PushItems" array:messageDic new:@"Y"];
        }
    }
    
    [userDefault removeObjectForKey:@"PUSH_MESSAGE_DATA_FOR_DB"];
            
    [[PushManager defaultManager] application:application didFinishLaunchingWithOptions:launchOptions];
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[Controller getInstance] setAppDelegate:self];
    [[Controller getInstance] setViewController:self serviceVC:VC_MAIN_INTRO animated:NO];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[PushManager defaultManager] application:application didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.uracle.push.demo.lgu"];
    NSArray *messageArray = [userDefault objectForKey:@"PUSH_MESSAGE_DATA_FOR_DB"];
    if(messageArray)
    {
        for(NSDictionary *messageDic in messageArray)
        {
            [CommonFunctions updateItemsDB:@"PushItems" array:messageDic new:@"Y"];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONREFRESH" object:@""];
    
    [userDefault removeObjectForKey:@"PUSH_MESSAGE_DATA_FOR_DB"];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
