//
//  tencentOAuthDemoAppDelegate.m
//  tencentOAuthDemo
//
//  Created by Tencent on 11-11-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "tencentOAuthDemoAppDelegate.h"
#import "tencentOAuthDemoViewController.h"

@implementation tencentOAuthDemoAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
    
    [[self window] setRootViewController:viewController];
    [[self window] makeKeyAndVisible];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
