//
//  TencentMessage.h
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-29.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kIphoneQQ,
    kIphoneQZONE,
    kThirdApp,
}
TecnentPlatformType;

typedef enum
{
    kTencentApiSuccess,
    kTencentApiPlatformUninstall,
    kTencentApiPlatformNotSupport,
    kTencentApiParamsError,
    kTencentApiFail,
}
TencentApiRetCode;

@class TencentApiReq;
@class TencentApiResp;

/**
 * \brief TencentApiInterface的回调
 *
 * TencentApiInterface的回调接口 v1.0版本只支持腾讯业务拉起第三方请求内容
 */

@protocol TencentApiInterfaceDelegate <NSObject>

/**
 * 请求获得内容 当前版本只支持第三方相应腾讯业务请求
 */
- (BOOL)onTencentReq:(TencentApiReq *)req;

/**
 * 响应请求答复 当前版本只支持腾讯业务相应第三方的请求答复
 */
- (BOOL)onTencentResp:(TencentApiResp *)resp;

@end

@interface TencentApiInterface : NSObject

/**
 * 发送答复返回腾讯业务
 * \param resp 答复内容
 */
+ (TencentApiRetCode)sendRespMessageToTencentApp:(TencentApiResp *)resp;

/**
 * 发送请求到腾讯业务（当前版本不支持）
 * \param req  请求内容
 */
+ (TencentApiRetCode)sendReqMessageToTencentApp:(TencentApiReq *)req;

/**
 * 发送请求到第三方APP(不支持第三方那个调用)
 * \param req 请求内容
 * \param appId 第三方APPID
 */
+ (TencentApiRetCode)sendReqMessaageToThirdApp:(TencentApiReq *)req appId:(NSString *)appID;

/**
 * 发送请求到第三方APP(不支持第三方那个调用)
 * \param resp 答复内容
 * \param appId 第三方APPID
 */
+ (TencentApiRetCode)sendRespMessaageToThirdApp:(TencentApiResp *)req appId:(NSString *)appID;

/**
 * 是否可以处理拉起协议
 * \param url
 * \delegate 指定的回调
 */
+ (BOOL)canOpenURL:(NSURL *)url delegate:(id<TencentApiInterfaceDelegate>)delegate;

/**
 * 处理应用拉起协议
 * \param url
 * \delegate 指定的回调
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<TencentApiInterfaceDelegate>)delegate;

/**
 * 获取指定的腾讯业务的安装链接
 * \param platform 指定的腾讯业务
 */
+ (NSString *)getTencentAppInstallUrl:(TecnentPlatformType)platform;

/**
 * 判断第三方应用是否安装
 * \param appId 第三方那个应用的appId
 */
+ (BOOL)thirdAppInstall:(NSString *)appId;
@end
