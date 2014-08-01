//
//  WeiyunTableViewController.m
//  sdkDemo
//
//  Created by qqconnect on 13-7-8.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "WeiyunTableViewController.h"
#import "sdkCall.h"
#import "cellInfo.h"

#import "TextAlertView.h"
#import "NSData+HexAdditions.h"

#import "FGalleryViewController.h"
#import "weiyunFileIdListViewController.h"


#import <TencentOpenAPI/WeiyunAPI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WeiyunTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TCAPIRequestDelegate, TCAPIRequestDownloadDelegate, TCAPIRequestUploadDelegate, UIAlertViewDelegate, weiyunFileIdListDelegate>
{
    FGalleryViewController  *_localGallery;
    UIImagePickerController *uploadPic_ipc;
    UIProgressView          *_progressView;
    
    NSString                *_recordKey;
    NSString                *_recordValue;
    NSString                *_inputStr;
    weiyunFileIdListViewController *_weiyunFileIdListViewController;
}

@property (nonatomic, retain)NSMutableArray *picFileId;
@property (nonatomic, retain)NSMutableArray *videoFileId;
@property (nonatomic, retain)NSMutableArray *audioFileId;
@property (nonatomic, retain)NSMutableArray *allRecord;
@property (nonatomic, retain)NSMutableArray *weiyunOperateArray;
@property (nonatomic, retain)NSMutableArray *arrCgiRequest;
@property (nonatomic, retain)NSArray    *arrWeiyunCell;
@property (nonatomic, retain)weiyunFileIdListViewController *weiyunFileIdListViewController;

@end

@implementation WeiyunTableViewController
@synthesize arrWeiyunCell = _arrWeiyunCell;
@synthesize picFileId = _picFileId;
@synthesize videoFileId = _videoFileId;
@synthesize audioFileId = _audioFileId;
@synthesize allRecord = _allRecord;
@synthesize arrCgiRequest = _arrCgiRequest;

- (void)dealloc
{
    __SUPER_DEALLOC;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
        NSMutableArray *cellWeiYunPhoto = [NSMutableArray arrayWithCapacity:5];
        [cellWeiYunPhoto addObject:[cellInfo info:@"上传照片" target:self  Sel:@selector(weiyunUpload:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunPhoto]]];
        [cellWeiYunPhoto addObject:[cellInfo info:@"下载照片" target:self  Sel:@selector(weiyunDownload:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunPhoto]]];
        [cellWeiYunPhoto addObject:[cellInfo info:@"获取照片列表" target:self  Sel:@selector(weiyunGetList:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunPhoto]]];
        [cellWeiYunPhoto addObject:[cellInfo info:@"删除照片" target:self  Sel:@selector(weiyunDelData:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunPhoto]]];
        [cellWeiYunPhoto addObject:[cellInfo info:@"获取照片缩略图下载地址" target:self  Sel:@selector(weiyunGetThumbPic:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunPhoto]]];
        [[super sectionName] addObject:@"照片"];
        [[super sectionRow] addObject:cellWeiYunPhoto];
        
        NSMutableArray *cellWeiYunMusic = [NSMutableArray arrayWithCapacity:4];
        [cellWeiYunMusic addObject:[cellInfo info:@"上传音乐" target:self  Sel:@selector(weiyunUpload:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunMusic]]];
        [cellWeiYunMusic addObject:[cellInfo info:@"下载音乐" target:self  Sel:@selector(weiyunDownload:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunMusic]]];
        [cellWeiYunMusic addObject:[cellInfo info:@"获取音乐列表" target:self  Sel:@selector(weiyunGetList:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunMusic]]];
        [cellWeiYunMusic addObject:[cellInfo info:@"删除音乐" target:self  Sel:@selector(weiyunDelData:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunMusic]]];
        [[super sectionName] addObject:@"音乐"];
        [[super sectionRow] addObject:cellWeiYunMusic];
        
        NSMutableArray *cellWeiYunVideo = [NSMutableArray arrayWithCapacity:4];
        [cellWeiYunVideo addObject:[cellInfo info:@"上传视频" target:self  Sel:@selector(weiyunUpload:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunVideo]]];
        [cellWeiYunVideo addObject:[cellInfo info:@"下载视频" target:self  Sel:@selector(weiyunDownload:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunVideo]]];
        [cellWeiYunVideo addObject:[cellInfo info:@"获取视频列表" target:self  Sel:@selector(weiyunGetList:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunVideo]]];
        [cellWeiYunVideo addObject:[cellInfo info:@"删除视频" target:self  Sel:@selector(weiyunDelData:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunVideo]]];
        [[super sectionName] addObject:@"视频"];
        [[super sectionRow] addObject:cellWeiYunVideo];
        
        NSMutableArray *cellWeiYunRecord = [NSMutableArray arrayWithCapacity:6];
        [cellWeiYunRecord addObject:[cellInfo info:@"查询记录" target:self  Sel:@selector(checkRecord:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunRecord]]];
        [cellWeiYunRecord addObject:[cellInfo info:@"获取记录" target:self  Sel:@selector(getRecord:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunRecord]]];
        [cellWeiYunRecord addObject:[cellInfo info:@"创建记录" target:self  Sel:@selector(createRecord:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunRecord]]];
        [cellWeiYunRecord addObject:[cellInfo info:@"修改记录" target:self  Sel:@selector(modifyRecord:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunRecord]]];
        [cellWeiYunRecord addObject:[cellInfo info:@"删除记录" target:self  Sel:@selector(delRecord:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunRecord]]];
        [cellWeiYunRecord addObject:[cellInfo info:@"获取所有记录列表" target:self  Sel:@selector(queryAllRecord:) viewController:nil userInfo:[NSNumber numberWithUnsignedInteger:kWeiyunRecord]]];
        [[super sectionName] addObject:@"记录"];
        [[super sectionRow] addObject:cellWeiYunRecord];
        
        self.arrCgiRequest = [NSMutableArray arrayWithCapacity:1];
        
        self.weiyunOperateArray = [NSMutableArray arrayWithCapacity:3];
        {
            NSArray *arrDownLoadClass = [NSArray arrayWithObjects:[WeiYun_download_photo_GET class],[WeiYun_download_video_GET class],[WeiYun_download_video_GET class], nil];
            NSArray *arrDelClass = [NSArray arrayWithObjects:[WeiYun_delete_photo_GET class], [WeiYun_delete_video_GET class], [WeiYun_delete_music_GET class],nil];
            NSArray *arrThumbClass = [NSArray arrayWithObject:[WeiYun_get_photo_thumb_GET class]];
            [_weiyunOperateArray addObject:arrDownLoadClass];
            [_weiyunOperateArray addObject:arrDelClass];
            [_weiyunOperateArray addObject:arrThumbClass];
        }
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isImagePic=false;
    
    //由于弹出框和界面是同一水平线，所以需要定义一个开关，防止用户返回后，程序继续进行下去。
    
    isStop=true;
    
    isGetList=false;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (![[self.navigationController viewControllers] containsObject:self]) {
        // We were removed from the navigation controller's view controller stack
        // thus, we can infer that the back button was pressed
        
        isStop=false;
        
        CFRunLoopStop(CFRunLoopGetCurrent());
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendCgiRequest:(TCAPIRequest *)request
{
    if(NO == [[[sdkCall getinstance]oauth] sendAPIRequest:request callback:self])
    {
        [sdkCall showInvalidTokenOrOpenIDMessage];
    }
    else
    {
        [_arrCgiRequest addObject:request];
    }
}

- (void)weiyunUpload:(NSNumber *)weiyunType
{
    WeiYun_upload_photo_GET *request = nil;
    NSData *data = nil;
    NSUInteger type = [weiyunType unsignedIntegerValue];
    switch (type)
    {
        case kWeiyunPhoto:
        {
            ipc = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                if (kWeiyunPhoto == type)
                {
                    isImagePic=true;
                    ipc.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
                }
                else if (kWeiyunVideo == type)
                {
                    ipc.mediaTypes = [NSArray arrayWithObjects:@"public.movie",nil];
                }
                
            }
            ipc.delegate = self;
            if (uploadPic_ipc)
            {
                __RELEASE(uploadPic_ipc);
                uploadPic_ipc = nil;
            }
            uploadPic_ipc = __RETAIN(ipc);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0)
            {
                [self presentViewController:ipc animated:YES completion:nil];
            }
            else
            {
                [self presentModalViewController:ipc animated:YES];
            }
            return;
        }
        case kWeiyunVideo:
        {
            NSString *videoPath = [NSString stringWithFormat:@"%@/testvideo.mov",[[NSBundle mainBundle] resourcePath]];
            data = [[NSData alloc] initWithContentsOfFile:videoPath];
            request = [[WeiYun_upload_video_GET alloc] init];
            [self sendWeiyunUploadRequest:request data:data fileSuffix:@"mov"];
        }
            break;
        case kWeiyunMusic:
        {
            NSString *audioPath = [NSString stringWithFormat:@"%@/testaudio.mp3", [[NSBundle mainBundle] resourcePath]];
            data = [[NSData alloc] initWithContentsOfFile:audioPath];
            request = [[WeiYun_upload_music_GET alloc] init];
            [self sendWeiyunUploadRequest:request data:data fileSuffix:@"mp3"];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)weiyunDownload:(NSNumber *)weiyunType
{
    if (_weiyunFileIdListViewController)
    {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [viewControllers removeObject:_weiyunFileIdListViewController];
        [self.navigationController setViewControllers:viewControllers];
        __RELEASE(_weiyunFileIdListViewController);
    }
    _weiyunFileIdListViewController = [[weiyunFileIdListViewController alloc] init];
    NSUInteger type = [weiyunType unsignedIntegerValue];
    switch (type)
    {
        case kWeiyunPhoto:
            [_weiyunFileIdListViewController setArrFileInfo:_picFileId];
            [_weiyunFileIdListViewController setContentType:kWeiyunListPic];
            break;
        case kWeiyunMusic:
            [_weiyunFileIdListViewController setArrFileInfo:_audioFileId];
            [_weiyunFileIdListViewController setContentType:kWeiyunListAudio];
            break;
        case kWeiyunVideo:
            [_weiyunFileIdListViewController setArrFileInfo:_videoFileId];
            [_weiyunFileIdListViewController setContentType:kWeiyunListVideo];
            break;
        default:
            break;
    }
    
    [_weiyunFileIdListViewController setOperateType:kWeiyunDownload];
    [_weiyunFileIdListViewController setDelegate:self];
    
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请先获取列表" message:@"是否现在获取列表？" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"算啦", nil];
    alertview.tag = [weiyunType unsignedIntegerValue];
    [alertview show];
    __RELEASE(alertview);
    
    [[self navigationController] pushViewController:_weiyunFileIdListViewController animated:YES];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   
    NSLog(@"dissmiss");
    if ([[alertView title] isEqualToString:@"请先获取列表"]&&buttonIndex==0)
    {
        [self weiyunGetList:[NSNumber numberWithInteger:alertView.tag]];
    }else{
        [self queryAllRecord:[NSNumber numberWithInteger:alertView.tag]];
    }
}

- (void)weiyunGetList:(NSNumber *)weiyunType
{
    NSUInteger type = [weiyunType unsignedIntegerValue];
    WeiYun_get_photo_list_GET *request = nil;
    switch (type)
    {
        case kWeiyunPhoto:
            request = [[WeiYun_get_photo_list_GET alloc] init];
            break;
        case kWeiyunMusic:
            request = [[WeiYun_get_music_list_GET alloc] init];
            break;
        case kWeiyunVideo:
            request = [[WeiYun_get_video_list_GET alloc] init];
            break;
        default:
            break;
    }
    
    request.param_number = @"100";
    request.param_offset = @"0";
    [self sendCgiRequest:request];
    isGetList=true;
}

- (void)weiyunDelData:(NSNumber *)weiyunType
{
    
    
    if (_weiyunFileIdListViewController)
    {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [viewControllers removeObject:_weiyunFileIdListViewController];
        [self.navigationController setViewControllers:viewControllers];
        __RELEASE(_weiyunFileIdListViewController);
    }
    
    _weiyunFileIdListViewController = [[weiyunFileIdListViewController alloc] init];
    NSUInteger type = [weiyunType unsignedIntegerValue];
    switch (type)
    {
        case kWeiyunPhoto:
            [_weiyunFileIdListViewController setArrFileInfo:_picFileId];
            [_weiyunFileIdListViewController setContentType:kWeiyunListPic];
            break;
        case kWeiyunMusic:
            [_weiyunFileIdListViewController setArrFileInfo:_audioFileId];
            [_weiyunFileIdListViewController setContentType:kWeiyunListAudio];
            break;
        case kWeiyunVideo:
            [_weiyunFileIdListViewController setArrFileInfo:_videoFileId];
            [_weiyunFileIdListViewController setContentType:kWeiyunListVideo];
            break;
        default:
            break;
    }
    
    [_weiyunFileIdListViewController setOperateType:kWeiyunDelete];
    [_weiyunFileIdListViewController setDelegate:self];
    
    
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请先获取列表" message:@"是否现在获取列表？" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"算啦", nil];
    alertview.tag = [weiyunType unsignedIntegerValue];
    [alertview show];
    __RELEASE(alertview);
    
    
    [[self navigationController] pushViewController:_weiyunFileIdListViewController animated:YES];
}

- (void)weiyunGetThumbPic:(NSNumber *)weiyunType
{
    if (_weiyunFileIdListViewController)
    {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [viewControllers removeObject:_weiyunFileIdListViewController];
        [self.navigationController setViewControllers:viewControllers];
        __RELEASE(_weiyunFileIdListViewController);
    }
    
    _weiyunFileIdListViewController = [[weiyunFileIdListViewController alloc] init];
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunPhoto == type)
    {
        [_weiyunFileIdListViewController setArrFileInfo:_picFileId];
        [_weiyunFileIdListViewController setOperateType:kWeiyunDownloadThumb];
        [_weiyunFileIdListViewController setDelegate:self];
        
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请先获取列表" message:@"是否现在获取列表？" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"算啦", nil];
        alertview.tag = [weiyunType unsignedIntegerValue];
        [alertview show];
        __RELEASE(alertview);
        
        
        [[self navigationController] pushViewController:_weiyunFileIdListViewController animated:YES];
    }
}

- (void)checkRecord:(NSNumber *)weiyunType
{
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunRecord == type)
    {
        
        [self inputRecordKey];
        
        if (nil == _recordKey)
        {
            return;
        }
        
        
        NSString *key = [[_recordKey dataUsingEncoding:NSUTF8StringEncoding] stringWithHexBytes2];
        WeiYun_check_record_GET *request = [[WeiYun_check_record_GET alloc] init];
        request.param_key = key;
        
        [self sendCgiRequest:request];
    }
}

- (void)getRecord:(NSNumber *)weiyunType
{
    if (_weiyunFileIdListViewController)
    {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [viewControllers removeObject:_weiyunFileIdListViewController];
        [self.navigationController setViewControllers:viewControllers];
        __RELEASE(_weiyunFileIdListViewController);
    }
    
    
    _weiyunFileIdListViewController = [[weiyunFileIdListViewController alloc] init];
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunRecord == type)
    {
        [_weiyunFileIdListViewController setArrFileInfo:_allRecord];
        [_weiyunFileIdListViewController setOperateType:kWeiyunGetRecord];
        [_weiyunFileIdListViewController setContentType:kWeiyunListRecord];
        [_weiyunFileIdListViewController setDelegate:self];
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请先获取记录列表" message:@"是否现在获取列表？" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"算啦", nil];
        alertview.tag = [weiyunType unsignedIntegerValue];
        [alertview show];
        __RELEASE(alertview);
        
        
        [[self navigationController] pushViewController:_weiyunFileIdListViewController animated:YES];
    }
}

- (void)createRecord:(NSNumber *)weiyunType
{
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunRecord == type)
    {
        
        [self inputRecordKey];
        [self inputRecordValue];
        
        if (nil == _recordKey
            || nil == _recordValue)
        {
            return;
        }
        
        
        
        NSString *key = [[_recordKey dataUsingEncoding:NSUTF8StringEncoding] stringWithHexBytes2];
        NSString *value = [[_recordValue dataUsingEncoding:NSUTF8StringEncoding] stringWithHexBytes2];
        WeiYun_create_record_POST *request = [[WeiYun_create_record_POST alloc] init];
        request.param_key = key;
        request.param_value = [value dataUsingEncoding:NSUTF8StringEncoding];
        [self sendCgiRequest:request];
    }
}

- (void)modifyRecord:(NSNumber *)weiyunType
{
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunRecord == type)
    {
        
        [self inputRecordKey];
        [self inputRecordValue];
        
        if (nil == _recordKey
            || nil == _recordValue)
        {
            return;
        }
        
        
        NSString *key = [[_recordKey dataUsingEncoding:NSUTF8StringEncoding] stringWithHexBytes2];
        NSString *value = [[_recordValue dataUsingEncoding:NSUTF8StringEncoding] stringWithHexBytes2];
        WeiYun_modify_record_POST *request = [[WeiYun_modify_record_POST alloc] init];
        request.param_key = key;
        request.param_value = [value dataUsingEncoding:NSUTF8StringEncoding];
        
        [self sendCgiRequest:request];
    }
}

- (void)delRecord:(NSNumber *)weiyunType
{
    if (_weiyunFileIdListViewController)
    {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [viewControllers removeObject:_weiyunFileIdListViewController];
        [self.navigationController setViewControllers:viewControllers];
        __RELEASE(_weiyunFileIdListViewController);
    }
    
    _weiyunFileIdListViewController = [[weiyunFileIdListViewController alloc] init];
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunRecord == type)
    {
        [_weiyunFileIdListViewController setArrFileInfo:_allRecord];
        [_weiyunFileIdListViewController setOperateType:kWeiyunDelRecord];
        [_weiyunFileIdListViewController setContentType:kWeiyunListRecord];
        [_weiyunFileIdListViewController setDelegate:self];
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请先获取记录列表" message:@"是否现在获取列表？" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"算啦", nil];
        alertview.tag = [weiyunType unsignedIntegerValue];
        [alertview show];
        __RELEASE(alertview);
        
        
        [[self navigationController] pushViewController:_weiyunFileIdListViewController animated:YES];
    }
}

- (void)queryAllRecord:(NSNumber *)weiyunType
{
    NSUInteger type = [weiyunType unsignedIntegerValue];
    if (kWeiyunRecord == type)
    {
        WeiYun_query_all_record_GET *request = [[WeiYun_query_all_record_GET alloc] init];
        [self sendCgiRequest:request];
    }
}

- (void)sendWeiyunUploadRequest:(WeiYun_upload_photo_GET *)request data:(NSData *)data fileSuffix:(NSString *)fileSuffix
{
    request.param_sha = [data digest];
    request.param_md5 = [data md5];
    
    [self inputStr:@"输入文件名"];
    
    if(isStop){
        
        if(0 == [_inputStr length])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH_mm_ss"];
            NSString *name = [dateFormatter stringFromDate:[NSDate date]];
            request.param_name = [NSString stringWithFormat:@"%@.%@",name, fileSuffix];
            __RELEASE(dateFormatter);
        }
        else
        {
            request.param_name = [NSString stringWithFormat:@"%@.%@",_inputStr, fileSuffix];
        }
        
        request.param_size = [NSString stringWithFormat:@"%u", [data length]];
        request.param_upload_type = @"control";
        request.paramUploadData = data;
        
        [self sendCgiRequest:request];
    }
    
}


- (void)inputStr:(NSString *)title
{
    
    /*
     TextAlertView *alert = [[TextAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectZero];
     textInput.borderStyle = UITextBorderStyleRoundedRect;
     [textInput setPlaceholder:@"输入"];
     [textInput setTag:0xAA];
     [alert addSubview:textInput];
     [alert setDelegate:self];
     [alert setTag:0xDD];
     [alert show];
     __RELEASE(textInput);
     CFRunLoopRun();
     __RELEASE(alert);
     
     */
    YIPopupTextView* inputStr = [[YIPopupTextView alloc] initWithPlaceHolder:title maxCount:300];
    inputStr.delegate = self;
    
    if(isImagePic)
    {
        [inputStr showInView:ipc.view];
        isImagePic=false;
        
    }else{
        [inputStr showInView:self.view];
    }
    
    
    input_type=@"_inputStr";
    CFRunLoopRun();
}

- (void)inputRecordKey
{
    
    /*
     TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"输入key值" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectZero];
     textInput.borderStyle = UITextBorderStyleRoundedRect;
     [textInput setPlaceholder:@"key值"];
     [textInput setTag:0xAA];
     [alert addSubview:textInput];
     [alert setDelegate:self];
     [alert setTag:0xBB];
     [alert show];
     __RELEASE(textInput);
     CFRunLoopRun();
     __RELEASE(alert);
     
     */
    
    YIPopupTextView* inputRecordKey = [[YIPopupTextView alloc] initWithPlaceHolder:@"输入key值" maxCount:300];
    inputRecordKey.delegate = self;
    [inputRecordKey showInView:self.view];
    
    input_type=@"_recordKey";
    CFRunLoopRun();
}

- (void)inputRecordValue
{
    
    /*
     TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"输入value值" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectZero];
     textInput.borderStyle = UITextBorderStyleRoundedRect;
     [textInput setPlaceholder:@"value值"];
     [textInput setTag:0xAA];
     [alert addSubview:textInput];
     [alert setDelegate:self];
     [alert setTag:0xCC];
     [alert show];
     __RELEASE(textInput);
     CFRunLoopRun();
     __RELEASE(alert);
     
     */
    
    YIPopupTextView* inputRecordKey = [[YIPopupTextView alloc] initWithPlaceHolder:@"输入value值" maxCount:300];
    inputRecordKey.delegate = self;
    [inputRecordKey showInView:self.view];
    
    input_type=@"_recordValue";
    CFRunLoopRun();
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(picker == uploadPic_ipc)
    {
        WeiYun_upload_photo_GET *request = [[WeiYun_upload_photo_GET alloc] init];
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImagePNGRepresentation(image);
        if(nil == imageData)
        {
            imageData = UIImageJPEGRepresentation(image, 1.0f);
            [self sendWeiyunUploadRequest:request data:imageData fileSuffix:@"jpg"];
        }
        else
        {
            [self sendWeiyunUploadRequest:request data:imageData fileSuffix:@"png"];
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)getFileInfoList:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    NSDictionary *data = [[response jsonResponse] objectForKey:@"data"];
    NSArray *content = [data objectForKey:@"content"];
    NSUInteger fileTotal = [[data objectForKey:@"file_total"] unsignedIntegerValue];
    if (0 == fileTotal)
    {
        content = nil;
    }
    
    if ([request isMemberOfClass:[WeiYun_get_photo_list_GET class]])
    {
        if (_picFileId)
        {
            __RELEASE(_picFileId);
        }
        
        _picFileId = [content copy];
    }
    else if([request isMemberOfClass:[WeiYun_get_video_list_GET class]])
    {
        if (_videoFileId)
        {
            __RELEASE(_videoFileId);
        }
        
        _videoFileId = [content copy];
        
    }
    else if([request isMemberOfClass:[WeiYun_get_music_list_GET class]])
    {
        if (_audioFileId)
        {
            __RELEASE(_audioFileId);
        }
        
        _audioFileId = [content copy];
    }
    
    [_weiyunFileIdListViewController setArrFileInfo:content];
    [[_weiyunFileIdListViewController tableView] reloadData];
}

- (BOOL)getPicFromResponse:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if (NO == [request isMemberOfClass:[WeiYun_download_photo_GET class]]
        && NO == [request isMemberOfClass:[WeiYun_get_photo_thumb_GET class]])
    {
        return NO;
    }
    
    NSData *data = [[response jsonResponse] objectForKey:@"data"];
    UIImage *image = [UIImage imageWithData:data];
    if (nil != image)
    {
        UIImage *thumbImage = [UIImage imageWithCGImage:[image CGImage] scale:0.4f orientation:UIImageOrientationUp];
        if (nil != image)
        {
            [[[sdkCall getinstance] photos] addObject:image];
        }
        
        if (nil != thumbImage)
        {
            [[[sdkCall getinstance] thumbPhotos] addObject:thumbImage];
        }
        
        if (_localGallery)
        {
            [_localGallery dismissModalViewControllerAnimated:NO];
            __RELEASE(_localGallery);
        }
        
        _localGallery = [[FGalleryViewController alloc] initWithPhotoSource:[sdkCall getinstance]];
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
        return YES;
    }
    
    return NO;
}

- (BOOL)saveFileData:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if (NO == [request isKindOfClass:[WeiYun_download_photo_GET class]])
    {
        return NO;
    }
    
    NSData *data = [[response jsonResponse] objectForKey:@"data"];
    if (nil == data)
    {
        return NO;
    }
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *dirName = nil;
    
    if ([request isMemberOfClass:[WeiYun_download_photo_GET class]])
    {
        dirName = @"photo";
    }
    else if ([request isMemberOfClass:[WeiYun_download_video_GET class]])
    {
        dirName = @"video";
    }
    else if ([request isMemberOfClass:[WeiYun_download_music_GET class]])
    {
        dirName = @"music";
    }
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(), dirName];
    
    BOOL isDir = YES;
    if (NO == [mgr fileExistsAtPath:dirPath isDirectory:&isDir])
    {
        if (NO == [mgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return NO;
        }
    }
    
    NSString *fileName = [request paramUserData];
    if (nil == fileName)
    {
        fileName = [(WeiYun_download_photo_GET *)request param_file_id];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath, fileName];
    
    if ([request isMemberOfClass:[WeiYun_download_photo_GET class]])
    {
        [self getPicFromResponse:request didResponse:response];
    }
    return [data writeToFile:filePath atomically:YES];
}


- (NSString *)responseDataProcess:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    
    if([request isKindOfClass:[WeiYun_get_photo_list_GET class]])
    {
        [self getFileInfoList:request didResponse:response];
    }
    
    if ([request isKindOfClass:[WeiYun_query_all_record_GET class]])
    {
        if (_allRecord)
        {
            __RELEASE(_allRecord);
        }
        
        NSDictionary *data = [[response jsonResponse] objectForKey:@"data"];
        NSUInteger count = [[data objectForKey:@"count"] unsignedIntegerValue];
        NSArray *keys = [data objectForKey:@"keys"];
        if (0 != count)
        {
            _allRecord = [[NSMutableArray alloc] initWithCapacity:[keys count]];
            for (id key in keys)
            {
                NSData *data = [NSData dataFromHex16String:[key objectForKey:@"key"]];
                NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [_allRecord addObject:@{@"key":resStr}];
            }
            
            [_weiyunFileIdListViewController setArrFileInfo:_allRecord];
            [[_weiyunFileIdListViewController tableView] reloadData];
            
        }
    }
    
    if ([request isKindOfClass:[WeiYun_download_photo_GET class]])
    {
        if (NO == [self saveFileData:request didResponse:response])
        {
            return @"本地保存文件失败，重新下载。";
        }
        else
        {
            return @"本地文件保存成功。";
        }
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    if ([request isKindOfClass:[WeiYun_check_record_GET class]])
    {
        [array addObject:@"key"];
    }
    
    NSMutableString *str=[NSMutableString stringWithFormat:@""];
    for (id key in response.jsonResponse)
    {
        
        if ([array containsObject:key])
        {
            NSData *data = [NSData dataFromHex16String:[response.jsonResponse objectForKey:key]];
            NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,resStr]];
        }
        else if([key isKindOfClass:[NSString class]]
                && [key isEqualToString:@"data"]
                &&([request isKindOfClass:[WeiYun_query_all_record_GET class]]
                   ||[request isKindOfClass:[WeiYun_get_record_GET class]]))
        {
            NSDictionary *jsonData = [response.jsonResponse objectForKey:key];
            if([request isKindOfClass:[WeiYun_query_all_record_GET class]])
            {
                
                NSArray *keys = [jsonData objectForKey:@"keys"];
                NSUInteger count = [[[response jsonResponse] objectForKey:@"count"] unsignedIntegerValue];
                if (0 != count)
                {
                    for(id keyValue in keys)
                    {
                        NSData *data = [NSData dataFromHex16String:[keyValue objectForKey:@"key"]];
                        NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        [str appendString: [NSString stringWithFormat:@"key = %@\n", resStr]];
                    }
                }
            }
            else if([request isKindOfClass:[WeiYun_get_record_GET class]])
            {
                NSData *data = [NSData dataFromHex16String:[jsonData objectForKey:@"value"]];
                NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [str appendString: [NSString stringWithFormat:@"value = %@\n", resStr]];
            }
        }
        else
        {
            NSString *result = [response.jsonResponse objectForKey:key];
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,result]];
        }
    }
    
    
    
    return str;
}

- (NSString *)responseErrMsgProcess:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if ([request isKindOfClass:[WeiYun_BaseRequest class]])
    {
        NSNumber *retCode = [response.jsonResponse objectForKey:@"ret"];
        NSString *errMsg = nil;
        switch ([retCode unsignedIntegerValue])
        {
            case 200001:
                errMsg = @"输入参数无效";
                break;
            case 201020:
                errMsg = @"文件不存在";
                break;
            case 201022:
                errMsg = @"文件已经存在";
                break;
            case 201029:
                errMsg = @"单个文件大小超限";
                break;
            case 201051:
                errMsg = @"当前目录下已经存在同名文件";
                break;
            case 230032:
                errMsg = @"key长度无效";
                break;
            case 230033:
                errMsg = @"data长度无效";
                break;
            case 230034:
                errMsg = @"key不存在";
                break;
            default:
                errMsg = [NSString stringWithFormat:@"%@", retCode];
                break;
        }
        return errMsg;
    }
    
    NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
    return errMsg;
}

#pragma mark weiyunFileIdListDelegate
- (void)weiyunFileIdSelectedFileId:(weiyunFileIdListViewController *)viewController fileInfo:(NSDictionary *)fileInfo
{
    if ([viewController contentType] == kWeiyunListRecord)
    {
        WeiYun_check_record_GET *request = nil;
        if ([viewController operateType] == kWeiyunGetRecord)
        {
            request = [[WeiYun_get_record_GET alloc] init];
            
        }
        else if([viewController operateType] == kWeiyunDelRecord)
        {
            request = [[WeiYun_delete_record_GET alloc] init];
        }
        
        NSString *key = [[[fileInfo objectForKey:@"key"] dataUsingEncoding:NSUTF8StringEncoding] stringWithHexBytes2];
        request.param_key = key;
        [self sendCgiRequest:request];
    }
    else
    {
        NSString *file_id = [fileInfo objectForKey:@"file_id"];
        NSString *file_name = [fileInfo objectForKey:@"file_name"];
        
        NSArray *weiyunClass = [_weiyunOperateArray objectAtIndex:[viewController operateType]];
        Class class = [weiyunClass objectAtIndex:[viewController contentType]];
        
        WeiYun_BaseRequest *request = [[class alloc] init];
        [request performSelector:@selector(setParam_file_id:) withObject:file_id];
        [request setParamUserData:file_name];
        if ([request isMemberOfClass:[WeiYun_get_photo_thumb_GET class]])
        {
            [request performSelector:@selector(setParam_thumb:) withObject:@"64*64"];
        }
        [self sendCgiRequest:request];
        
        if([request isKindOfClass:[WeiYun_download_photo_GET class]]
           || [request isKindOfClass:[WeiYun_get_photo_thumb_GET class]])
        {
            [_progressView setProgress:0];
            [_progressView setHidden:NO];
            
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}


#pragma mark cgiRequestDelegate
- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        NSString *str = [self responseDataProcess:request didResponse:response];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
        if ([request isKindOfClass:[WeiYun_upload_photo_GET class]])
        {
            WeiYun_get_photo_list_GET *request = nil;
            if ([request isMemberOfClass:[WeiYun_upload_photo_GET class]])
            {
                request = [[WeiYun_get_photo_list_GET alloc] init];
            }
            else if([request isMemberOfClass:[WeiYun_upload_music_GET class]])
            {
                request = [[WeiYun_get_music_list_GET alloc] init];
            }
            else if([request isMemberOfClass:[WeiYun_upload_video_GET class]])
            {
                request = [[WeiYun_get_video_list_GET alloc] init];
            }
            
            request.param_offset = @"0";
            request.param_number = @"200";
        }
    }
    else
    {
        NSString *errMsg = [self responseErrMsgProcess:request didResponse:response];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    }
    if (nil != request)
    {
        [_arrCgiRequest removeObject:request];
    }
}

- (void)cgiRequest:(TCAPIRequest *)request didSendBodyData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    CGFloat progress = (totalBytesWritten / totalBytesExpectedToWrite);
    [_progressView setProgress:progress animated:YES];
}

#pragma mark TCAPIRequestUploadDelegate
- (BOOL)cgiUploadRequest:(TCAPIRequest *)uploadRequest shouldBeginUploadingStorageRequest:(NSURLRequest *)storageRequest
{
    return YES;
}



#pragma mark TCAPIRequestDownloadDelegate
- (BOOL)cgiDownloadRequest:(TCAPIRequest *)downloadRequest shouldBeginDownloadingStorageRequest:(NSURLRequest *)storageRequest
{
    return YES;
}


#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text
{
    
    NSLog(@"will dismiss");
    //self.textView.text = text;
    
    if ([input_type isEqualToString:@"_inputStr"]) {
        _inputStr=text;
        input_type=nil;
        
    }else if([input_type isEqualToString:@"_recordValue"]){
        
        _recordValue=text;
        input_type=nil;
        
    }else if([input_type isEqualToString:@"_recordKey"]){
        _recordKey=text;
        input_type=nil;
    }
    
    
    CFRunLoopStop(CFRunLoopGetCurrent());
    
}


- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text
{
    NSLog(@"did dismiss");
    
    
}


@end
