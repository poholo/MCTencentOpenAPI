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
#import "NSURLRequest+IgnoreSSL.h"

#if __QQAPI_ENABLE__
#import "TencentOpenAPI/QQApiInterface.h"
#import "QQAPIDemoEntry.h"
#endif

@implementation sdkDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSURLRequest allowsAnyHTTPSCertificateForHost:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[sdkDemoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [[self window] setRootViewController:navController];
    [[self window] makeKeyAndVisible];
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


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    NSString *strUrl = @"http://dajdklajdka?";
//    url = [NSURL URLWithString:strUrl];

#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQAPIDemoEntry class]];
#endif
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Where from" message:url.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //[alertView show];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQAPIDemoEntry class]];
#endif
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

@end
