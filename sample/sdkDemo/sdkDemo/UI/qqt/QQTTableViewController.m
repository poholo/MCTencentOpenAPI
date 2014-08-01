//
//  QQTTableViewController.m
//  sdkDemo
//
//  Created by qqconnect on 13-7-8.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "QQTTableViewController.h"
#import "cellInfo.h"
#import "sdkCall.h"
#import "TextAlertView.h"
#import <TencentOpenAPI/WeiBoAPI.h>


@interface QQTTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TCAPIRequestDelegate>
{
}

@property (nonatomic, retain)UIImagePickerController *addPictIpc;
@end

@implementation QQTTableViewController
@synthesize addPictIpc = _addPictIpc;

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
        NSMutableArray *celltqq = [NSMutableArray array];
        [celltqq addObject:[cellInfo info:@"微博好友提示" target:self Sel:@selector(clickMatchNickTips) viewController:nil]];
        [celltqq addObject:[cellInfo info:@"微博最近联系人" target:self Sel:@selector(clickGetIntimateFriends) viewController:nil]];
        [celltqq addObject:[cellInfo info:@"发送带有图片的微博" target:self Sel:@selector(addPicTencentWeibo) viewController:nil]];
        [[self sectionName] addObject:@"腾讯微博"];
        [[self sectionRow] addObject:celltqq];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kGetIntimateFriendsResponse object:[sdkCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kMatchNickTipsResponse object:[sdkCall getinstance]];
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //由于弹出框和界面是同一水平线，所以需要定义一个开关，防止用户返回后，程序继续进行下去。
    
    isStop=true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickMatchNickTips
{
    
    /*
    TextAlertView *alertMatch = [[TextAlertView alloc] initWithTitle:@"请输入匹配字符串" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alertMatch.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInputMatch = [[UITextField alloc] initWithFrame:CGRectZero];
    textInputMatch.borderStyle = UITextBorderStyleRoundedRect;
    [textInputMatch setPlaceholder:@"要匹配的字符串"];
    textInputMatch.tag = 0xAA;
    [alertMatch addSubview:textInputMatch];
    
    [alertMatch show];
    CFRunLoopRun();
    
    TextAlertView *alertReqnum = [[TextAlertView alloc] initWithTitle:@"请输入请求个数" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alertReqnum.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInputReqnum = [[UITextField alloc] initWithFrame:CGRectZero];
    textInputReqnum.borderStyle = UITextBorderStyleRoundedRect;
    [textInputReqnum setPlaceholder:@"请求个数（1-10）"];
    textInputReqnum.tag = 0xAA;
    [alertReqnum addSubview:textInputReqnum];
    
    [alertReqnum show];
    CFRunLoopRun();
    
     */
    
    YIPopupTextView* alertMatch = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入匹配字符串" maxCount:300];
    alertMatch.delegate = self;
    [alertMatch showInView:self.view];
    
    type=@"Marth";
    CFRunLoopRun();
    
    
    YIPopupTextView* alertReqnum = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入请求个数,请求个数(1-10)" maxCount:300];
    alertReqnum.delegate = self;
    [alertReqnum showInView:self.view];
    
    type=@"Reqnum";
    CFRunLoopRun();
    
        
    if (isStop) {
        
        TCMatchNickTipsDic *params = [TCMatchNickTipsDic dictionary];
        
        [params setParamMatch:_Marth];
        [params setParamReqnum:_Reqnum];
        
        if (![[[sdkCall getinstance] oauth] matchNickTips:params])
        {
            [sdkCall showInvalidTokenOrOpenIDMessage];
        }
        

    }

    
}



- (void)clickGetIntimateFriends
{
    
    
    /*
    TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"请输入请求个数" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectZero];
    textInput.borderStyle = UITextBorderStyleRoundedRect;
    [textInput setPlaceholder:@"请求个数（1-20）"];
    textInput.tag = 0xAA;
    [alert addSubview:textInput];
    
    [alert show];
    CFRunLoopRun();
     
    */
    
    YIPopupTextView* alertReqnum = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入请求个数,请求个数(1-10)" maxCount:300];
    alertReqnum.delegate = self;
    [alertReqnum showInView:self.view];
    
    type=@"Reqnum";
    CFRunLoopRun();
    
    
    if (isStop) {
        
        TCGetIntimateFriendsDic *params = [TCGetIntimateFriendsDic dictionary];
        
        [params setParamReqnum:_Reqnum];
        
        if (![[[sdkCall getinstance] oauth] getIntimateFriends:params])
        {
            [sdkCall showInvalidTokenOrOpenIDMessage];
        }
        
    }
    
    
}

- (void)addPicTencentWeibo
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    }
    
    ipc.delegate = self;
    if ([self addPictIpc])
    {
        self.addPictIpc = nil;
    }
    self.addPictIpc = ipc;
    
    [self presentModalViewController:[self addPictIpc] animated:YES];
}

- (void)inputStr:(NSString *)title
{
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *Title = [alertView title];
    NSString *ButtonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    UITextField *textMatch;
    UITextField *textReqnum;
    
    if (0xAA == [alertView tag])
    {
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
    }
    else if(0xDD == [alertView tag])
    {
        _inputStr = [[(UITextField *)[alertView viewWithTag:0xAA] text] copy];
    }
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (_addPictIpc == picker)
    {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];

        WeiBo_add_pic_t_POST *request = [[WeiBo_add_pic_t_POST alloc] init];
        request.param_pic = image;
        
        
        YIPopupTextView* inputStr = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入图片名称" maxCount:5];
        inputStr.delegate = self;
        [inputStr showInView:picker.view];
        
        type=@"inputStr";
        CFRunLoopRun();
        
        if(nil == _inputStr)
        {
            return;
        }
        request.param_content = _inputStr;
        request.param_compatibleflag = @"0x2|0x4|0x8|0x20";
        request.param_latitude = @"39.909407";
        request.param_longitude = @"116.397521";

        if(NO == [[[sdkCall getinstance]oauth] sendAPIRequest:request callback:self])
        {
            [sdkCall showInvalidTokenOrOpenIDMessage];
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
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

#pragma mark -

#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text
{
    
    NSLog(@"will dismiss");
    //self.textView.text = text;
    
    if ([type isEqualToString:@"Marth"]) {
        _Marth=text;
        type=nil;
    }else if([type isEqualToString:@"Reqnum"]){
        _Reqnum=text;
        type=nil;
    }else if([type isEqualToString:@"inputStr"]){
        
        _inputStr=text;
        type=nil;
    }
        
        
    CFRunLoopStop(CFRunLoopGetCurrent());
    
}


- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text
{
    NSLog(@"did dismiss");


}

 
@end
