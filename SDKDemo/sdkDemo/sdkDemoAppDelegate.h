//
//  sdkDemoAppDelegate.h
//  sdkDemo
//
//  Created by qqconnect on 13-3-29.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sdkDemoViewController.h"

@interface sdkDemoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) sdkDemoViewController *viewController;

@property (nonatomic, assign) BOOL isRequestFromQQ;

@end
