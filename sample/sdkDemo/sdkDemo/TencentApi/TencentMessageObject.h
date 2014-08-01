//
//  TencentMessageObject.h
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kTextLimit (1024)
#define kDataLimit (1024 * 1024 * 10)
#define kPreviewDataLimit (1024 * 1024)

@class TencentApiReq;
@class TencentApiResp;
/**
 * 必填的字符串类型参数
 */
typedef NSString *TCRequiredStr;

/**
 * 必填的UIImage类型参数
 */
typedef NSData *TCRequiredData;

/**
 * 必填的整型参数
 */
typedef NSInteger TCRequiredInt;

/**
 * 必填的NSArray型参数
 */
typedef NSArray *TCRequiredArray;

/**
 * 必填的NSDictionary型参数
 */
typedef NSDictionary *TCRequiredDictionary;

/**
 * 必填的TencentApiReq型参数
 */
typedef TencentApiReq *TCRequiredReq;


/**
 * 可选的字符串类型参数
 */
typedef NSString *TCOptionalStr;

/**
 * 可选的UIImage类型参数
 */
typedef NSData *TCOptionalData;

/**
 * 可选的整型参数
 */
typedef NSInteger TCOptionalInt;

/**
 * 可选的NSArray型参数
 */
typedef NSArray *TCOptionalArray;


/**
 * 可选的TencentApiReq型参数
 */
typedef TencentApiReq *TCOptionalReq;

typedef enum
{
    //TX APP请求内容填充（需要第三方开发者填充完成内容后需要主动调用sendRespMessageToTencentApp）
    ReqFromTencentAppQueryContent,
    //TX APP请求展现内容 (不用调用答复)
    ReqFromTencentAppShowContent,
    //第三方 APP 请求内容（暂时没用）
    ReqFromThirdAppQueryContent,
    //第三方 APP 请求展现内容（类似分享）
    ReqFromThirdAppShowContent,
}
TencentReqMessageType;

typedef enum
{
    RespFromTencentAppQueryContent,
    RespFromTencentAppShowContent,
    RespFromThirdAppQueryContent,
    RespFromThirdAppShowContent,
}
TencentRespMessageType;

typedef enum
{
    TencentTextObj,
    TencentImageObj,
    TencentAudioObj,
    TencentVideoObj,
    TencentImageAndVideoObj,
}
TencentObjVersion;

/** TencentApiReq用来向其他业务发送请求包 */
@interface TencentApiReq  : NSObject<NSCoding>

/** 根据序列号生成一个请求包 */
+ (TencentApiReq *)reqFromSeq:(NSInteger)apiSeq type:(TencentReqMessageType)type;

/** 请求类型 */
@property (readonly, assign)TCRequiredInt nMessageType;

/** 请求平台 */
@property (readonly, assign)NSInteger nPlatform;

/** 请求的SDK版本号 */
@property (readonly, assign)NSInteger nSdkVersion;

/** 请求序列号 */
@property (readonly, assign)TCRequiredInt nSeq;

/** 第三方的APPID */
@property (nonatomic, retain)TCRequiredStr sAppID;

/** 请求内容 TencentBaseMessageObj对象数组 */
@property (nonatomic, retain)TCOptionalArray arrMessage;

/** 请求的描述 可以用于告诉对方这个请求的特定场景 */
@property (nonatomic, retain)TCOptionalStr sDescription;

@end

/** TencentApiResp用来向其他业务发送答复包(需要考虑如果他发送的是一个展现消息的答复包怎么办，参考微信和手QSDK修改一下？) */
@interface TencentApiResp : NSObject<NSCoding>

/** 根据请求包生成一个答复包 */
+ (TencentApiResp *)respFromReq:(TencentApiReq *)req;

/** 返回码 */
@property (nonatomic, assign)TCOptionalInt  nRetCode;

/** 返回消息 */
@property (nonatomic, retain)TCOptionalStr  sRetMsg;

/** 答复对应的请求包*/
@property (nonatomic, retain)TCOptionalReq  objReq;

@end

/** TencentBaseMessageObj 应用之间传递消息的数据类型*/
@interface TencentBaseMessageObj : NSObject<NSCoding>

/** 消息类型 */
@property (nonatomic, assign)NSInteger nVersion;

/** 消息描述 */
@property (nonatomic, retain)NSString  *sName;

/** 消息的扩展信息 主要是可以用来进行一些请求消息体的描述 譬如图片要求的width height 文字的关键字什么的, 也可以不用填写*/
@property (nonatomic, retain)NSDictionary *dictExpandInfo;

/** 消息是否有效 */
- (BOOL)isVaild;

@end

#pragma mark TencentTextMessage
@interface TencentTextMessageObjV1 : TencentBaseMessageObj

/** 文本消息 文本长度不能超过1024个字*/
@property (nonatomic, retain)  NSString   *sText;

/**
 * 初始化文本消息
 * \param text 文本
 */
- (id)initWithText:(NSString *)text;

@end


#pragma mark TecentImageMessage

@interface TencentImageMessageObjV1 : TencentBaseMessageObj

/** 图片数据 图片不能大于10M */
@property (nonatomic, retain)  NSData *dataImage;

/** 缩略图的数据 图片不能大于1M */
@property (nonatomic, retain)  NSData *dataThumbImage;

/** 图片URL 不能超过1024 */
@property (nonatomic, retain)  NSString   *sUrl;

/** 图片的描述 不能超过1024 */
@property (nonatomic, retain)  NSString   *sDescription;

/** 图片的size */
@property (nonatomic, assign)  CGSize   szImage;

/**
 * 初始化图片消息
 * \param dataImage 图片类型
 */
- (id)initWithImageData:(NSData *)dataImage;

@end


#pragma mark TencentAudioMessage
@interface TencentAudioMessageObjV1 : TencentBaseMessageObj

/** 音频URL 不能超过1024 */
@property (nonatomic, retain)  NSString   *sUrl;

/** 音频的预览图 图片不能大于1M */
@property (nonatomic, retain)  NSData     *dataImagePreview;

/** 音频的预览图URL 不能超过1024 */
@property (nonatomic, retain)  NSString   *sImagePreviewUrl;

/** 音频的描述 不能超过1024 */
@property (nonatomic, retain)  NSString   *sDescription;

/**
 * 初始化图片消息
 * \param url 音频URL
 */
- (id)initWithAudioUrl:(NSString *)url;

@end


#pragma mark TencentVideoMessage

typedef enum
{
    AllVideo,
    LocalVideo,
    NetVideo,
}VideoSourceType;

@interface TencentVideoMessageV1 : TencentBaseMessageObj

/** 视频URL 不能超过1024*/
@property (nonatomic, retain)  NSString   *sUrl;

/** 视频来源 1,本地相册 2,网络视频 */
@property (readonly, assign)  NSInteger nType;

/** 视频的预览图 图片不能大于1M */
@property (nonatomic, retain)  NSData     *dataImagePreview;

/** 视频的预览图URL 不能超过1024 */
@property (nonatomic, retain)  NSString   *sImagePreviewUrl;

/** 视频的描述 不能超过1024 */
@property (nonatomic, retain)  NSString   *sDescription;

/**
 * 初始化图片消息
 * \param url 视频URL
 */
- (id)initWithVideoUrl:(NSString *)url type:(NSInteger)type;

@end

#pragma mark TencentImageMessageObj
/** 这是一个扩展的类 是一个图片视频类 图片视频可以任选一个内容填充 但是注意只能填一个 当有一种类型被填充后 另外一个种类型就无法填充了 */
@interface TencentImageAndVideoMessageObjV1 : TencentBaseMessageObj

/** 图片消息 */
@property (nonatomic, retain) TencentImageMessageObjV1 *objImageMessage;

/** 视频消息 */
@property (nonatomic, retain) TencentVideoMessageV1 *objVideoMessage;

/**
 * 初始化图片消息
 * \param dataImage 图片类型
 */
- (id)initWithMessage:(NSData *)dataImage videoUrl:(NSString *)url;

/** 设置图片 */
- (void)setDataImage:(NSData *)dataImage;

/** 设置视频URL */
- (void)setVideoUrl:(NSString *)videoUrl;
@end


