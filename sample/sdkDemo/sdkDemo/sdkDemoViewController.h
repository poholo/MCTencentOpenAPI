//
//  sdkDemoViewController.h
//  sdkDemo
//
//  Created by qqconnect on 13-3-29.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/WeiyunAPI.h>

@interface sdkDemoViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSString *_Marth;
    NSString *_Reqnum;
    BOOL _isLogined;

}
@property (nonatomic, retain)NSString *albumId;
@end
