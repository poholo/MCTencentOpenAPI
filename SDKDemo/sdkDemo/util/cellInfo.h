//
//  cellInfo.h
//  sdkDemo
//
//  Created by qqconnect on 13-7-3.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kApiQZone,
    kApiQQVip,
    kApiQQT,
    kApiQQ,
    kApiQuick,
    kApiQQqun,
}apiType;

@interface cellInfo : NSObject
+ (cellInfo *)info:(NSString *)title target:(id)target Sel:(SEL)sel viewController:(UIViewController *)viewController userInfo:(id)userInfo;
+ (cellInfo *)info:(NSString *)title target:(id)target Sel:(SEL)sel viewController:(UIViewController *)viewController;

@property (nonatomic, retain)NSString *title;
@property (nonatomic, assign)id  target;
@property (nonatomic, assign)SEL sel;
@property (nonatomic, retain)UIViewController *viewController;
@property (nonatomic, retain)id userInfo;
@end
