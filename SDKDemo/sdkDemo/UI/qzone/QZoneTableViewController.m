//
//  QZoneTableViewController.m
//  sdkDemo
//
//  Created by qqconnect on 13-7-8.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "QZoneTableViewController.h"
#import "cellInfo.h"
#import "sdkCall.h"
#import "userInfoViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "ShareToQZoneViewController.h"

@interface QZoneTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
}

@end

@implementation QZoneTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        NSMutableArray *cellQZone = [NSMutableArray array];
        [cellQZone addObject:[cellInfo info:@"分享纯文本到QZone" target:self Sel:@selector(shareTextToQZone) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"分享图片到QZone" target:self Sel:@selector(shareImgToQZone) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"分享视频到QZone" target:self Sel:@selector(shareVideoToQZone) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"获取用户信息" target:self Sel:@selector(getInfo) viewController:nil]];
        [[super sectionName] addObject:@"QZone"];
        [[super sectionRow] addObject:cellQZone];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWnd:) name:kCloseWnd object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kGetUserInfoResponse object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kUploadPicResponse object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListAlbumResponse:) name:kGetListAlbumResponse object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kCheckPageFansResponse object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kAddOneBlogResponse object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getInfo
{
    if (NO == [[[sdkCall getinstance] oauth] getUserInfo])
    {
        [sdkCall showInvalidTokenOrOpenIDMessage];
    };
}

- (void)closeWnd:(NSNotification *)notify
{
    if (notify)
    {
        //if ([[sdkCall getinstance] oauth] == [[notify userInfo] objectForKey:kTencentOAuth])
        {
            UIViewController *viewController = [[notify userInfo] objectForKey:kUIViewController];
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)analysisResponse:(NSNotification *)notify
{
    if (notify)
    {
        APIResponse *response = [[notify userInfo] objectForKey:kResponse];
        if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
        {
            NSMutableString *str=[NSMutableString stringWithFormat:@""];
            for (id key in response.jsonResponse)
            {
                [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
                                  
                                                           delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
        }
    }
}

#pragma mark QZONE RELATIVE

- (void)shareTextToQZone
{
    ShareToQZoneViewController *ctr = [[ShareToQZoneViewController alloc] initWithShareType:kShareToQZoneType_Text];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)shareImgToQZone
{
    ShareToQZoneViewController *ctr = [[ShareToQZoneViewController alloc] initWithShareType:kShareToQZoneType_Images];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)shareVideoToQZone
{
    ShareToQZoneViewController *ctr = [[ShareToQZoneViewController alloc] initWithShareType:kShareToQZoneType_Video];
    [self.navigationController pushViewController:ctr animated:YES];
}


@end
