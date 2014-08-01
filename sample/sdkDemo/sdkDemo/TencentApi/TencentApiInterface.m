//
//  TencentMessage.m
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-29.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "TencentApiInterface.h"
#import "TencentMessageParse.h"
#import "TencentMessagePack.h"
#import "TencentMessageObject.h"
#import "TencentApiDef.h"
#import "TencentUrlDecoder.h"
#import "TencentApiUtil.h"

@implementation TencentApiInterface

+ (TencentApiRetCode)sendRespMessageToTencentApp:(TencentApiResp *)resp
{
    if (nil == resp)
    {
        return -1;
    }
    
    if (kIphoneQQ == [[resp objReq] nPlatform])
    {
        //说白了 现在还没有QQ
    }
    
    if (kIphoneQZONE == [[resp objReq] nPlatform])
    {
        if (NO == [self installIphoneQZone])
        {
            return kTencentApiPlatformUninstall;
        }
        
        if (NO == [self iphoneQZoneSupportApi])
        {
            return kTencentApiPlatformNotSupport;
        }
        
        if (NO == [TencentMessagePack messageVaild:resp])
        {
            return kTencentApiParamsError;
        }
        
        NSURL *url = [TencentMessagePack packTencentRespMessage:resp];
        if (NO == [[UIApplication sharedApplication] openURL:url])
        {
            return kTencentApiFail;
        }
        
        return kTencentApiSuccess;
    }
    
    return 0;
}

+ (TencentApiRetCode)sendReqMessageToTencentApp:(TencentApiReq *)req
{
    //第三方那个主动调用腾讯业务提供内容 
    return kTencentApiPlatformNotSupport;
}

+ (TencentApiRetCode)sendRespMessaageToThirdApp:(TencentApiResp *)req appId:(NSString *)appID
{
    return kTencentApiPlatformNotSupport;
}

+ (TencentApiRetCode)sendReqMessaageToThirdApp:(TencentApiReq *)req appId:(NSString *)appID
{
#if __TencentApiSdk_For_TencentApp_
    [req setSAppID:appID];
    if (NO == [TencentMessagePack messageVaild:req])
    {
        return kTencentApiParamsError;
    }
    
    NSURL *url = [TencentMessagePack packTencentReqMessage:req];
    if (NO == [[UIApplication sharedApplication] openURL:url])
    {
        return kTencentApiFail;
    }
    return kTencentApiSuccess;

#endif
    return kTencentApiPlatformNotSupport;
}

+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<TencentApiInterfaceDelegate>)delegate
{
    NSObject *obj = [TencentMessageParse parseTencentMessage:url];
    if (nil == obj)
    {
        return NO;
    }
    
    if ([obj isKindOfClass:[TencentApiReq class]])
    {
        TencentApiReq *req = (TencentApiReq *)obj;
        if ([delegate respondsToSelector:@selector(onTencentReq:)])
        {
            if (NO == [delegate onTencentReq:req])
            {
                TencentApiResp *resp = [TencentApiResp respFromReq:req];
                [resp setNRetCode:-1];
                [TencentApiInterface sendRespMessageToTencentApp:resp];
            };
        }
    }
    
    else if([obj isKindOfClass:[TencentApiResp class]])
    {
#if __TencentApiSdk_For_TencentApp_
        TencentApiResp *resp = (TencentApiResp *)obj;
        if ([delegate respondsToSelector:@selector(onTencentResp:)])
        {
            [delegate onTencentResp:resp];
        }
#else
        //不支持
        return NO;
#endif
    }
    
    return YES;
}


+ (BOOL)canOpenURL:(NSURL *)url delegate:(id<TencentApiInterfaceDelegate>)delegate
{
    TencentUrlDecoder *decoder = [TencentUrlDecoder decoderWithUrl:url];
    NSString *scheme = [decoder scheme];
    NSString *host = [decoder host];
    NSString *path = [decoder path];
    
    
    NSArray *appScheme = [TencentApiUtil scheme:kTencentApiSchemeIdenfiter];
    
    if ([appScheme containsObject:scheme])
    {
        //pangzhang 如果这发现不同 要继续取之前版本的scheme对比 v1版本没有之前版本 所以不取
        if ([host isEqualToString:kTencentApiReqFromTencentApp])
        {
            if ([path isEqualToString:kTencentReqContent]
                || [path isEqualToString:kTencentRespContent])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)getTencentAppInstallUrl:(TecnentPlatformType)platform
{
    return nil;
}

+ (BOOL)installIphoneQZone
{
    NSString *scheme = [NSString stringWithFormat:@"%@://", kQZoneScheme];
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]];
}

+ (BOOL)iphoneQZoneSupportApi
{
    NSString *scheme = [NSString stringWithFormat:@"%@://", kQZoneSupportSDK];
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]];
}


+ (BOOL)thirdAppInstall:(NSString *)appId
{
    NSString *scheme = [[NSString alloc] initWithFormat:@"tencent%@.content://", appId];
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]?(YES):(NO);
}

@end
