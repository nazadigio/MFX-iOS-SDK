//
//  AppDelegate.m
//  MFXTester
//
//  Created by ofirkariv on 24/04/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import <MFXSDKCore/MFXSDKCore.h>
#import <MoPubSDKFramework/MoPub.h>
#import <UserNotifications/UserNotifications.h>

#define MOPUB_HASH_ADAPTER_BANNER @"234dd5a1b1bf4a5f9ab50431f9615784"

@import GoogleMobileAds;

@interface AppDelegate ()

//  @property (nonatomic, strong) UNUserNotificationCenter *center;

@end

@implementation AppDelegate 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  //  [_center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
  //  }];
    // Override point for customization after application launch.
    [MobFoxSDK sharedInstance];
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:MOPUB_HASH_ADAPTER_BANNER];
    
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:nil];


    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
