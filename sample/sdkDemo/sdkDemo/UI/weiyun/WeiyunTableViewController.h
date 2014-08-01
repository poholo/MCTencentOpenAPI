//
//  WeiyunTableViewController.h
//  sdkDemo
//
//  Created by qqconnect on 13-7-8.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "SdkTableViewController.h"
#import "YIPopupTextView.h"

@interface WeiyunTableViewController : SdkTableViewController<YIPopupTextViewDelegate,UIAlertViewDelegate>
{
    NSString *input_type;
    UIImagePickerController *ipc;
    BOOL *isImagePic;
    BOOL *isStop;
    BOOL *isGetList;

}

@end
