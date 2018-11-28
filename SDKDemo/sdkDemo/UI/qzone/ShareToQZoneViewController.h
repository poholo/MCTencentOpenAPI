//
//  ShareToQZoneViewController.h
//  sdkDemo
//
//  Created by zilinzhou on 15/11/25.
//  Copyright © 2015年 xiaolongzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareToQZoneType)
{
    kShareToQZoneType_Text,
    kShareToQZoneType_Images,
    kShareToQZoneType_Video,
};

@interface ShareToQZoneViewController : UIViewController

- (id)initWithShareType:(ShareToQZoneType)type;

@end
