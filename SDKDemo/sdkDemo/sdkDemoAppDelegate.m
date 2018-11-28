//
//  sdkDemoAppDelegate.m
//  sdkDemo
//
//  Created by qqconnect on 13-3-29.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "sdkDemoAppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "sdkCall.h"

#if BUILD_QQAPIDEMO
#import "TencentOpenAPI/QQApiInterface.h"
#import "QQApiShareEntry.h"
#endif

#import <Bugly/Bugly.h>

#define OSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@implementation sdkDemoAppDelegate

- (void)setIsRequestFromQQ:(BOOL)isRequestFromQQ
{
    _isRequestFromQQ = isRequestFromQQ;
    UINavigationBar *navBar = self.viewController.navigationController.navigationBar;
    UIColor *newColor = nil;
    if (_isRequestFromQQ)
    {
        // 46,139,87
        newColor = [UIColor colorWithRed:(46/255.0) green:(139/255.0) blue:(87/255.0) alpha:1.0];
    }
    else
    {
        newColor = nil;
    }
    
    if (OSVersion >= 7.0)
    {
        navBar.barTintColor = newColor;
    }
    else
    {
        navBar.tintColor = newColor;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Bugly startWithAppId:@"adf1669526"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[sdkDemoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    sdkDemoNavgationController *navController = [[sdkDemoNavgationController alloc] initWithRootViewController:self.viewController];
    [[self window] setRootViewController:navController];
    [[self window] makeKeyAndVisible];
    self.isRequestFromQQ = NO;
    
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
    self.isRequestFromQQ = NO;
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


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQApiShareEntry class]];
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Where from" message:url.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQApiShareEntry class]];
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

@end
