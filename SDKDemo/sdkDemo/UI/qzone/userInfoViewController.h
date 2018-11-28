//
//  userInfoViewController.h
//  sdkDemo
//
//  Created by qqconnect on 13-4-3.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userInfoViewController : UIViewController

@property (nonatomic, retain)NSString *nick;
@property (nonatomic, retain)NSString *qqLog1;
@property (nonatomic, retain)NSString *qqLog2;
@property (nonatomic, retain)NSString *qzoneLog1;
@property (nonatomic, retain)NSString *qzoneLog2;
@property (assign)BOOL isYellowVip;
@property (assign)short yellowVipLevel;
@property (assign)BOOL isYellowYearVip;
@end
