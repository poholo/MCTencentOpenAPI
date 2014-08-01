//
//  tencentOAuthDemoViewController.h
//  tencentOAuthDemo
//
//  Created by Tencent on 11-11-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SendStoryViewController.h"

@interface tencentOAuthDemoViewController : UIViewController <TencentSessionDelegate, UIImagePickerControllerDelegate> {
	TencentOAuth* _tencentOAuth;
	
    UIWindow *window;
    UILabel  *_labelText;
	UIButton *_oauthButton;
    UIButton *_oauthButtonBySafari;
    
	UIButton *_getUserInfoButton;
	UIButton *_addShareButton;
	UIButton *_uploadPicButton;
	UIButton *_listalbumButton;
	UIButton *_topicButton;
	UIButton *_listphotoButton;
	UIButton *_checkfansButton;
	UIButton *_addalbumButton;
	UIButton *_addblogButton;
    UIButton *_setUserHeadPicButton;
    
    UIButton *_getVipInfoBtn;
    UIButton *_getVipRichInfoBtn;
    
    UIButton *_matchNickTipsBtn;
    UIButton *_getIntimateFriendsBtn;
    UIButton *_sendStoryButton;
    
    UIButton *_logoutBtn;
    
	NSMutableArray* _permissions;
	
	
	UILabel                *_labelTitle;
    UILabel                *_labelAccessToken;
    UIProgressView         *_progressView;
    
    NSString *_Marth;
    NSString *_Reqnum;
    id _userData;
    
    SendStoryViewController *_sendStoryController;
}

@end

//弹出带输入框的警示框子类
@interface TextAlertView : UIAlertView

@end
