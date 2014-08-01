//
//  TencentMessagePack.m
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "TencentMessagePack.h"
#import "TencentApiDef.h"
#import "TencentMessageObject.h"
#import "TencentApiUtil.h"
#import "TencentApiInterface.h"
#import <objc/runtime.h>


#define kPastBoardDetail @"kTencentApiPastBoard"

@implementation TencentMessagePack

+ (NSURL *)packTencentReqMessage:(TencentApiReq *)req
{
    NSData *data = [self dataWithTencentReqMessage:req];
    UIPasteboard *pb = [UIPasteboard pasteboardWithUniqueName];
    
    //pangzhang 再想一下这里是不是要做这么复杂 其实双方约定好一个数值就可以
    NSString *CFBundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    if (nil == CFBundleIdentifier)
    {
        NSLog(@"tencentApi error: CFBundleIdentifier每填写");
        //pangzhang 取不到名字的情况下取当前scheme的名字
        CFBundleIdentifier = kPastBoardDetail;
    }
    
    NSString *pastboardType = [TencentApiUtil md5:CFBundleIdentifier];
    [pb setData:data forPasteboardType:pastboardType];
    
#if __TencentApiSdk_For_TencentApp_
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[pb name], kPastboardName, pastboardType, kPastboardType,nil];
    NSString *scheme = [[NSString alloc] initWithFormat:@"tencent%@.content", [req sAppID]];
    if (nil == scheme)
    {
        NSLog(@"tencentApi error: appId为空");
        return nil;
    }
    
    NSString *baseUrl = [[NSString alloc] initWithFormat:@"%@://%@/%@", scheme, kTencentApiReqFromTencentApp, kTencentReqContent];
    NSString *url = [TencentApiUtil GetURLWithParam:baseUrl withParam:params];
    __RELEASE(baseUrl);
    __RELEASE(scheme);
    return [NSURL URLWithString:url];
#else
    return nil;
    //要根据参数跳到指定的平台
    
#endif
}

+ (NSURL *)packTencentRespMessage:(TencentApiResp *)resp
{
    NSData *data = [self dataWithTencentReqMessage:resp];
    UIPasteboard *pb = [UIPasteboard pasteboardWithUniqueName];
    
    //pangzhang 再想一下这里是不是要做这么复杂 其实双方约定好一个数值就可以
    NSString *CFBundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    if (nil == CFBundleIdentifier)
    {
        NSLog(@"tencentApi error: CFBundleIdentifier没填写");
        //pangzhang 取不到名字的情况下取当前scheme的名字
        CFBundleIdentifier = kPastBoardDetail;
    }
    
    NSString *pastboardType = [TencentApiUtil md5:CFBundleIdentifier];
    [pb setData:data forPasteboardType:pastboardType];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[pb name], kPastboardName, pastboardType, kPastboardType,nil];
    
#if __TencentApiSdk_For_TencentApp_
    NSString *scheme = [[NSString alloc] initWithFormat:@"tencent%@.content", [[resp objReq] sAppID]];
    if (nil == scheme)
    {
        NSLog(@"tencentApi error: appId为空");
        return nil;
    }
    
    NSString *baseUrl = [[NSString alloc] initWithFormat:@"%@://%@/%@", scheme, kTencentApiReqFromTencentApp, kTencentRespContent];
    NSString *url = [TencentApiUtil GetURLWithParam:baseUrl withParam:params];
    
    __RELEASE(scheme);
    __RELEASE(baseUrl);
    
    return [NSURL URLWithString:url];
#else
    
    if (kIphoneQQ == [[resp objReq] nPlatform])
    {
        //说白了 现在还没有QQ
    }
    
    if (kIphoneQZONE == [[resp objReq] nPlatform])
    {
        NSString *scheme = kQZoneSupportSDK;
        if (nil == scheme)
        {
            NSLog(@"tencentApi error: appId为空");
            return nil;
        }
        
        NSString *baseUrl = [[NSString alloc] initWithFormat:@"%@://%@/%@", scheme, kTencentApiReqFromTencentApp, kTencentRespContent];
        NSString *url = [TencentApiUtil GetURLWithParam:baseUrl withParam:params];
        
        __RELEASE(baseUrl);
        return [NSURL URLWithString:url];
    }
    
    //要根据参数跳到指定的平台
#endif
    return nil;
}

+ (NSData *)dataWithTencentReqMessage:(NSObject *)obj
{
    if ([obj isKindOfClass:[TencentApiReq class]]
        || [obj isKindOfClass:[TencentApiResp class]])
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:obj forKey:@"object"];
        [archiver finishEncoding];
        __RELEASE(archiver);
        return __AUTORELEASE(data);
    }
    return nil;
}

+ (BOOL)messageVaild:(NSObject *)obj
{
    NSArray *array = nil;
    if ([obj isKindOfClass:[TencentApiResp class]])
    {
        array = [[(TencentApiResp *)obj objReq] arrMessage];
    }
    else if([obj isKindOfClass:[TencentApiReq class]])
    {
        array = [(TencentApiReq *)obj arrMessage];
    }
    
    for (id obj in array)
    {
        if ([obj isMemberOfClass:[TencentBaseMessageObj class]])
        {
            if (NO == [(TencentBaseMessageObj *)obj isVaild])
            {
                return NO;
            };
        }
    }
    
    return YES;
    
}

@end
