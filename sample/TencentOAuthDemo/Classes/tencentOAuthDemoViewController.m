//
//  tencentOAuthDemoViewController.m
//  tencentOAuthDemo
//
//  Created by Tencent on 11-11-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "tencentOAuthDemoViewController.h"
#import "SendStoryViewController.h"
#import "QFObject.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
//tencentMessage
#import <TencentOpenAPI/TencentMessageObject.h>
#import "AppInvitationViewController.h"

#define K_BUTTON_START_LOCATION_X 40
#define K_BUTTON_START_LOCATION_Y 35
#define K_BUTTON_X 120
#define K_BUTTON_Y 40
#define K_BUTTON_WIDTH 100
#define K_BUTTON_HEIGHT 35

#define kUserDefaultKeyListAlbumId @"kUserDefaultKeyListAlbumId"

@interface tencentOAuthDemoViewController ()

@property (strong, nonatomic) UIButton *appInvitationButton;

@end

@implementation tencentOAuthDemoViewController


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 250, 40)];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    _oauthButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_oauthButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_oauthButton setTitle:@"OAuth登录" forState:UIControlStateNormal];
	[_oauthButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_oauthButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_oauthButton addTarget:self action:@selector(onClickTencentOAuth) forControlEvents:UIControlEventTouchUpInside];
	[_oauthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_oauthButton];
    
	_getUserInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_getUserInfoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_getUserInfoButton setTitle:@"获取用户信息" forState:UIControlStateNormal];
	[_getUserInfoButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_getUserInfoButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_getUserInfoButton addTarget:self action:@selector(onClickGetUserInfo) forControlEvents:UIControlEventTouchUpInside];
	[_getUserInfoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_getUserInfoButton];
	_getUserInfoButton.enabled = NO;
    
	
	_addShareButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_addShareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_addShareButton setTitle:@"分享" forState:UIControlStateNormal];
	[_addShareButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_addShareButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_addShareButton addTarget:self action:@selector(onClickAddShare) forControlEvents:UIControlEventTouchUpInside];
	[_addShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_addShareButton];
	_addShareButton.enabled = NO;
    
    
	_uploadPicButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_uploadPicButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_uploadPicButton setTitle:@"上传图片" forState:UIControlStateNormal];
	[_uploadPicButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_uploadPicButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_uploadPicButton addTarget:self action:@selector(onClickUploadPic) forControlEvents:UIControlEventTouchUpInside];
	[_uploadPicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_uploadPicButton];
	_uploadPicButton.enabled = NO;
	
	
	_listalbumButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 2 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_listalbumButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_listalbumButton setTitle:@"获取相册列表" forState:UIControlStateNormal];
	[_listalbumButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_listalbumButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_listalbumButton addTarget:self action:@selector(onClickListalbum) forControlEvents:UIControlEventTouchUpInside];
	[_listalbumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_listalbumButton];
	_listalbumButton.enabled = NO;
	
	
	_topicButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + 2 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_topicButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_topicButton setTitle:@"发表说说" forState:UIControlStateNormal];
	[_topicButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_topicButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_topicButton addTarget:self action:@selector(onClickTopic) forControlEvents:UIControlEventTouchUpInside];
	[_topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_topicButton];
	_topicButton.enabled = NO;
	
	
	_listphotoButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 3 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_listphotoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_listphotoButton setTitle:@"获取照片列表" forState:UIControlStateNormal];
	[_listphotoButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_listphotoButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_listphotoButton addTarget:self action:@selector(onClickListPhoto) forControlEvents:UIControlEventTouchUpInside];
	[_listphotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_listphotoButton];
	_listphotoButton.enabled = NO;
	
	_checkfansButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + 3 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_checkfansButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_checkfansButton setTitle:@"验证空间粉丝" forState:UIControlStateNormal];
	[_checkfansButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_checkfansButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_checkfansButton addTarget:self action:@selector(onClickCheckFans) forControlEvents:UIControlEventTouchUpInside];
	[_checkfansButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_checkfansButton];
	_checkfansButton.enabled = NO;
	
	_addalbumButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 4 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_addalbumButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_addalbumButton setTitle:@"创建空间相册" forState:UIControlStateNormal];
	[_addalbumButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_addalbumButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_addalbumButton addTarget:self action:@selector(onClickAddAlbum) forControlEvents:UIControlEventTouchUpInside];
	[_addalbumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_addalbumButton];
	_addalbumButton.enabled = NO;
	
	_addblogButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + 4 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_addblogButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_addblogButton setTitle:@"发表日志" forState:UIControlStateNormal];
	[_addblogButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_addblogButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_addblogButton addTarget:self action:@selector(onClickAddBlog) forControlEvents:UIControlEventTouchUpInside];
	[_addblogButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_addblogButton];
	_addblogButton.enabled = NO;
    
    _setUserHeadPicButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 5 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_setUserHeadPicButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_setUserHeadPicButton setTitle:@"设置用户头像" forState:UIControlStateNormal];
	[_setUserHeadPicButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_setUserHeadPicButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_setUserHeadPicButton addTarget:self action:@selector(onClickSetUserHeadPic) forControlEvents:UIControlEventTouchUpInside];
	[_setUserHeadPicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_setUserHeadPicButton];
	_setUserHeadPicButton.enabled = NO;
    
    _getVipInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + 5 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_getVipInfoBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_getVipInfoBtn setTitle:@"基本会员信息" forState:UIControlStateNormal];
	[_getVipInfoBtn setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_getVipInfoBtn setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_getVipInfoBtn addTarget:self action:@selector(onClickGetVipInfo) forControlEvents:UIControlEventTouchUpInside];
	[_getVipInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_getVipInfoBtn];
	_getVipInfoBtn.enabled = NO;
    
    _getVipRichInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 6 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_getVipRichInfoBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_getVipRichInfoBtn setTitle:@"详细会员信息" forState:UIControlStateNormal];
	[_getVipRichInfoBtn setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_getVipRichInfoBtn setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_getVipRichInfoBtn addTarget:self action:@selector(onClickGetVipRichInfo) forControlEvents:UIControlEventTouchUpInside];
	[_getVipRichInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_getVipRichInfoBtn];
	_getVipRichInfoBtn.enabled = NO;
    
    
    _matchNickTipsBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + 6 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_matchNickTipsBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_matchNickTipsBtn setTitle:@"微博好友提示" forState:UIControlStateNormal];
	[_matchNickTipsBtn setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_matchNickTipsBtn setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_matchNickTipsBtn addTarget:self action:@selector(onClickMatchNickTips) forControlEvents:UIControlEventTouchUpInside];
	[_matchNickTipsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_matchNickTipsBtn];
	_matchNickTipsBtn.enabled = NO;
    
    _getIntimateFriendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 7 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_getIntimateFriendsBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_getIntimateFriendsBtn setTitle:@"微博最近联系人" forState:UIControlStateNormal];
	[_getIntimateFriendsBtn setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_getIntimateFriendsBtn setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_getIntimateFriendsBtn addTarget:self action:@selector(onClickGetIntimateFriends) forControlEvents:UIControlEventTouchUpInside];
	[_getIntimateFriendsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_getIntimateFriendsBtn];
	_getIntimateFriendsBtn.enabled = NO;
    
    
    _sendStoryButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + K_BUTTON_X, K_BUTTON_START_LOCATION_Y + 7 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_sendStoryButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_sendStoryButton setTitle:@"sendStory" forState:UIControlStateNormal];
	[_sendStoryButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_sendStoryButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_sendStoryButton addTarget:self action:@selector(onClickSendStory) forControlEvents:UIControlEventTouchUpInside];
	[_sendStoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_sendStoryButton];
	_sendStoryButton.enabled = NO;

    _appInvitationButton = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 8 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
    [_appInvitationButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_appInvitationButton setTitle:@"AppInvitation" forState:UIControlStateNormal];
    [_appInvitationButton setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
    [_appInvitationButton setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
    [_appInvitationButton addTarget:self action:@selector(onClickAppInvitation:) forControlEvents:UIControlEventTouchUpInside];
    [_appInvitationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_appInvitationButton];
    _appInvitationButton.enabled = NO;
    
    _logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X, K_BUTTON_START_LOCATION_Y + 9 * K_BUTTON_Y, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
	[_logoutBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[_logoutBtn setTitle:@"退出当前APPID" forState:UIControlStateNormal];
	[_logoutBtn setBackgroundImage:[[UIImage imageNamed:@"buttonnormal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateNormal];
	[_logoutBtn setBackgroundImage:[[UIImage imageNamed:@"buttonhover.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21] forState:UIControlStateHighlighted];
	[_logoutBtn addTarget:self action:@selector(onClickLogout) forControlEvents:UIControlEventTouchUpInside];
	[_logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_logoutBtn];
	_logoutBtn.enabled = YES;
    
	_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(K_BUTTON_START_LOCATION_X + 20, K_BUTTON_START_LOCATION_Y + 9 * K_BUTTON_Y, 200, 15)];
	[self.view addSubview:_labelTitle];
	[_labelTitle setFont:[UIFont systemFontOfSize:15.0f]];
	[_labelTitle setBackgroundColor:[UIColor clearColor]];
    [_labelTitle setTextColor:[UIColor redColor]];
    
    _labelAccessToken = [[UILabel alloc] initWithFrame:CGRectMake(10, K_BUTTON_START_LOCATION_Y + 9.5 * K_BUTTON_Y, 400, 15)];
	[self.view addSubview:_labelAccessToken];
	[_labelAccessToken setFont:[UIFont systemFontOfSize:15.0f]];
	[_labelAccessToken setBackgroundColor:[UIColor clearColor]];
    [_labelAccessToken setTextColor:[UIColor redColor]];
    [_labelAccessToken setLineBreakMode:NSLineBreakByCharWrapping];
    [_labelAccessToken setNumberOfLines:0];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, K_BUTTON_START_LOCATION_Y + 9 * K_BUTTON_Y, 300, 15)];
    [self.view addSubview:_progressView];
    [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setHidden:YES];
    
    _permissions = [[NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil] retain];
	
    NSString *appid = @"222222";
    titleLabel.text = [NSString stringWithFormat:@"Demo 1 with appid:%@",appid];
    
	_tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
											andDelegate:self];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

// Override to allow orientations other than the default portrait orientation ios6.0
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/**
 * tencentOAuth
 */
- (void)onClickTencentOAuth {
	_labelTitle.text = @"开始获取token";
	[_tencentOAuth authorize:_permissions inSafari:NO];
}

/**
 * tencentOAuthBySafari
 */
- (void)onClickTencentOAuthBySafari {
	_labelTitle.text = @"开始获取token";
	[_tencentOAuth authorize:_permissions inSafari:YES];
}

/**
 * Get user info.
 */
- (void)onClickGetUserInfo {
	_labelTitle.text = @"开始获取用户基本信息";
	if(![_tencentOAuth getUserInfo]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}

- (void)showInvalidTokenOrOpenIDMessage{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}
/**
 * add Share.
 */
- (void)onClickAddShare {
	_labelTitle.text = @"开始分享";
    
    TCAddShareDic *params = [TCAddShareDic dictionary];
    params.paramTitle = @"腾讯内部addShare接口测试";
    params.paramComment = @"风云乔帮主";
    params.paramSummary =  @"乔布斯被认为是计算机与娱乐业界的标志性人物，同时人们也把他视作麦金塔计算机、iPod、iTunes、iPad、iPhone等知名数字产品的缔造者，这些风靡全球亿万人的电子产品，深刻地改变了现代通讯、娱乐乃至生活的方式。";
    params.paramImages = @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
    params.paramUrl = @"http://www.qq.com";
	
	if(![_tencentOAuth addShareWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
/**
 * uploadPic
 */
- (void)onClickUploadPic {
	_uploadPicButton.enabled = NO;
	_labelTitle.text = @"开始上传图片";
	NSString *path = @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
	NSURL *url = [NSURL URLWithString:path];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img  = [[UIImage alloc] initWithData:data];
    NSString *albumId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyListAlbumId];
    if ([albumId length] == 0)
    {
        albumId = @"c1aa115b-947c-4116-a5fc-128167eaec9f";
    }
	
    TCUploadPicDic *params = [TCUploadPicDic dictionary];
    params.paramPicture = img;
    params.paramAlbumid = albumId;
    params.paramTitle = @"风云乔布斯";
    params.paramPhotodesc = @"比天皇巨星还天皇巨星的天皇巨星";
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
    params.paramX = @"39.909407";
    params.paramY = @"116.397521";
    
	if(![_tencentOAuth uploadPicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
	
	[img release];
	
}
/**
 * Get list album.
 */
- (void)onClickListalbum{
	
	_labelTitle.text = @"开始获取相册列表";
	if(![_tencentOAuth getListAlbum]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}


/**
 * Add Album.
 */
- (void)onClickAddAlbum{
	
	_labelTitle.text = @"开始创建空间相册";
    
    TCAddAlbumDic *params = [TCAddAlbumDic dictionary];
    params.paramAlbumname = @"iosSDK接口测试相册";
    params.paramAlbumdesc = @"我的测试相册";
    params.paramPriv = @"1";
	
	if(![_tencentOAuth addAlbumWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
/**
 * Add Blog.
 */
- (void)onClickAddBlog{
	
	_labelTitle.text = @"开始发表空间日志";
    
    TCAddOneBlogDic *params = [TCAddOneBlogDic dictionary];
    params.paramTitle = @"title";
    params.paramContent = @"哈哈,测试成功";
    
	if(![_tencentOAuth addOneBlogWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}

/**
 * upTopic.
 */
-(void)onClickTopic{
	
	_labelTitle.text = @"正在发表";

    TCAddTopicDic *params = [TCAddTopicDic dictionary];
    params.paramRichtype = @"3";
    params.paramRichval = @"http://www.tudou.com/programs/view/C0FuB0FTv50/";
    params.paramCon = @"腾讯addtopic接口测试--失控小警察视频参数";
    params.paramLbs_nm = @"广东省深圳市南山区高新科技园腾讯大厦";
    params.paramThirdSource = @"2";
    params.paramLbs_x = @"39.909407";
    params.paramLbs_y = @"116.397521";
	if(![_tencentOAuth addTopicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
/**
 * Get List Photo.
 */
-(void)onClickListPhoto{
    NSString *albumId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyListAlbumId];
    if ([albumId length] == 0)
    {
        albumId = @"c1aa115b-947c-4116-a5fc-128167eaec9f";
    }
    
    TCListPhotoDic *params = [TCListPhotoDic dictionary];
    params.paramAlbumid = albumId;
	_labelTitle.text = @"开始获取照片列表";
	
	if(![_tencentOAuth getListPhotoWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
/**
 * Check Fans.
 */
-(void) onClickCheckFans{
	_labelTitle.text = @"正在验证空间粉丝";
    
    TCCheckPageFansDic *params = [TCCheckPageFansDic dictionary];
    [params setParamPage_id:@"973751369"];
	
	if(![_tencentOAuth checkPageFansWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
	
}

/**
 * setUserHeadPic
 */
-(void) onClickSetUserHeadPic
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    }
    ipc.delegate = self;
    ipc.allowsImageEditing = NO;
   
    [self presentViewController:ipc animated:YES completion:nil];
//    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:ipc animated:YES completion:nil];
}

/**
 * getVipInfo
 */
- (void)onClickGetVipInfo
{
    _labelTitle.text = @"正在拉取基本会员信息";
    if (![_tencentOAuth getVipInfo])
    {
        [self showInvalidTokenOrOpenIDMessage];
        _labelTitle.text = @"";
    }
}

/**
 * getVipRichInfo
 */
- (void)onClickGetVipRichInfo
{
    _labelTitle.text = @"正在拉取详细会员信息";
    if (![_tencentOAuth getVipRichInfo])
    {
        [self showInvalidTokenOrOpenIDMessage];
        _labelTitle.text = @"";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *Title = [alertView title];
    NSString *ButtonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    UITextField *textMatch;
    UITextField *textReqnum;

    
    if ([Title isEqualToString:@"请输入匹配字符串"])
    {
        if([ButtonTitle isEqualToString:@"确定"])
        {
            //textMatch = [alertView textFieldAtIndex:0];
            textMatch = (UITextField*)[alertView viewWithTag:0xAA];
            _Marth = [textMatch.text copy];
        }
    }
    else if ([Title isEqualToString:@"请输入请求个数"])
    {
        if([ButtonTitle isEqualToString:@"确定"])
        {
            //textReqnum = [alertView textFieldAtIndex:0];
            textReqnum = (UITextField*)[alertView viewWithTag:0xAA];
            _Reqnum = [textReqnum.text copy];
        }
    }
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}



/**
 * matchNickTips
 */
- (void)onClickMatchNickTips
{
    TextAlertView *alertMatch = [[TextAlertView alloc] initWithTitle:@"请输入匹配字符串" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alertMatch.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInputMatch = [[UITextField alloc] initWithFrame:CGRectZero];
    textInputMatch.borderStyle = UITextBorderStyleRoundedRect;
    [textInputMatch setPlaceholder:@"要匹配的字符串"];
    textInputMatch.tag = 0xAA;
    [alertMatch addSubview:textInputMatch];
    [textInputMatch release];
    
    [alertMatch show];
    [alertMatch release];
    CFRunLoopRun();
    
    TextAlertView *alertReqnum = [[TextAlertView alloc] initWithTitle:@"请输入请求个数" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alertReqnum.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInputReqnum = [[UITextField alloc] initWithFrame:CGRectZero];
    textInputReqnum.borderStyle = UITextBorderStyleRoundedRect;
    [textInputReqnum setPlaceholder:@"请求个数（1-10）"];
    textInputReqnum.tag = 0xAA;
    [alertReqnum addSubview:textInputReqnum];
    [textInputReqnum release];
    
    [alertReqnum show];
    [alertReqnum release];
    CFRunLoopRun();
    
    _labelTitle.text = @"正在拉取微博好友提示";
    
    TCMatchNickTipsDic *params = [TCMatchNickTipsDic dictionary];
    
    [params setParamMatch:_Marth];
    [params setParamReqnum:_Reqnum];
    
    if (![_tencentOAuth matchNickTips:params])
    {
        [self showInvalidTokenOrOpenIDMessage];
        _labelTitle.text = @"";
    }
}


/**
 * getIntimateFriends
 */
- (void)onClickGetIntimateFriends
{
    TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"请输入请求个数" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectZero];
    textInput.borderStyle = UITextBorderStyleRoundedRect;
    [textInput setPlaceholder:@"请求个数（1-20）"];
    textInput.tag = 0xAA;
    [alert addSubview:textInput];
    [textInput release];
    
    [alert show];
    [alert release];
    CFRunLoopRun();
    
    _labelTitle.text = @"正在拉取微博最近联系人";
    
    TCGetIntimateFriendsDic *params = [TCGetIntimateFriendsDic dictionary];
    
    [params setParamReqnum:_Reqnum];
    
    if (![_tencentOAuth getIntimateFriends:params])
    {
        [self showInvalidTokenOrOpenIDMessage];
        _labelTitle.text = @"";
    }
}

/**
 * logout
 */
- (void)onClickLogout
{
    _labelTitle.text = @"退出登录";
    [_tencentOAuth logout:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    TCSetUserHeadpic *params = [TCSetUserHeadpic dictionary];
    params.paramImage = image;
    params.paramFileName = @"make";
    UIViewController *headController = nil;
    
    [self dismissModalViewControllerAnimated:NO];

    
    if(NO == [_tencentOAuth setUserHeadpic:params andViewController:&headController]){
        [self showInvalidTokenOrOpenIDMessage];
    }
    
    if (headController)
    {
        [self presentModalViewController:headController animated:YES];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

/**
 * sendStory
 */
- (void)onClickSendStory
{
    [_labelTitle setHidden:NO];
    if (nil == _sendStoryController)
    {
        _sendStoryController = [[SendStoryViewController alloc] initWithNibName:@"SendStoryViewController" bundle:[NSBundle mainBundle]];
        [_sendStoryController setTencentOAuth:_tencentOAuth];
    }

    UIWindow *mainwnd = [[[UIApplication sharedApplication] delegate] window];
    [mainwnd setRootViewController:_sendStoryController];
}

- (void)onClickAppInvitation:(id)sender
{
    AppInvitationViewController *appInvitaitonVC = [[AppInvitationViewController alloc] initWithTencentOAuth:_tencentOAuth];
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:appInvitaitonVC animated:YES completion:NULL];
    } else {
        [self presentModalViewController:appInvitaitonVC animated:YES];
    }
}

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
	// 登录成功
	_labelTitle.text = @"登录完成";
    
    
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
        _labelAccessToken.text = _tencentOAuth.accessToken;
    }
    else
    {
        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
    
    
	_getUserInfoButton.enabled = YES;
	_addShareButton.enabled = YES;
	_uploadPicButton.enabled = NO;
	_listalbumButton.enabled = YES;
	_topicButton.enabled = YES;
	_listphotoButton.enabled = NO;
	_checkfansButton.enabled = YES;
	_addalbumButton.enabled = YES;
	_addblogButton.enabled = YES;
    _setUserHeadPicButton.enabled = YES;
    _getVipInfoBtn.enabled = YES;
    _getVipRichInfoBtn.enabled = YES;
    _matchNickTipsBtn.enabled = YES;
    _getIntimateFriendsBtn.enabled = YES;
    _logoutBtn.enabled = YES;
    _sendStoryButton.enabled = YES;
    _appInvitationButton.enabled = YES;
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled){
		_labelTitle.text = @"用户取消登录";
	}
	else {
		_labelTitle.text = @"登录失败";
	}
	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
	_labelTitle.text=@"无网络连接，请设置网络";
}

/**
 * Called when the logout.
 */
-(void)tencentDidLogout
{
	_labelTitle.text=@"退出登录成功，请重新登录";
    _labelAccessToken.text = @"";
    
	_getUserInfoButton.enabled = YES;
	_addShareButton.enabled = NO;
	_uploadPicButton.enabled = NO;
	_listalbumButton.enabled = NO;
	_topicButton.enabled = NO;
	_listphotoButton.enabled = NO;
	_checkfansButton.enabled = NO;
	_addalbumButton.enabled = NO;
	_addblogButton.enabled = NO;
    _setUserHeadPicButton.enabled = NO;
    _getVipInfoBtn.enabled = NO;
    _getVipRichInfoBtn.enabled = NO;
    _matchNickTipsBtn.enabled = NO;
    _getIntimateFriendsBtn.enabled = NO;
    _logoutBtn.enabled = NO;
    _sendStoryButton.enabled = NO;
    _appInvitationButton.enabled = NO;
    
}
/**
 * Called when the get_user_info has response.
 */
- (void)getUserInfoResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	_labelTitle.text=@"获取个人信息完成";
}

/**
 * Called when the add_share has response.
 */
- (void)addShareResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles:nil];
		[alert show];
        [alert release];
		
		
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"分享完成";
	
}
/**
 * Called when the uploadPic has response.
 */
- (void)uploadPicResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	_uploadPicButton.enabled = YES;
	_labelTitle.text=@"操作完成";
	
}
/**
 * Called when the getListAlbum has response.
 */
-(void)getListAlbumResponse:(APIResponse*) response {
	NSMutableString *str=[NSMutableString stringWithFormat:@""];
	for (id key in response.jsonResponse) {
		[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
	}
	
	
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
    NSString *albumId = nil;
    NSArray *albumList = [response.jsonResponse objectForKey:@"album"];
    for (NSDictionary *albumDict in albumList)
    {
        NSNumber *picNum = [albumDict objectForKey:@"picnum"];
        albumId = [albumDict objectForKey:@"albumid"];
        if (albumId && [picNum integerValue] > 0)
        {
            break;
        }
    }
    
    if ([albumId length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:albumId forKey:kUserDefaultKeyListAlbumId];
        _listphotoButton.enabled=YES;
		_uploadPicButton.enabled = YES;
    }
    
	_labelTitle.text=@"获取相册列表完成";
	
}
/**
 * Called when the getListPhoto has response.
 */
-(void)getListPhotoResponse:(APIResponse*) response {
	NSMutableString *str=[NSMutableString stringWithFormat:@""];
	for (id key in response.jsonResponse) {
		[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
	}
	
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"获取照片列表完成";
	
}
/**
 * Called when the addTopic has response.
 */
-(void)addTopicResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"发表说说完成";
	
}

/**
 * Called when the checkPageFans has response.
 */
-(void)checkPageFansResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		if ([[NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"isfans"]] isEqualToString:@"1"]) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您是冷兔的粉丝" message:[NSString stringWithFormat:@"%@",str]
								  
														   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
			[alert show];
            [alert release];
			
			_labelTitle.text=@"您是冷兔的粉丝";
			
		}
		else
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您不是冷兔的粉丝" message:[NSString stringWithFormat:@"%@",str]
								  
														   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
			[alert show];
            [alert release];
            
			_labelTitle.text=@"您不是冷兔的粉丝";
		}
		
		
		
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
}
/**
 * Called when the addAlbum has response.
 */


- (void)addAlbumResponse:(APIResponse*) response{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		_labelTitle.text=[NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"albumid"]];
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
        
        NSString *albumId = [response.jsonResponse objectForKey:@"albumid"];
        if ([albumId length] > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:albumId forKey:kUserDefaultKeyListAlbumId];
            _listphotoButton.enabled=YES;
            _uploadPicButton.enabled = YES;
        }
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
}

/**
 * Called when the addOneBlog has response.
 */
- (void)addOneBlogResponse:(APIResponse*) response{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"发表日志完成";
}

/**
 *Called when the setUserHeadPic has response.
 */
- (void)setUserHeadpicResponse:(APIResponse *)response
{
    if (nil == response)
    {
        return;
    }
    
    if (URLREQUEST_FAILED == response.retCode
        && kOpenSDKErrorUserHeadPicLarge == response.detailRetCode)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"您的图片大小超标啦，请更换一张试试呢:)"]
                                                      delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
    
    _labelTitle.text = @"设置好友头像完成";
}


/**
 * Called when the getVipInfo has response.
 */
- (void)getVipInfoResponse:(APIResponse *)response
{
	if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"拉取基本会员信息完成";
}

/**
 * Called when the getVipRichInfo has response.
 */
- (void)getVipRichInfoResponse:(APIResponse *)response
{
	if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"拉取详细会员信息完成";
}


/**
 * Called when the matchNickTips has response.
 */
- (void)matchNickTipsResponse:(APIResponse*) response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"拉取微博好友提示完成";
}

/**
 * Called when the getIntimateFriends has response.
 */
- (void)getIntimateFriendsResponse:(APIResponse*) response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"拉取微博最近联系人完成";
}

/**
 * Called when the sendStory has response.
 */
- (void)sendStoryResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"sendStory操作完成";
}

- (void)appInvitationResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
    {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
	_labelTitle.text=@"sendAppInvitation操作完成";
}

- (void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

//pangzhang aimeng只用关注这个方法里面的内容
- (BOOL)onTencentReq:(TencentApiReq *)req
{
    NSArray *array = [req arrMessage];
    
    for (id obj in array)
    {
        if ([obj isKindOfClass:[TencentImageMessageObjV1 class]])
        {
            //这里用来获得一张图片
            obj = (TencentImageMessageObjV1 *)obj;
            NSString *path = [NSString stringWithFormat:@"%@/qzone0.jpg", [[NSBundle mainBundle] resourcePath]];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
            NSData *data = UIImageJPEGRepresentation(image, 1.0f);
            [obj setDataImage:data];
        }
        else if([obj isKindOfClass:[TencentVideoMessageV1 class]])
        {
            //这里可以用来获得一段视频
            obj = (TencentVideoMessageV1 *)obj;
            
            //填入视频的URL
            //obj setSUrl:<#(NSString *)#>
            //填入视频的预览图
            //obj setDataImagePreview:<#(NSData *)#>
            //填入视频的描述
            //obj setSDescription:<#(TCOptionalStr)#>
        }
        else if([obj isKindOfClass:[TencentImageAndVideoMessageObjV1 class]])
        {
            //这里是图片视频类
            obj = (TencentImageAndVideoMessageObjV1 *)obj;
            
            //aimeng 这里给对象加入图片数据
            NSString *path = [NSString stringWithFormat:@"%@/qzone0.jpg", [[NSBundle mainBundle] resourcePath]];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
            NSData *data = UIImageJPEGRepresentation(image, 1.0f);
            
            [[obj objImageMessage] setDataImage:data];
            
            //aimeng 这里给对象加入视频数据
            //填入视频的URL
            //[obj objVideoMessage] setSUrl:<#(NSString *)#>
            //填入视频的预览图
            //[obj objVideoMessage] setDataImagePreview:<#(NSData *)#>
            //填入视频的描述
            //[obj objVideoMessage] setSDescription:<#(TCOptionalStr)#>
        }
        
    }
    
    TencentApiResp *resp = [TencentApiResp respFromReq:req];
    //发回给QZone
    [TencentOAuth sendRespMessageToTencentApp:resp];
    return YES;
}

#pragma mark -
#pragma mark 析构处理
- (void)dealloc {
	[_oauthButton release];
	[_permissions release];
	[_tencentOAuth release];
	[_getUserInfoButton release];
	[_addShareButton release];
	[_uploadPicButton release];
	[_labelTitle release];
    [_setUserHeadPicButton release];
    [_getVipInfoBtn release];
    [_getVipRichInfoBtn release];
    [_labelAccessToken release];
    [_matchNickTipsBtn release];
    [_getIntimateFriendsBtn release];
    [_logoutBtn release];
    [super dealloc];
}

@end




@implementation TextAlertView

- (void)layoutSubviews{
    
    CGRect rect = self.bounds;
    rect.size.height += 40;
    self.bounds = rect;
    float maxLabelY = 0.f;
    int textFieldIndex = 0;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            
        }
        else if ([view isKindOfClass:[UILabel class]])
        {
            rect = view.frame;
            maxLabelY = rect.origin.y + rect.size.height;
        }
        else if ([view isKindOfClass:[UITextField class]])
        {
            rect = view.frame;
            rect.size.width = self.bounds.size.width - 2*10;
            rect.size.height = 30;
            rect.origin.x = 10;
            rect.origin.y = maxLabelY + 10*(textFieldIndex+1) + 30*textFieldIndex;
            view.frame = rect;
            textFieldIndex++;
        }
        else
        {
            rect = view.frame;
            rect.origin.y = self.bounds.size.height - 65.0;
            view.frame = rect;
        }
    }
    
}

@end


