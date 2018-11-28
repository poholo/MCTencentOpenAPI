//
//  QQApiShareEntryControllerViewController.m
//  sdkDemo
//
//  Created by JeaminW on 13-7-28.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "QQAPIShareEntry.h"
#import "QuickDialogController.h"
#import "QRootElement.h"
#import "QBooleanElement.h"
#import <objc/runtime.h>

#import "sdkDemoAppDelegate.h"
#import "sdkCall.h"
#import "NSData+HexAdditions.h"

#if BUILD_QQAPIDEMO
#import "TencentOpenAPI/QQApiInterface.h"
#endif

#define SDK_TEST_IMAGE_FILE_NAME             @"/test"  //为了测试多种图片类型的分享流程，这里需要在应用目录下放置不同类型图片

@implementation QQApiShareEntry

+ (UIViewController *)EntryController
{
#ifndef QQ_OPEN_SDK_LITE
    UIViewController *QDialog = [QuickDialogController controllerForRoot:[QRootElement rootForJSON:@"QQAPIDemo" withObject:nil]];
#else
    UIViewController *QDialog = [QuickDialogController controllerForRoot:[QRootElement rootForJSON:@"QQAPIDemo_lite" withObject:nil]];
#endif
    return QDialog;
}

+ (UIViewController *)QQqunEntryController {
    UIViewController *QDialog = [QuickDialogController controllerForRoot:[QRootElement rootForJSON:@"QQAPIQQqunDemo" withObject:nil]];
    return QDialog;
}

+ (BOOL)isRequestFromQQ
{
    sdkDemoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.isRequestFromQQ;
}

#if BUILD_QQAPIDEMO
#pragma mark - QQApiInterfaceDelegate
+ (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:      // 手Q -> 第三方应用，请求第三方应用向手Q发送消息
        {
            sdkDemoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.isRequestFromQQ = YES;
            break;
        }
        default:
        {
            break;
        }
    }
}

+ (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendReq = (SendMessageToQQResp*)resp;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendReq.result message:sendReq.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        default:
        {
            break;
        }
    }
}
#endif

@end


@interface QQAPIDemoCommonController : QuickDialogController

@property (nonatomic, strong) NSString *binding_title;
@property (nonatomic, strong) NSString *binding_text;
@property (nonatomic, strong) NSString *binding_description;
@property (nonatomic, strong) NSString *binding_url;
@property (nonatomic, strong) UIImage *binding_previewImage;
@property (nonatomic, strong) NSString *binding_previewImageUrl;
@property (nonatomic, strong) NSString *binding_webpImageUrl;
@property (nonatomic, strong) NSString *binding_streamUrl;
@property (nonatomic, strong) NSString *binding_openID;
@property (nonatomic, strong) NSString *binding_subID;
@property (nonatomic, strong) NSString *binding_remark;

@property (nonatomic, strong) NSString *binding_ownerSignature;
@property (nonatomic, strong) NSString *binding_GameSectionID;
@property (nonatomic, strong) NSString *binding_GroupID;
@property (nonatomic, strong) NSString *binding_GroupKey;
@property (nonatomic, strong) NSString *binding_imageCount;
@property (nonatomic, strong) NSString *binding_bid;
@property (nonatomic, strong) NSString *binding_groupTribeName;

@property (nonatomic, strong) NSString *binding_appkey;

@property (nonatomic, strong) NSString *tenpayID;
@property (nonatomic, strong) NSString *tenpayAppInfo;
@property (nonatomic, strong) UIControl *qrcodePanel;
@property (nonatomic, strong) UIImageView *qrcodeImgView;

@property (nonatomic, strong) NSArray *imageAssetsForQZone;
@property (nonatomic, strong) NSURL *videoAssetForQZone;

// WPA
@property (nonatomic, strong) NSString *binding_uin;

@property (nonatomic, strong) QQApiObject *qqApiObject;
@property (nonatomic, strong) ArkObject *arkObject;

@property (nonatomic, assign) BOOL webpFlag;

@end

@implementation QQAPIDemoCommonController

- (id)init
{
    if (self = [super init])
    {
        self.webpFlag = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.root.object isKindOfClass:[NSDictionary class]])
    {
        NSString *jsonConfig = self.root.object[@"jsonConfig"];
        if ([jsonConfig isKindOfClass:[NSString class]])
        {
            self.root = [QRootElement rootForJSON:jsonConfig withObject:nil];
        }
    }
    
    CGRect frame = [[self view] bounds];
    self.qrcodePanel = [[UIControl alloc] initWithFrame:frame];
    self.qrcodePanel.hidden = YES;
    self.qrcodePanel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.qrcodePanel addTarget:self action:@selector(onQRCodePanelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qrcodePanel];
    
    CGRect panelFrame = [self.qrcodePanel bounds];
    CGFloat minSize = MIN(panelFrame.size.width, panelFrame.size.height) * 0.9f;
    self.qrcodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minSize, minSize)];
    self.qrcodeImgView.center = CGPointMake(CGRectGetMidX(panelFrame), CGRectGetMidY(panelFrame));
    [self.qrcodePanel addSubview:self.qrcodeImgView];
    
    if ([[self.root key] isEqualToString:@"QQAPIDemo"])
    {
        [[self currentNavContext] removeAllObjects];
    }
}

- (NSMutableDictionary *)currentNavContext
{
    UINavigationController *navCtrl = [self navigationController];
    NSMutableDictionary *context = objc_getAssociatedObject(navCtrl, (__bridge void *)(@"currentNavContext"));
    if (nil == context)
    {
        context = [NSMutableDictionary dictionaryWithCapacity:3];
        objc_setAssociatedObject(navCtrl, (__bridge void *)(@"currentNavContext"), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return context;
}

- (void)onSwitchCFlag:(QElement *)sender
{
    if ([sender isKindOfClass:[QBooleanElement class]])
    {
        QBooleanElement *boolElem = (QBooleanElement *)sender;
        NSString *flagKey = boolElem.key;
        uint32_t flagValue = [boolElem.object[@"flagValue"] unsignedIntValue] * (!![boolElem boolValue]);
        [[self currentNavContext] setObject:[NSNumber numberWithUnsignedInt:flagValue] forKey:flagKey];

        NSLog(@"%@",[self currentNavContext]);
        TencentOAuth *tcOAuth=[[TencentOAuth alloc] init];
        NSMutableDictionary *navDic=[[NSMutableDictionary alloc] initWithDictionary:[self currentNavContext]];
//        if ([navDic.allKeys containsObject:@"kQQAPICtrlFlagQQShareh5"]) {
//            if ([[navDic[@"kQQAPICtrlFlagQQShareh5"] stringValue] isEqualToString:@"32"]) {
//                [tcOAuth openSDKWebViewQQShareEnable];
//            }
//        }
        
    }
}

- (uint64_t)shareControlFlags
{
    NSDictionary *context = [self currentNavContext];
    __block uint64_t cflag = 0;
    [context enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]] &&
            [key isKindOfClass:[NSString class]] &&
            [key hasPrefix:@"kQQAPICtrlFlag"])
        {
            cflag |= [obj unsignedIntValue];
        }
    }];
    
    return cflag;
}

- (ShareDestType)getShareType
{
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdkSwitchFlag"] boolValue];
    return flag? ShareDestTypeTIM :ShareDestTypeQQ;
}

#if BUILD_QQAPIDEMO
- (void)onShowShareSubMenu:(QElement *)sender
{
    QEntryElement *entry  = (QEntryElement *) [self.root elementWithKey:@"inputArkJson"];
    if(entry.key && entry.textValue){
        [[self currentNavContext] setObject:entry.textValue forKey:entry.key];
    }
}

- (void)onShareText:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:self.binding_text ? : @""];
    [txtObj setCflag:[self shareControlFlags]];
    if (txtObj.cflag & kQQAPICtrlFlagQZoneShareOnStart) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"纯文本暂不支持直接分享到Qzone" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
        return;
    }
    
    _qqApiObject = txtObj;
    QQApiSendResultCode ret = EQQAPISENDFAILD;
    QQBaseReq *req = [self getReq:txtObj thisTypeEnableArk:YES arkJson:nil];
    ret = [QQApiInterface sendReq:req];
    [self handleSendResult:ret];
}


- (void)onloadImage:(QElement *)sender
{
    [self.root fetchValueUsingBindingsIntoObject:self];
}


- (void)onShareImage:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:SDK_TEST_IMAGE_FILE_NAME];
    NSData *imgData = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        imgData = [NSData dataWithContentsOfFile:path];
    }else {
        NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.gif"];
        imgData = [NSData dataWithContentsOfFile:imgPath];
    }

    NSData *preImgData = imgData;
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.85);
        NSData *selectedPreImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.20);//对于大于1M的图直接作为缩略图会过大，因此压缩系数要更小
        if (selectedImgData)
        {
            imgData = selectedImgData;
        }
        if (selectedPreImgData)
        {
            preImgData = selectedPreImgData;
        }
    }
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                 previewImageData:preImgData
                                            title:self.binding_title ? : @""
                                      description:self.binding_description ? : @""];
    
    [imgObj setCflag:[self shareControlFlags]];
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:imgObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];
}

- (QQBaseReq *)getReq:(QQApiObject *)qqobj thisTypeEnableArk:(BOOL)thisTypeEnableArk arkJson:(NSString *)arkJson
{
    SendMessageToQQReq *req = nil;
    if( thisTypeEnableArk && ((qqobj.cflag & kQQAPICtrlFlagQQShareEnableArk) == kQQAPICtrlFlagQQShareEnableArk) ){
        NSString *json = ( (arkJson == nil) ? [self getDebugArkJson] : arkJson);
        ArkObject *arkObj = [ArkObject objectWithData:json qqApiObject:qqobj];
        _arkObject = arkObj;
        req = [SendMessageToQQReq reqWithArkContent:arkObj];
    }else{
        _qqApiObject = qqobj;
        req = [SendMessageToQQReq reqWithContent:qqobj];
    }
    return req;
}

- (NSString *)getDebugArkJson
{
    NSDictionary *context = [self currentNavContext];
    __block NSString *arkJson = nil;
    [context enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] &&
            [key isKindOfClass:[NSString class]] &&
            [key isEqualToString:@"inputArkJson"])
        {
            arkJson = (NSString*)obj;
        }
    }];
    return arkJson;
    
//    NSDictionary *dict = @{@"app" : @"com.tencent.music", @"view" : @"Share", @"meta" : @""};
//    NSData *objectData = [@"{\"config\":{\"forward\":true,\"type\":\"card\",\"autosize\":true},\"prompt\":\"[应用]音乐\",\"app\":\"com.tencent.music\",\"ver\":\"1.0.1.26\",\"view\":\"Share\",\"meta\":{\"Share\":{\"musicId\":\"4893051\"}},\"desc\":\"音乐\"}" dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:objectData
//                                                             options:NSJSONReadingMutableContainers // Pass 0 if you don't care about the readability of the generated string
//                                                               error:nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//
//
//
//    NSString *jsonString = @"";
//
//    if (! jsonData)
//    {
//        NSLog(@"Got an error: %@", error);
//    }else
//    {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//
//    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//
//    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
//    return jsonString;
}

////网络单图分享
//- (void)onShareWebImage:(QElement *)sender
//{
//    [self.view endEditing:YES];
//    [self.root fetchValueUsingBindingsIntoObject:self];
//
//    QQApiWebImageObject *webImageObj = [QQApiWebImageObject
//                                         objectWithPreviewImageURL:[NSURL URLWithString:self.binding_previewImageUrl ? : @""]
//                                         title:self.binding_title ? : @""
//                                         description:self.binding_description ? : @""];
//    [webImageObj setCflag:[self shareControlFlags]];
//    _qqApiObject = webImageObj;
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:webImageObj];
//    QQApiSendResultCode ret = [QQApiInterface sendReq:req];
//    [self handleSendResult:ret];
//}

- (void)onShareMutileImage:(QElement *)sender
{
    uint64_t flag = [self shareControlFlags];
    if ((flag & kQQAPICtrlFlagQQShareFavorites) != kQQAPICtrlFlagQQShareFavorites) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:@"请你回到上一级目录，在顶头只打开'收藏'开关，再来测试。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    NSData *preImgData = imgData;
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.85);
        NSData *selectedPreImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.20);
        if (selectedImgData)
        {
            imgData = selectedImgData;
        }
        if (selectedPreImgData)
        {
            preImgData = selectedPreImgData;
        }
    }
    
    NSString *imgPath2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
    NSData *imgData2 = [NSData dataWithContentsOfFile:imgPath2];
    NSString *imgPath3 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img.jpg"];
    NSData *imgData3 = [NSData dataWithContentsOfFile:imgPath3];
    
    NSArray* imgArray = [NSArray arrayWithObjects:imgData, imgData2, imgData3, nil]; //多个图片
    QQApiImageObject *imgObj =  [QQApiImageObject objectWithData:imgData
                     previewImageData:preImgData
                                title:self.binding_title ? : @""
                          description:self.binding_description ? : @""
                       imageDataArray:imgArray];
    
    //key_ImageDataArray;
    
    [imgObj setCflag:[self shareControlFlags]];
    _qqApiObject = imgObj;
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:imgObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];
}

- (void)onShareNewsLocal:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
    NSData *previewData = [NSData dataWithContentsOfFile:previewPath];
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.20);
        if (selectedImgData)
        {
            previewData = selectedImgData;
        }
    }
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                        title:self.binding_title ? : @""
                                                  description:self.binding_description ? : @""
                                             previewImageData:previewData];
    [newsObj setCflag:[self shareControlFlags]];
    _qqApiObject = newsObj;
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:newsObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];
}

- (void)onShareNewsWeb:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    QQApiNewsObject *newsObj = nil;
    if (self.webpFlag) {
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                            title:self.binding_title ? : @""
                                                      description:self.binding_description ? : @""
                                                  previewImageURL:[NSURL URLWithString:self.binding_webpImageUrl ? : @""]];
    }
    else {
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                               title:self.binding_title ? : @""
                                         description:self.binding_description ? : @""
                                     previewImageURL:[NSURL URLWithString:self.binding_previewImageUrl ? : @""]];
    }
    [newsObj setCflag:[self shareControlFlags]];
    _qqApiObject = newsObj;
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:newsObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];
}

- (void)onSwitchWebpFlag:(QElement *)sender {
    QBooleanElement *boolElem = (QBooleanElement *)sender;
    uint32_t flagValue = [boolElem.object[@"flagValue"] unsignedIntValue] * (!![boolElem boolValue]);
    self.webpFlag = flagValue > 0 ? YES : NO;
}

- (void)onShareAudio:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    if (self.binding_streamUrl == nil || [self.binding_streamUrl length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:@"请输入streamUrl" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 0x110;
        [alertView show];
        
        return;
    }
    
    NSData *previewData = nil;
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    QQApiAudioObject* audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:utf8String ? : @""] title:self.binding_title ? : @"" description:self.binding_description ? : @"" previewImageData:previewData];
    
    utf8String = [self.binding_previewImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [audioObj setPreviewImageURL:[NSURL URLWithString: utf8String? : @""]];
    utf8String = [self.binding_streamUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [audioObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
    [audioObj setCflag:[self shareControlFlags]];
    _qqApiObject = audioObj;
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:audioObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];
}

-(void)onShareLocalFile:(QElement*)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    QQApiFileObject *fileObj = [QQApiFileObject objectWithData:fileData
                                               previewImageData:nil
                                                          title:self.binding_title ? : @""
                                                    description:self.binding_description ? : @""];
    
    if (self.binding_description != nil && ![self.binding_description isEqualToString:@""])
    {
        fileObj.fileName = self.binding_description;
    }
    else
    {
        fileObj.fileName = @"test.txt";
    }
    
    [fileObj setCflag:[self shareControlFlags]];
    _qqApiObject = fileObj;
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:fileObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];

}

- (void)onShareVideo:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];

    NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"video.jpg"];
    NSData* previewData = [NSData dataWithContentsOfFile:previewPath];
    if (self.binding_previewImage)
    {
        NSData *selectedImgData = UIImageJPEGRepresentation(self.binding_previewImage, 0.20);
        if (selectedImgData)
        {
            previewData = selectedImgData;
        }
    }
    
    NSString *utf8String = [self.binding_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                           title:self.binding_title ? : @""
                                                     description:self.binding_description ? : @""
                                                previewImageData:previewData];
    
    
    utf8String = [self.binding_streamUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [videoObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
    [videoObj setCflag:[self shareControlFlags]];
    _qqApiObject = videoObj;
    QQApiSendResultCode ret = [QQApiInterface sendReq:[self getReq:videoObj thisTypeEnableArk:YES arkJson:nil]];
    [self handleSendResult:ret];
}

- (void)onAddOpenFriend:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    QQApiAddFriendObject *object = [[QQApiAddFriendObject alloc] initWithOpenID:self.binding_openID];
    object.description = self.binding_description;
    object.subID = self.binding_subID;
    object.remark = self.binding_remark;
    object.shareDestType = [self getShareType];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

 //计算签名+绑定
- (void)onGenerateSignatureBind:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    if ([[sdkCall getinstance].oauth.openId length] == 0)
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"需要先登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
        return;
    }
    
    NSString * orgStr = [NSString stringWithFormat:@"%@_%@_%@_%@_%@",
                         [sdkCall getinstance].oauth.openId,
                         [sdkCall getinstance].oauth.appId,
                         self.binding_appkey,
                         self.binding_GroupID,
                         self.binding_GameSectionID];
    NSData * data = [orgStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString * hexStr = [data md5];
    
    NSString * displayname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    QQApiGameConsortiumBindingGroupObject *object = [[QQApiGameConsortiumBindingGroupObject alloc] initWithGameConsortium:hexStr
                                                                                                                  unionid:self.binding_GroupID
                                                                                                                   zoneID:self.binding_GameSectionID
                                                                                                           appDisplayName:displayname];
    object.shareDestType = [self getShareType];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
}

//绑定
- (void)onGameConsortiumBindingGroup:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    if ([[sdkCall getinstance].oauth.openId length] == 0) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"需要先登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
        return;
    }
    
    NSString * displayname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    QQApiGameConsortiumBindingGroupObject *object = [[QQApiGameConsortiumBindingGroupObject alloc] initWithGameConsortium:self.binding_ownerSignature
                                                                                                                  unionid:self.binding_GroupID
                                                                                                                   zoneID:self.binding_GameSectionID
                                                                                                           appDisplayName:displayname];
    object.shareDestType = [self getShareType];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)onJoinGroup:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    if (self.binding_GroupKey && [self.binding_GroupKey length] > 0)
    {
        //ret = [QQApi joinGroup:self.binding_GroupID key:self.binding_GroupKey];
        QQApiJoinGroupObject *object = [QQApiJoinGroupObject objectWithGroupInfo:self.binding_GroupID key:self.binding_GroupKey];
        object.shareDestType = [self getShareType];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
    }
}

- (NSInteger)GetRandomNumber:(NSInteger)start to:(NSInteger)end
{
    return (NSInteger)(start + (arc4random() % (end - start + 1)));
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"手Q API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前TIM版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TIM API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISHAREDESTUNKNOWN:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未指定分享到QQ或TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
        }
            break;
        default:
        {
            break;
        }
    }
}
#endif

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0xAA)
    {
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
        QQApiSendResultCode sent = 0;
        if (0 == buttonIndex)
        {
            sent = [QQApiInterface SendReqToQZone:req];
        }
        else if(1 == buttonIndex)
        {
            sent = [QQApiInterface sendReq:req];
        }
        [self handleSendResult:sent];
    }
}

@end
