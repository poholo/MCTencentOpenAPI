//
//  ShareToQZoneViewController.m
//  sdkDemo
//
//  Created by zilinzhou on 15/11/25.
//  Copyright © 2015年 xiaolongzhang. All rights reserved.
//

#import "ShareToQZoneViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "QBImagePickerController.h"

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

@interface ShareToQZoneViewController () <QBImagePickerControllerDelegate>
{
    ShareToQZoneType _type;
    UITextField *_textFiled;
    NSURL *_videoAssetForQZone;
    NSArray *_imageAssetsForQZone;
    
    UITextField *_sceneTextField;
    UITextField *_callbackTextField;
}
@end

@implementation ShareToQZoneViewController

- (id)initWithShareType:(ShareToQZoneType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = @"";
    switch (_type) {
        case kShareToQZoneType_Text:
            self.navigationItem.title = @"分享纯文本到空间";
            break;
        case kShareToQZoneType_Images:
            self.navigationItem.title = @"分享图片到空间";
            title = @"选择图片";
            break;
        case kShareToQZoneType_Video:
            self.navigationItem.title = @"分享视频到空间";
            title = @"选择视频";
            break;
            
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickConfirm:)];
    
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, self.view.bounds.size.width - 30, 80)];
    _textFiled.layer.cornerRadius = 2;
    _textFiled.textAlignment = NSTextAlignmentCenter;
    _textFiled.text = @"试一下输入文本分享到空间吧~~~~";
    _textFiled.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textFiled.layer.borderWidth = 0.5;
    _textFiled.layer.borderColor = RGBColorC(0xdddddd).CGColor;
    [self.view addSubview:_textFiled];
    
    UILabel *sceneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textFiled.frame.origin.x, _textFiled.frame.origin.y + _textFiled.frame.size.height + 30, _textFiled.frame.size.width, 30)];
    sceneLabel.text = @"hulian_extra_scene";
    [self.view addSubview:sceneLabel];
    
    _sceneTextField = [[UITextField alloc] initWithFrame:CGRectMake(sceneLabel.frame.origin.x, sceneLabel.frame.origin.y + sceneLabel.frame.size.height + 15, sceneLabel.frame.size.width, 30)];
    _sceneTextField.layer.cornerRadius = 2;
    _sceneTextField.textAlignment = NSTextAlignmentCenter;
    _sceneTextField.text = @"hulian_extra_scene";
    _sceneTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _sceneTextField.layer.borderWidth = 0.5;
    _sceneTextField.layer.borderColor = RGBColorC(0xdddddd).CGColor;
    [self.view addSubview:_sceneTextField];
    
    UILabel *callbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sceneTextField.frame.origin.x, _sceneTextField.frame.origin.y + _sceneTextField.frame.size.height + 30, _sceneTextField.frame.size.width, 30)];
    callbackLabel.text = @"hulian_call_back";
    [self.view addSubview:callbackLabel];
    
    _callbackTextField = [[UITextField alloc] initWithFrame:CGRectMake(callbackLabel.frame.origin.x, callbackLabel.frame.origin.y + callbackLabel.frame.size.height + 15, callbackLabel.frame.size.width, 30)];
    _callbackTextField.layer.cornerRadius = 2;
    _callbackTextField.textAlignment = NSTextAlignmentCenter;
    _callbackTextField.text = @"hulian_call_back";
    _callbackTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _callbackTextField.layer.borderWidth = 0.5;
    _callbackTextField.layer.borderColor = RGBColorC(0xdddddd).CGColor;
    [self.view addSubview:_callbackTextField];
    
    if (_type == kShareToQZoneType_Text) {
        return;
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_callbackTextField.frame.origin.x, _callbackTextField.frame.origin.y + _callbackTextField.frame.size.height + 30, _callbackTextField.frame.size.width, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGBColorC(0x000000) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 2;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBColorC(0xdddddd).CGColor;
    [self.view addSubview:btn];
    
}

- (void)onClickBtn:(id)sender
{
    QBImagePickerController *imgPicker = [[QBImagePickerController alloc] init];
    imgPicker.delegate = self;
    switch (_type) {
        case kShareToQZoneType_Images:
        {
            imgPicker.allowsMultipleSelection = YES;
            imgPicker.filterType = QBImagePickerControllerFilterTypePhotos;
        }
            break;
        case kShareToQZoneType_Video:
        {
            imgPicker.allowsMultipleSelection = NO;
            imgPicker.filterType = QBImagePickerControllerFilterTypeVideos;
        }
            break;
            
        default:
            break;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imgPicker];
    [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
    _videoAssetForQZone = url;
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        [photoArray addObject:data];
    }
    _imageAssetsForQZone = [photoArray copy];
    if (_imageAssetsForQZone.count > 20) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"注意" message:@"选择多于20张图片，最后能传过去的也只有20张哟~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (ShareDestType)getShareType
{
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdkSwitchFlag"] boolValue];
    return flag? ShareDestTypeTIM :ShareDestTypeQQ;
}

- (void)onClickConfirm:(id)sender
{
    NSString *text = _textFiled.text;
    
    //            const string HULIAN_EXTRA_SCENE = "hulian_extra_scene";
    //            const string HULIAN_CALL_BACK = "hulian_call_back";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *sceneStr = _sceneTextField.text;
    NSString *checkSceneStr = [sceneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (checkSceneStr.length > 0) {
        [dict setObject:sceneStr forKey:@"hulian_extra_scene"];
    }
    
    NSString *callBackStr = _callbackTextField.text;
    NSString *checkCallBackStr = [callBackStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (checkCallBackStr.length > 0) {
        [dict setObject:callBackStr forKey:@"hulian_call_back"];
    }
    
    if (dict.count == 0) {
        dict = nil;
    }
    
    switch (_type) {
        case kShareToQZoneType_Text:
        {
            if (_textFiled.text.length == 0) {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先输入文字" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                return;
            }
            QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:nil title:text extMap:dict];
            obj.shareDestType = [self getShareType];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        }
            break;
        case kShareToQZoneType_Images:
        {
            if (_imageAssetsForQZone.count == 0) {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先选择图片" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                return;
            }
            
            QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:_imageAssetsForQZone title:text extMap:dict];
            img.shareDestType = [self  getShareType];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        }
            break;
        case kShareToQZoneType_Video:
        {
            if (!_videoAssetForQZone) {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先选择视频" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                return;
            }
            
            QQApiVideoForQZoneObject *video = [QQApiVideoForQZoneObject objectWithAssetURL:[_videoAssetForQZone absoluteString] title:text extMap:dict];
            video.shareDestType = [self getShareType];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:video];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        }
            break;
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:NO];
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
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
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
        default:
        {
            break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
