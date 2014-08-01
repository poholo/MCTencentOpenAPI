//
//  TencentMessageObject.m
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "TencentMessageObject.h"
#import "TencentApiInterface.h"

@implementation TencentApiReq

@synthesize nMessageType = _nMessageType;
@synthesize nPlatform = _nPlatform;
@synthesize nSdkVersion = _nSdkVersion;
@synthesize nSeq = _nSeq;
@synthesize arrMessage = _arrMessage;
@synthesize sAppID = _sAppID;
@synthesize sDescription = _sDescription;

+ (TencentApiReq *)reqFromSeq:(NSInteger)apiSeq type:(TencentReqMessageType)type
{
#if __TencentApiSdk_For_TencentApp_
    TencentApiReq *req = [[TencentApiReq alloc] initWithData:apiSeq type:type];
    return __AUTORELEASE(req);
#else
   //第三方当前不支持请求包
    return nil;
#endif
}

- (id)initWithData:(NSInteger)seq type:(TencentReqMessageType)type
{
#if __TencentApiSdk_For_TencentApp_
    //这里面后续可以修改成根据scheme判断是QZONE平台 还是手Q平台 或者其他平台
    if (self = [super init])
    {
        _nSeq = seq;
        _nMessageType = type;
        _nPlatform = kIphoneQZONE;
        _nSdkVersion = 1U;
    }
    return self;
#else
    return nil;
#endif
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _nMessageType = [aDecoder decodeIntegerForKey:@"nMessageType"];
        _nPlatform = [aDecoder decodeIntegerForKey:@"nPlatform"];
        _nSdkVersion = [aDecoder decodeIntegerForKey:@"nSdkVersion"];
        _nSeq = [aDecoder decodeIntegerForKey:@"nSeq"];
        _arrMessage = __RETAIN([aDecoder decodeObjectForKey:@"arrMessage"]);
        _sAppID = __RETAIN([aDecoder decodeObjectForKey:@"sAppID"]);
        _sDescription = __RETAIN([aDecoder decodeObjectForKey:@"description"]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_nMessageType forKey:@"nMessageType"];
    [aCoder encodeInteger:_nPlatform forKey:@"nPlatform"];
    [aCoder encodeInteger:_nSdkVersion forKey:@"nSdkVersion"];
    [aCoder encodeInteger:_nSeq forKey:@"nSeq"];
    [aCoder encodeObject:_arrMessage forKey:@"arrMessage"];
    [aCoder encodeObject:_sAppID forKey:@"sAppID"];
    [aCoder encodeObject:_sDescription forKey:@"description"];
}

- (void)dealloc
{
    __RELEASE(_sAppID);
    __RELEASE(_arrMessage);
    __SUPER_DEALLOC;
}

@end

@implementation TencentApiResp

@synthesize nRetCode = _nRetCode;
@synthesize sRetMsg = _sRetMsg;
@synthesize objReq = _objReq;

+ (TencentApiResp *)respFromReq:(TencentApiReq *)req
{
    TencentApiResp *resp = [[TencentApiResp alloc] init];
    [resp setNRetCode:0];
    [resp setObjReq:req];
    return __AUTORELEASE(resp);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _nRetCode = [aDecoder decodeIntegerForKey:@"nRetCode"];
        _sRetMsg = __RETAIN([aDecoder decodeObjectForKey:@"sRetMsg"]);
        _objReq = __RETAIN([aDecoder decodeObjectForKey:@"objReq"]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_nRetCode forKey:@"nRetCode"];
    [aCoder encodeObject:_sRetMsg forKey:@"sRetMsg"];
    [aCoder encodeObject:_objReq forKey:@"objReq"];
}

- (void)dealloc
{
    __RELEASE(_objReq);
    __RELEASE(_sRetMsg);
    __SUPER_DEALLOC;
}


@end

@interface TencentBaseMessageObj()
//@property (nonatomic, retain)NSMutableArray *arrPro;
@end

@implementation TencentBaseMessageObj
@synthesize nVersion = _nVersion;
@synthesize sName = _sName;
@synthesize dictExpandInfo = _dictExpandInfo;
//@synthesize arrPro = _arrPro;

- (id)initWithVersion:(NSUInteger)version
{
    if (self = [super init])
    {
        _nVersion = version;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _nVersion = [aDecoder decodeIntegerForKey:@"nVersion"];
        _sName = __RETAIN([aDecoder decodeObjectForKey:@"sName"]);
        _dictExpandInfo = __RETAIN([aDecoder decodeObjectForKey:@"dictExpandInfo"]);
//        _arrPro = [[NSMutableArray alloc] initWithObjects:@"nVersion", @"sName", @"dictExpandInfo",nil];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_nVersion forKey:@"nVersion"];
    [aCoder encodeObject:_sName forKey:@"sName"];
    [aCoder encodeObject:_dictExpandInfo forKey:@"dictExpandInfo"];
    //[aCoder encodeObject:_arrPro forKey:@"arrPro"];
}

//- (void)addPro:(NSString *)pro
//{
//    if (_arrPro)
//    {
//        [_arrPro addObject:pro];
//    }
//}

- (BOOL)isVaild
{
    if ([_sName length] > kTextLimit)
    {
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    _nVersion = 0;
    __RELEASE(_sName);
    __RELEASE(_dictExpandInfo);
    //__RELEASE(_arrPro);
    __SUPER_DEALLOC;
}

@end

@implementation TencentTextMessageObjV1

@synthesize sText = _sText;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _sText = __RETAIN([aDecoder decodeObjectForKey:@"sText"]);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_sText forKey:@"sText"];
}

- (id)initWithText:(NSString *)text
{
    if (self = [self initWithVersion:TencentTextObj])
    {
        //[self addPro:@"sText"];
        _sText = __RETAIN(_sText);
    }
    
    return self;
}

- (BOOL)isValid
{
    if ([super isVaild])
    {
        return ([_sText length] > kTextLimit)?(NO):(YES);
    }
    return NO;
}

-(void)dealloc
{
    __RELEASE(_sText)
    __SUPER_DEALLOC;
}

@end

@implementation TencentImageMessageObjV1

@synthesize dataImage = _dataImage;
@synthesize sUrl = _sUrl;
@synthesize dataThumbImage = _dataThumbImage;
@synthesize sDescription = _sDescription;
@synthesize szImage = _szImage;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _dataImage = __RETAIN([aDecoder decodeObjectForKey:@"dataImage"]);
        _sUrl = __RETAIN([aDecoder decodeObjectForKey:@"sUrl"]);
        _dataThumbImage = __RETAIN([aDecoder decodeObjectForKey:@"dataThumbImage"]);
        _sDescription = __RETAIN([aDecoder decodeObjectForKey:@"description"]);
        CGFloat width = [aDecoder decodeFloatForKey:@"imageWidth"];
        CGFloat height = [aDecoder decodeFloatForKey:@"imageHeight"];
        _szImage.width = width;
        _szImage.height = height;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_dataImage forKey:@"dataImage"];
    [aCoder encodeObject:_sUrl forKey:@"sUrl"];
    [aCoder encodeObject:_dataThumbImage forKey:@"dataThumbImage"];
    [aCoder encodeObject:_sDescription forKey:@"description"];
    [aCoder encodeFloat:_szImage.width forKey:@"imageWidth"];
    [aCoder encodeFloat:_szImage.height forKey:@"imageHeight"];
}

- (id)initWithImageData:(NSData *)dataImage
{
    if (self = [super initWithVersion:TencentImageObj])
    {
        //[self addPro:@"dataImage"];
        _dataImage = __RETAIN(dataImage);
    }
    
    return self;
}

- (BOOL)isVaild
{
    if ([super isVaild])
    {
        if ((kDataLimit < [_dataImage length])
            || (kTextLimit < [_sUrl length])
            || (kPreviewDataLimit < [_dataThumbImage length])
            || (kTextLimit < [_sDescription length]))
        {
            return NO;
        }
        return YES;
    }
    
    return NO;
}

- (void)dealloc
{
    __RELEASE(_dataImage);
    __RELEASE(_sUrl);
    __RELEASE(_dataThumbImage);
    __RELEASE(_sDescription);
    __SUPER_DEALLOC;
}

@end


@implementation TencentAudioMessageObjV1
@synthesize sUrl = _sUrl;
@synthesize sImagePreviewUrl = _sImagePreviewUrl;
@synthesize dataImagePreview = _dataImagePreview;
@synthesize sDescription = _sDescription;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _sUrl = __RETAIN([aDecoder decodeObjectForKey:@"sUrl"]);
        _sImagePreviewUrl = __RETAIN([aDecoder decodeObjectForKey:@"sImagePreviewUrl"]);
        _dataImagePreview = __RETAIN([aDecoder decodeObjectForKey:@"dataImagePreview"]);
        _sDescription = __RETAIN([aDecoder decodeObjectForKey:@"description"]);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_sUrl forKey:@"sUrl"];
    [aCoder encodeObject:_sImagePreviewUrl forKey:@"sImagePreviewUrl"];
    [aCoder encodeObject:_dataImagePreview forKey:@"dataImagePreview"];
    [aCoder encodeObject:_sDescription forKey:@"description"];
}


- (id)initWithAudioUrl:(NSString *)url
{
    if (self = [super initWithVersion:TencentAudioObj])
    {
//        [self addPro:@"sUrl"];
//        [self addPro:@"sImagePreviewUrl"];
//        [self addPro:@"dataImagePreview"];
        _sUrl = __RETAIN(url);
    }
    
    return self;
}

- (BOOL)isVaild
{
    if ([super isVaild])
    {
        if ((kTextLimit < [_sUrl length])
            || (kTextLimit < [_sImagePreviewUrl length])
            || (kPreviewDataLimit < [_dataImagePreview length])
            || (kTextLimit < [_sDescription length]))
        {
            return NO;
        };
        
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    __RELEASE(_sUrl);
    __RELEASE(_sImagePreviewUrl);
    __RELEASE(_dataImagePreview);
    __RELEASE(_sDescription);
    __SUPER_DEALLOC;
}

@end

@implementation TencentVideoMessageV1
@synthesize sUrl = _sUrl;
@synthesize nType = _nType;
@synthesize sImagePreviewUrl = _sImagePreviewUrl;
@synthesize dataImagePreview = _dataImagePreview;
@synthesize sDescription = _sDescription;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _sUrl = __RETAIN([aDecoder decodeObjectForKey:@"sUrl"]);
        _nType = [aDecoder decodeIntegerForKey:@"nType"];
        _sImagePreviewUrl = __RETAIN([aDecoder decodeObjectForKey:@"sImagePreviewUrl"]);
        _dataImagePreview = __RETAIN([aDecoder decodeObjectForKey:@"dataImagePreview"]);
        _sDescription = __RETAIN([aDecoder decodeObjectForKey:@"description"]);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_sUrl forKey:@"sUrl"];
    [aCoder encodeInteger:_nType forKey:@"nType"];
    [aCoder encodeObject:_sImagePreviewUrl forKey:@"sImagePreviewUrl"];
    [aCoder encodeObject:_dataImagePreview forKey:@"dataImagePreview"];
    [aCoder encodeObject:_sDescription forKey:@"description"];
}


- (id)initWithVideoUrl:(NSString *)url type:(NSInteger)type
{
    if (self = [super initWithVersion:TencentVideoObj])
    {
        //        [self addPro:@"sUrl"];
        //        [self addPro:@"sImagePreviewUrl"];
        //        [self addPro:@"dataImagePreview"];
        _sUrl = __RETAIN(url);
        _nType = type;
    }
    
    return self;
}

- (BOOL)isVaild
{
    if ([super isVaild])
    {
        if ((kTextLimit < [_sUrl length])
            || (kTextLimit < [_sImagePreviewUrl length])
            || (kPreviewDataLimit < [_dataImagePreview length])
            || (kTextLimit < [_sDescription length]))
        {
            return NO;
        };
        
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    _nType = 0;
    __RELEASE(_sDescription);
    __RELEASE(_sUrl);
    __RELEASE(_sImagePreviewUrl);
    __RELEASE(_dataImagePreview);
    __SUPER_DEALLOC;
}

@end

@implementation TencentImageAndVideoMessageObjV1
@synthesize objImageMessage = _objImageMessage;
@synthesize objVideoMessage = _objVideoMessage;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _objImageMessage = __RETAIN([aDecoder decodeObjectForKey:@"imageMessage"]);
        _objVideoMessage = __RETAIN([aDecoder decodeObjectForKey:@"videoMessage"]);
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_objImageMessage forKey:@"imageMessage"];
    [aCoder encodeObject:_objVideoMessage forKey:@"videoMessage"];
}


- (id)initWithMessage:(NSData *)dataImage videoUrl:(NSString *)url
{
    if (self = [super initWithVersion:TencentImageAndVideoObj])
    {
        _objImageMessage = [[TencentImageMessageObjV1 alloc] initWithImageData:nil];
        _objVideoMessage = [[TencentVideoMessageV1 alloc] initWithVideoUrl:nil type:0];
        
        UIImage *image = [UIImage imageWithData:dataImage];
        if (nil != image)
        {
            [_objImageMessage setDataImage:dataImage];
        }
        else
        {
            [_objVideoMessage setSUrl:url];
        }
    
        
    }
    return self;
}

- (void)setObjImageMessage:(TencentImageMessageObjV1 *)objImageMessage
{
    __RELEASE(_objImageMessage);
    _objImageMessage = __RETAIN(objImageMessage);
    NSData *dataImage = [_objImageMessage dataImage];
    UIImage *image = [UIImage imageWithData:dataImage];
    if (nil != image)
    {
        [_objVideoMessage setSUrl:nil];
    }
}

- (void)setObjVideoMessage:(TencentVideoMessageV1 *)objVideoMessage
{
    __RELEASE(_objVideoMessage);
    _objVideoMessage = __RETAIN(objVideoMessage);
    NSString *url = [objVideoMessage sUrl];
    if (0 != [url length])
    {
        [_objImageMessage setDataImage:nil];
    }
}

- (void)setDataImage:(NSData *)dataImage
{
    if (nil == _objImageMessage)
    {
        _objImageMessage = [[TencentImageMessageObjV1 alloc] initWithImageData:nil];
    }
    
    [_objImageMessage setDataImage:dataImage];
    UIImage *image = [UIImage imageWithData:dataImage];
    if (nil != image)
    {
        [_objVideoMessage setSUrl:nil];
    }
}

- (void)setVideoUrl:(NSString *)videoUrl
{
    if (nil == _objVideoMessage)
    {
        _objVideoMessage = [[TencentVideoMessageV1 alloc] initWithVideoUrl:nil type:AllVideo];
    }
    
    [_objImageMessage setSUrl:videoUrl];
    if (0 != [videoUrl length])
    {
        [_objImageMessage setDataImage:nil];
    }
}

- (BOOL)isVaild
{
    if ([super isVaild])
    {
        if (NO == [_objImageMessage isVaild]
            || NO == [_objVideoMessage isVaild])
        {
            return NO;
        };
        
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    __RELEASE(_objImageMessage);
    __RELEASE(_objVideoMessage);
    __SUPER_DEALLOC;
}

@end




