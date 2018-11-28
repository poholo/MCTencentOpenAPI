//
//  sdkDemoViewController.m
//  sdkDemo
//
//  Created by qqconnect on 13-3-29.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "sdkDemoViewController.h"
#import "sdkCall.h"
#import "cellInfo.h"
#import "sdkDef.h"
#import "QZoneTableViewController.h"
#import "QQApiShareEntry.h"
#import <time.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CommonCrypto/CommonDigest.h>

@implementation sdkDemoNavgationController

- (BOOL)shouldAutorotate
{
    return BOOL_SHOULD_AUTORATE;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return Supported_Interface_Orientations;
}

@end

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

- (NSMutableArray *)getPermissions
{
    NSMutableArray * g_permissions = [[NSMutableArray alloc] initWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                                      kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                      kOPEN_PERMISSION_ADD_ALBUM,
                                      kOPEN_PERMISSION_ADD_ONE_BLOG,
                                      kOPEN_PERMISSION_ADD_SHARE,
                                      kOPEN_PERMISSION_ADD_TOPIC,
                                      kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                      kOPEN_PERMISSION_GET_INFO,
                                      kOPEN_PERMISSION_GET_OTHER_INFO,
                                      kOPEN_PERMISSION_LIST_ALBUM,
                                      kOPEN_PERMISSION_UPLOAD_PIC,
                                      kOPEN_PERMISSION_GET_VIP_INFO,
                                      kOPEN_PERMISSION_GET_VIP_RICH_INFO, nil];
    
    return [g_permissions autorelease];
}

- (void)loadData
{
    
    NSMutableArray *cellLogin = [NSMutableArray arrayWithCapacity:1];
    [cellLogin addObject:[cellInfo info:@"第三方登录" target:self Sel:@selector(login) viewController:nil]];
    [cellLogin addObject:[cellInfo info:@"第三方扫码登录" target:self Sel:@selector(loginWithQRlogin) viewController:nil]];
    [cellLogin addObject:[cellInfo info:@"退出账号" target:self Sel:@selector(logout) viewController:nil]];
    [[self sectionName] addObject:@"登录相关"];
    [[self sectionRow] addObject:cellLogin];
    
    NSMutableArray *tokenArr = [NSMutableArray array];
    [tokenArr addObject:[cellInfo info:@"查看缓存Token" target:self Sel:@selector(viewCachedToken) viewController:nil]];
    [tokenArr addObject:[cellInfo info:@"删除缓存Token" target:self Sel:@selector(deleteCachedToken) viewController:nil]];
    [[self sectionName] addObject:@"Token"];
    [[self sectionRow] addObject:tokenArr];
    
    NSMutableArray *cellApiInfo = [NSMutableArray arrayWithCapacity:4];
    [cellApiInfo addObject:[cellInfo info:@"QQ分享" target:nil Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQQ]]];
    [cellApiInfo addObject:[cellInfo info:@"QQ空间" target:self Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQZone]]];
    [cellApiInfo addObject:[cellInfo info:@"UnionID" target:nil Sel:@selector(RequestUnionId) viewController:nil userInfo:nil]];
    [cellApiInfo addObject:[cellInfo info:@"QQ群" target:nil Sel:@selector(pushSelectViewController:) viewController:nil userInfo:[NSNumber numberWithInteger:kApiQQqun]]];
    
    [[self sectionName] addObject:@"api"];
    [[self sectionRow] addObject:cellApiInfo];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCannelled) name:kLoginCancelled object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUnionID) name:kGetUnionID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessed) name:kLogoutSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccessed:) name:kGetUserInfoResponse object:nil];
    
    
    //为了初始化以下sdk
    [sdkCall getinstance];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *version = [NSString stringWithFormat:@"Open SDK(%@.%@)%@",
                         [TencentOAuth sdkVersion], [TencentOAuth sdkSubVersion],
                         ([TencentOAuth isLiteSDK] ? @"Lite" : @"")];
    self.title = version;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login
{
    time_t currentTime;
    time(&currentTime);
    
    if ((currentTime - loginTime) > 2)
    {
        TencentOAuth * oauth = [[sdkCall getinstance] oauth];
        oauth.authMode = kAuthModeClientSideToken;
        [oauth authorize:[self getPermissions] inSafari:NO];
        loginTime = currentTime;
    }
}

- (void)loginWithQRlogin
{
    time_t currentTime;
    time(&currentTime);
    
    if ((currentTime - loginTime) > 2)
    {
        TencentOAuth * oauth = [[sdkCall getinstance] oauth];
        oauth.authMode = kAuthModeClientSideToken;
        //二维码登录
        [oauth authorizeWithQRlogin:[self getPermissions]];
        loginTime = currentTime;
    }
}

- (void)viewCachedToken
{
    NSString *token = [[sdkCall getinstance].oauth getCachedToken];
    NSString *openid = [[sdkCall getinstance].oauth getCachedOpenID];
    NSDate *exp = [[sdkCall getinstance].oauth getCachedExpirationDate];
    BOOL isValid = [[sdkCall getinstance].oauth isCachedTokenValid];
    NSString *str = [NSString stringWithFormat:@"token:%@\nopenid:%@\n 过期时间:%@\n 是否有效:%d",token,openid, exp, isValid];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"缓存的Token" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)deleteCachedToken
{
    BOOL ret =  [[sdkCall getinstance].oauth deleteCachedToken];
    NSString *result = [NSString stringWithFormat:@"删除结果：%d", ret];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除缓存的Token" message:result delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)pushSelectViewController:(NSNumber *)apiType
{
    UIViewController *rootViewController = nil;
    switch ([apiType unsignedIntegerValue]) {
        case kApiQZone:
            rootViewController = [[QZoneTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case kApiQQ:
            rootViewController = /*[[QQApiDemoController alloc] init]*/[[QQApiShareEntry EntryController] retain];
            break;
        case kApiQQqun:
            rootViewController = [[QQApiShareEntry QQqunEntryController] retain];
            break;
            break;
        default:
            break;
    }
    [[self navigationController] pushViewController:rootViewController animated:YES];
    __RELEASE(rootViewController);
}

- (void)RequestUnionId {
    BOOL bRet = [[[sdkCall getinstance] oauth] RequestUnionId];
    if (!bRet) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息不足，请先登录。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        __RELEASE(alertView);
    }
}

- (void)logout
{
    [[sdkCall getinstance] logout];
}

- (void)showInvalidTokenOrOpenIDMessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark message
- (void)loginSuccessed
{
    if (NO == _isLogined)
    {
        _isLogined = YES;
    }
    
    NSString *result = nil;
    if ([sdkCall getinstance].oauth.authMode == kAuthModeServerSideCode ) {
        result = [NSString stringWithFormat:@"登录成功 passData = \n %@,\n%@ = %@",
                  [[sdkCall getinstance].oauth passData],
                  @"Sever Code",
                  [sdkCall getinstance].oauth.accessToken];
    }
    else
    {
        result = [NSString stringWithFormat:@"登录成功 passData = \n %@,\n%@ = %@, openid = %@",
                            [[sdkCall getinstance].oauth passData],
                            @"Client Token",
                            [sdkCall getinstance].oauth.accessToken,
                            [sdkCall getinstance].oauth.openId];
    }
    
    NSString *resultTitle = [NSString stringWithFormat:@"登录结果(%@)", ([sdkCall getinstance].oauth.authMode == kAuthModeServerSideCode ? @"Sever Code" : @"Client Token")];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:resultTitle message:result delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    
    NSArray *arrayCell = [[self tableView] visibleCells];
    for (id cell in arrayCell)
    {
        [[cell textLabel] setEnabled:_isLogined];
    }
    __RELEASE(alertView);
    
    NSMutableArray *cellLogin = self.sectionRow[0];
    if (cellLogin.count == 3)
    {
        return;
    }
    [cellLogin addObject:[cellInfo info:@"获取个人信息" target:self Sel:@selector(getUserInfo) viewController:nil]];
    [self.tableView reloadData];
}
- (void)getUserInfo
{
    if (![[sdkCall getinstance].oauth getUserInfo])
    {
        NSAssert(NO,@"获取用户信息失败");
    }
}
- (void)getUserInfoSuccessed:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    APIResponse *response = userInfo[kResponse];
    NSDictionary *message = response.jsonResponse;
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    [self.view addSubview:userInfoView];
    userInfoView.tag = 666;
    userInfoView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    userInfoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.text = [NSString stringWithFormat:@"昵称:%@",message[@"nickname"]];
    [userInfoView addSubview:nameLabel];
    
    UILabel *gender = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, 50)];
    gender.textAlignment = NSTextAlignmentCenter;
    gender.font = [UIFont systemFontOfSize:20];
    gender.text = [NSString stringWithFormat:@"性别:%@",message[@"gender"]];
    [userInfoView addSubview:gender];
    
    UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
    city.textAlignment = NSTextAlignmentCenter;
    city.font = [UIFont systemFontOfSize:20];
    city.text = [NSString stringWithFormat:@"城市:%@",message[@"city"]];
    [userInfoView addSubview:city];
    
    UILabel *year = [[UILabel alloc] initWithFrame:CGRectMake(200, 50, 200, 50)];
    year.textAlignment = NSTextAlignmentCenter;
    year.font = [UIFont systemFontOfSize:20];
    year.text = [NSString stringWithFormat:@"出生年份:%@",message[@"year"]];
    [userInfoView addSubview:year];
    
    UIImageView *heardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 80, 80)];
    heardImageView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    heardImageView.image = [self imageWithUrl:message[@"figureurl_1"]];
    [userInfoView addSubview:heardImageView];
    
    UIImageView *heardImageViewQQ = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 80, 80)];
    heardImageViewQQ.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    heardImageViewQQ.image = [self imageWithUrl:message[@"figureurl_qq_1"]];
    [userInfoView addSubview:heardImageViewQQ];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, 350, 50, 50)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchDown];
    [userInfoView addSubview:closeBtn];
    
}
- (UIImage *)imageWithUrl:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}
- (void)closeAction
{
    UIView *userInfoView = [self.view viewWithTag:666];
    [userInfoView removeFromSuperview];
}


- (void)loginFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)loginCannelled
{
    //do nothing
}

- (void)logoutSuccessed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"已退出登录" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    __RELEASE(alertView);
}

- (void)didGetUnionID {
    NSString *result  = [NSString stringWithFormat:@"获取成功 appid = %@,\n openid = %@,\n unionid = %@",
                         [[sdkCall getinstance].oauth appId],
                         [sdkCall getinstance].oauth.openId,
                         [sdkCall getinstance].oauth.unionid];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    __RELEASE(alertView);
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CellIdentifier] autorelease];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.albumId = nil;
    self.sectionName = nil;
    self.sectionRow = nil;
    [super dealloc];
}

@end
