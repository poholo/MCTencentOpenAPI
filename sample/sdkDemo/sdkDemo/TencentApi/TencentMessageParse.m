//
//  TencentMessageParse.m
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "TencentMessageParse.h"
#import "TencentUrlDecoder.h"
#import "TencentApiDef.h"
#import "TencentApiUtil.h"

@implementation TencentMessageParse


+ (NSObject *)parseTencentMessage:(NSURL *)url
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
            if ([path isEqualToString:kTencentReqContent])
            {
                return [self getReqFromUrl:decoder];
            }
            
            if ([path isEqualToString:kTencentRespContent])
            {
                return [self getRespFromUrl:decoder];
            }
        }
    }
    
    return nil;
}



//pangzhang 头疼 后面把这里整合下 
+ (TencentApiResp *)getRespFromUrl:(TencentUrlDecoder *)url
{
    NSString *pastboardName = [[url queryItem] objectForKey:kPastboardName];
    NSString *pastboardType = [[url queryItem] objectForKey:kPastboardType];
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:pastboardName create:NO];
    NSData *data = [pb dataForPasteboardType:pastboardType];
    
    TencentApiResp *resp = nil;
    @try
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        TencentMessageParse *parse = [[TencentMessageParse alloc] init];
        [unarchiver setDelegate:parse];
        resp = [unarchiver decodeObjectForKey:@"object"];
        __RELEASE(parse);
        __RELEASE(unarchiver);
        return resp;
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception 序列化对象的时候出错");
    }
    
    return nil;
}


+ (TencentApiReq *)getReqFromUrl:(TencentUrlDecoder *)url
{
    
    NSString *pastboardName = [[url queryItem] objectForKey:kPastboardName];
    NSString *pastboardType = [[url queryItem] objectForKey:kPastboardType];
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:pastboardName create:NO];
    NSData *data = [pb dataForPasteboardType:pastboardType];
    TencentApiReq *req = nil;
    @try
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        TencentMessageParse *parse = [[TencentMessageParse alloc] init];
        [unarchiver setDelegate:parse];
        req = [unarchiver decodeObjectForKey:@"object"];
        __RELEASE(parse);
        __RELEASE(unarchiver);
        return req;
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception 序列化对象的时候出错");
    }
    
    return nil;
}

- (Class)unarchiver:(NSKeyedUnarchiver *)unarchiver cannotDecodeObjectOfClassName:(NSString *)name originalClasses:(NSArray *)classNames
{
    //pangzhang 发现无法初始化的对象我们调用父类 如果他的父类可以创建出对象 就可以用父类进行反序列化
    for (id className in classNames)
    {
        if ([className isKindOfClass:[NSString class]])
        {
            Class class = NSClassFromString(className);
            if (nil != class)
            {
                return class;
            }
        }
    }
    return nil;
}

@end
