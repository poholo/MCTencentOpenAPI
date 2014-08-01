//
//  sdkDemoViewController.m
//  sdkDemo
//
//  Created by qqconnect on 13-3-29.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "sdkDemoViewController.h"
#import "sdkCall.h"
#import "showContentViewController.h"
#import "cellInfo.h"
#import "QZoneTableViewController.h"
#import "QQVipTableViewController.h"
#import "QQTTableViewController.h"
#import "WeiyunTableViewController.h"
#import "QQAPIDemoEntry.h"
#import <time.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/WeiBoAPI.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CommonCrypto/CommonDigest.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>

@interface sdkDemoViewController ()
{
    FGalleryViewController  *_localGallery;
    NSInteger               _currentTableViewTag;
    time_t                  loginTime;
}

@property (nonatomic, retain)NSMutableArray *sectionName;
@property (nonatomic, retain)NSMutableArray *sectionRow;

@end

@implementation sdkDemoViewController

@synthesize sectionName = _sectionName;
@synthesize sectionRow = _sectionRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        self.sectionName = [NSMutableArray arrayWithCapacity:1];
        self.sectionRow = [NSMutableArray arrayWithCapacity:1];
        [self loadData];
        _isLogined = NO;
        _currentTableViewTag = 0;
        loginTime = 0;
    }

    return self;
}

- (void)loadData
{
#if __TencentApiSdk_For_TencentApp_
    NSMutableArray *cellRequestContent = [NSMutableArray array];
    [cellRequestContent addObject:[cellInfo info:@"获取一张图片" target:self Sel:@selector(requestSimleImageContent) viewController:nil]];
    [cellRequestContent addObject:[cellInfo info:@"获取一条文本消息" target:self Sel:@selector(requestTextContent) viewController:nil]];
    [cellRequestContent addObject:[cellInfo info:@"批量获取获取图片" target:self Sel:@selector(requestImageContent) viewController:nil]];
    [cellRequestContent addObject:[cellInfo info:@"发表一条说说(仅仅是获得内容)" target:self Sel:@selector(requestPageContent) viewController:nil]];
    [cellRequestContent addObject:[cellInfo info:@"批量获取图片(不走相册)" target:self Sel:@selector(requestImageContentWithoutAssert) viewController:nil]];
    [cellRequestContent addObject:[cellInfo info:@"批量获取视频" target:self Sel:@selector(requestVideos) viewController:nil]];
    [cellRequestContent addObject:[cellInfo info:@"获取一张图片或视频" target:self Sel:@selector(requestImageOrVideo) viewController:nil]];
    [[self sectionName] addObject:@"TencentApi"];
    [[self sectionRow] addObject:cellRequestContent];
#else
    NSMutableArray *cellLogin = [NSMutableArray arrayWithCapacity:1];
    [cellLogin addObject:[cellInfo info:@"第三方登录" target:self Sel:@selector(login) viewController:nil]];
    [[self sectionName] addObject:@"登录"];
    [[self sectionRow] addObject:cellLogin];
    
    NSMutableArray *cellApiInfo = [NSMutableArray arrayWithCapacity:4];
    [cellApiInfo addObject:[cellInfo info:@"QQ空间" target:self Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQZone]]];
    [cellApiInfo addObject:[cellInfo info:@"QQ会员" target:nil Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQQVip]]];
    [cellApiInfo addObject:[cellInfo info:@"腾讯微博" target:nil Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQQT]]];
    [cellApiInfo addObject:[cellInfo info:@"腾讯微云" target:nil Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQQCloud]]];
    [cellApiInfo addObject:[cellInfo info:@"QQAPI" target:nil Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQQ]]];
    [[self sectionName] addObject:@"api"];
    [[self sectionRow] addObject:cellApiInfo];
    
    NSMutableArray *cellTencentAppInfo = [NSMutableArray arrayWithCapacity:1];
    [cellTencentAppInfo addObject:[cellInfo info:@"手机QQ是否支持SSO登录" target:self Sel:@selector(iphoneQQSupportSSO) viewController:nil]];
    [cellTencentAppInfo addObject:[cellInfo info:@"手机QQ是否支持腾讯API" target:self Sel:@selector(iphoneQQSupportTencentApiSdk) viewController:nil]];
    [cellTencentAppInfo addObject:[cellInfo info:@"手机QZone是否支持SSO登陆" target:self Sel:@selector(iphoneQZoneSupportSSO) viewController:nil]];
    [cellTencentAppInfo addObject:[cellInfo info:@"手机QZone是否支持腾讯API" target:self Sel:@selector(iphoneQZoneSupportTencentApiSdk) viewController:nil]];
    
    [[self sectionName] addObject:@"腾讯APP信息"];
    [[self sectionRow] addObject:cellTencentAppInfo];
    
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[sdkCall getinstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[sdkCall getinstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResp:) name:kTencentApiResp object:[sdkCall getinstance]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)iphoneQQSupportSSO
{
    NSString *msg = nil;
    if ([TencentOAuth iphoneQQInstalled])
    {
        msg = [TencentOAuth iphoneQQSupportSSOLogin] ? (@"手机QQ支持SSO登陆") : (@"手机QQ不支持SSO登陆");
    }
    else
    {
        msg = @"手机QQ未安装";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"result" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)iphoneQQSupportTencentApiSdk
{
    NSString *msg = [TencentOAuth iphoneQZoneSupportSSOLogin] ? (@"手机QQ支持腾讯API") : (@"手机QQ不支持腾讯API");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"result" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)iphoneQZoneSupportSSO
{
    NSString *msg = nil;
    if ([TencentOAuth iphoneQZoneInstalled])
    {
        msg = [TencentOAuth iphoneQQSupportSSOLogin] ? (@"手机QZone支持SSO登陆") : (@"手机QZone不支持SSO登陆");
    }
    else
    {
        msg = @"手机QZone未安装";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"result" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)iphoneQZoneSupportTencentApiSdk
{
    NSString *msg = [TencentApiInterface isTencentAppSupportTencentApi:kIphoneQZONE] ? (@"手机QZone支持腾讯API") : (@"手机QZone不支持腾讯API");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"result" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)login
{
    NSArray* permissions = [NSArray arrayWithObjects:
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
                     nil];
    
    [[[sdkCall getinstance] oauth] authorize:permissions inSafari:NO];
}

- (void)pushSelectViewController:(NSNumber *)apiType
{
    UIViewController *rootViewController = nil;
    switch ([apiType unsignedIntegerValue]) { 
        case kApiQZone:
            rootViewController = [[QZoneTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case kApiQQVip:
            rootViewController = [[QQVipTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case kApiQQT:
            rootViewController = [[QQTTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case kApiQQCloud:
            rootViewController = [[WeiyunTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case kApiQQ:
            rootViewController = /*[[QQApiDemoController alloc] init]*/[[QQAPIDemoEntry EntryController] retain];
            break;
        default:
            break;
    }
    [[self navigationController] pushViewController:rootViewController animated:YES];
    __RELEASE(rootViewController);
}


- (void)logout
{
    
}

- (void)showInvalidTokenOrOpenIDMessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)onResp:(NSNotification *)notify
{
    if (notify)
    {
        TencentApiResp *resp = (TencentApiResp *)[[notify userInfo] objectForKey:kTencentRespObj];
        if (kTencentApiSuccess == [resp nRetCode])
        {
            if (_localGallery)
            {
                [_localGallery dismissModalViewControllerAnimated:NO];
                __RELEASE(_localGallery);
            }
            _localGallery = [[FGalleryViewController alloc] initWithPhotoSource:[sdkCall getinstance]];
            
            if (1 == [[resp objReq] nSeq]
                || 3 == [[resp objReq] nSeq]
                || 564601323 == [[resp objReq] nSeq])
            {
                NSArray *array = [[resp objReq] arrMessage];
                for (id obj in array)
                {
                    if([obj isKindOfClass:[TencentImageMessageObjV1 class]])
                    {
                        NSData * data = [obj dataImage];
                        UIImage *image = [UIImage imageWithData:data];
                        if(nil != image)
                        {
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_localGallery];
                            __RELEASE(_localGallery);
                            
                            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
                            {
                                [self presentViewController:navigationController animated:YES completion:nil];
                            }
                            else
                            {
                                [self presentModalViewController:navigationController animated:YES];
                            }

                            __RELEASE(navigationController);
                            return;
                        }
                    }
                }

            }
            else if(2 == [[resp objReq] nSeq])
            {
                if (0 != [[[resp objReq] arrMessage] count])
                {
                    TencentTextMessageObjV1 *obj = [[[resp objReq] arrMessage] objectAtIndex:0];
                    if ([obj isKindOfClass:[TencentTextMessageObjV1 class]])
                    {
                        NSString *text = [obj sText];
                        if (0 == [text length])
                        {
                            text = @"sorry 这家伙太懒没给任何输入";
                        }
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"文本" message:text delegate:nil cancelButtonTitle:@"俺了解了" otherButtonTitles:nil, nil];
                        [alertView show];
                        __RELEASE(alertView);
                    }
                }
            }
            else if(7 == [[resp objReq] nSeq])
            {
                if (0 != [[[resp objReq] arrMessage] count])
                {
                    NSString *urlString = nil;
                    for (TencentVideoMessageV1 *obj in [[resp objReq] arrMessage])
                    {
                        if ([obj isKindOfClass:[TencentVideoMessageV1 class]]
                            && 0 != [[obj sUrl] length])
                        {
                            
                            if (nil == urlString)
                            {
                                urlString = [NSString stringWithFormat:@"url = %@\n", [obj sUrl]];
                            }
                            else
                            {
                                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"url = %@\n", [obj sUrl]]];
                            }
                        }
                    }
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"video" message:urlString delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
                    [alertView show];
                    __RELEASE(alertView);
                }
            }
            else if(8 == [[resp objReq] nSeq])
            {
                if (0 != [[[resp objReq] arrMessage] count])
                {
                    TencentImageAndVideoMessageObjV1 *obj = (TencentImageAndVideoMessageObjV1 *)[[[resp objReq] arrMessage] objectAtIndex:0];
                    NSLog(@"%@", [obj objImageMessage]);
                    NSLog(@"%@", [obj objVideoMessage]);
                }
            }
            else
            {
                NSString *title = nil;
                UIImage *image = nil;
                NSString *audioUrl = nil;
                NSString *videoUrl = nil;
                
                NSArray *messageArray = [[resp objReq] arrMessage];
                for (id obj in messageArray)
                {
                    NSString *name = [obj sName];
                    if ([name isEqualToString:@"description"])
                    {
                        if ([obj isKindOfClass:[TencentTextMessageObjV1 class]])
                        {
                            title = [(TencentTextMessageObjV1 *)obj sText];
                        }
                    }
                    else if ([name isEqualToString:@"title"])
                    {
                        if ([obj isKindOfClass:[TencentImageMessageObjV1 class]])
                        {
                            NSData *dataImage = [(TencentImageMessageObjV1 *)obj dataImage];
                            image = [UIImage imageWithData:dataImage];
                        }
                    }
                    else if ([name isEqualToString:@"url"])
                    {
                        if ([obj isKindOfClass:[TencentAudioMessageObjV1 class]])
                        {
                            audioUrl = [(TencentAudioMessageObjV1 *)obj sUrl];
                        }
                    }
                    else if ([name isEqualToString:@"video Url"])
                    {
                        if ([obj isKindOfClass:[TencentVideoMessageV1 class]])
                        {
                            videoUrl = [(TencentVideoMessageV1 *)obj sUrl];
                        }
                    }
                }
                
                showContentViewController *viewController = [[showContentViewController alloc] init];
                [viewController setSTitle:title];
                [viewController setObjImage:image];
                [viewController setSAudioUrl:audioUrl];
                [viewController setSVideoUrl:videoUrl];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [self presentModalViewController:navController animated:YES];
                __RELEASE(viewController);
                __RELEASE(navController);
            }
        }
    }
}

#pragma mark message
- (void)loginSuccessed
{
    if (NO == _isLogined)
    {
        _isLogined = YES;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    
    NSArray *arrayCell = [[self tableView] visibleCells];
    for (id cell in arrayCell)
    {
        [[cell textLabel] setEnabled:_isLogined];
    }
}

- (void)loginFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self sectionName] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return [[[self sectionRow] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CellIdentifier];
    }
    
    NSString *title = nil;
    NSMutableArray *array = [[self sectionRow] objectAtIndex:section];
    if ([array isKindOfClass:[NSMutableArray class]])
    {
        title = [[array objectAtIndex:row] title];
    }
    
    if (nil == title)
    {
        title = @"未知";
    }
    
    [[cell textLabel] setText:title];
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    if (0 == indexPath.row
//        || 1 == indexPath.row)
//    {
//        [[cell textLabel] setEnabled:YES];
//    }
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self sectionName] objectAtIndex:section];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    NSArray *array = [[self sectionRow] objectAtIndex:section];
    if ([array isKindOfClass:[NSMutableArray class]])
    {
        cellInfo *info = (cellInfo *)[array objectAtIndex:row];
        if ([self respondsToSelector:[info sel]])
        {
            if (nil == [info userInfo])
            {
                [self performSelector:[info sel]];
            }
            else
            {
                [self performSelector:[info sel] withObject:[info userInfo]];
            }
        }
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setHighlighted:NO animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObject:self];
    __SUPER_DEALLOC;
}

@end
