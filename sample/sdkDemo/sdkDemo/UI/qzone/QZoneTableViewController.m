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
#import "SendStoryViewController.h"
#import "userInfoViewController.h"
#import "blumListViewController.h"
#import "addAlbumViewController.h"

@interface QZoneTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
}

@property (nonatomic, retain)UIImagePickerController *setUserHeaderIpc;

@end

@implementation QZoneTableViewController
@synthesize setUserHeaderIpc = _setUserHeaderIpc;
@synthesize albumId = _albumId;

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
        [cellQZone addObject:[cellInfo info:@"获取用户信息" target:self Sel:@selector(getInfo) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"上传图片" target:self Sel:@selector(uploadPic) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"获取相册列表" target:self Sel:@selector(listalbum) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"创建空间相册" target:self Sel:@selector(addAlbum) viewController:nil]];
        [cellQZone addObject:[cellInfo info:@"设置用户头像" target:self Sel:@selector(setUserHeadPic) viewController:nil]];
        [[super sectionName] addObject:@"QZone"];
        [[super sectionRow] addObject:cellQZone];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWnd:) name:kCloseWnd object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kGetUserInfoResponse object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kUploadPicResponse object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListAlbumResponse:) name:kGetListAlbumResponse object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kAddTopicResponse object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kCheckPageFansResponse object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kAddOneBlogResponse object:[sdkCall getinstance]];
        
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

- (void)uploadPic
{
    if (0 == [[self albumId] length])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有获得一个相册ID，请创建一个新的相册或者获取相册列表。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg"]]];
    
    TCUploadPicDic *params = [TCUploadPicDic dictionary];
    params.paramPicture = image;
    params.paramAlbumid = [self albumId];
    params.paramTitle = @"风云乔布斯";
    params.paramPhotodesc = @"比天皇巨星还天皇巨星的天皇巨星";
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
    params.paramX = @"39.909407";
    params.paramY = @"116.397521";
    
    if (NO == [[[sdkCall getinstance] oauth] uploadPicWithParams:params])
    {
        [sdkCall showInvalidTokenOrOpenIDMessage];
    };
}

- (void)listalbum
{
    if (NO == [[[sdkCall getinstance] oauth] getListAlbum])
    {
        [sdkCall showInvalidTokenOrOpenIDMessage];
    };
}

- (void)addAlbum
{
    addAlbumViewController *viewController = [[addAlbumViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //5.0+
    [self presentModalViewController:navigationController animated:YES];
}

-(void)setUserHeadPic
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    }
    ipc.delegate = self;
    _setUserHeaderIpc = ipc;
    [self presentModalViewController:ipc animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == _setUserHeaderIpc)
    {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        TCSetUserHeadpic *params = [TCSetUserHeadpic dictionary];
        params.paramImage = image;
        params.paramFileName = @"make";
        UIViewController *headController = nil;
        
        if(NO == [[[sdkCall getinstance] oauth] setUserHeadpic:params andViewController:&headController])
        {
            [sdkCall showInvalidTokenOrOpenIDMessage];
        }
        
        if (!headController)
        {
            return;
        }
        
        UIApplication *app = [UIApplication sharedApplication];
        UIViewController *rootController = [[[app delegate] window] rootViewController];
        [rootController dismissModalViewControllerAnimated:NO];
        [rootController presentModalViewController:headController animated:YES];
    }
}

- (void)closeWnd:(NSNotification *)notify
{
    if (notify)
    {
        if ([[sdkCall getinstance] oauth] == [[notify userInfo] objectForKey:kTencentOAuth])
        {
            UIViewController *viewController = [[notify userInfo] objectForKey:kUIViewController];
            [viewController dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)listAlbumResponse:(NSNotification *)notify
{
    if (notify)
    {
        APIResponse *response = [[notify userInfo] objectForKey:kResponse];
        if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
        {
            
        }
        else
        {
            NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)getListAlbumResponse:(NSNotification *)notify
{
    if (notify)
    {
        APIResponse *response = [[notify userInfo] objectForKey:kResponse];
        if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
        {
            NSArray *blumArray = [[response jsonResponse] objectForKey:@"album"];
            if (0 == [blumArray count])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:@"您的空间还没有相册，赶紧去创建一个吧。" delegate:self cancelButtonTitle:@"好的，这就去" otherButtonTitles: @"算啦", nil];
                [alert show];
                return;
            }
            
            [self setAlbumId:[[blumArray objectAtIndex:0] objectForKey:@"albumid"]];
            blumListViewController *viewController = [[blumListViewController alloc] initWithNibName:nil bundle:nil];
            [viewController setBlumList:blumArray];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [navController setTitle:@"相册列表"];
            [self presentModalViewController:navController animated:YES];
        }
        else
        {
            NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
        }
    }
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

@end
