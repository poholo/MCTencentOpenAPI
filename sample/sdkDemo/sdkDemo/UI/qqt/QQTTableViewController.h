//
//  QQTTableViewController.h
//  sdkDemo
//
//  Created by qqconnect on 13-7-8.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "SdkTableViewController.h"
#import "YIPopupTextView.h"

@interface QQTTableViewController : SdkTableViewController<YIPopupTextViewDelegate>
{
    NSString *_Marth;
    NSString *_Reqnum;
    NSString *_inputStr;
    NSString *type;
    BOOL *isStop;
}
@end
