//
//  TencentReqMgr.m
//  sdkDemo
//
//  Created by xiaolongzhang on 13-6-1.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#import "TencentReqMgr.h"
#import "TencentMessageObject.h"

static TencentReqMgr *instance = nil;

@interface TencentReqMgr()

@property (nonatomic, retain)NSMutableDictionary *arrReq;

@end

@implementation TencentReqMgr


+ (TencentReqMgr *)instance
{
    if (nil == instance)
    {
        instance = [[TencentReqMgr alloc] init];
        [instance setArrReq:[NSMutableDictionary dictionaryWithCapacity:1]];
    }
    
    return  instance;
}


- (void)rmReq:(TencentApiReq *)req
{
    NSNumber* seq = nil;
    for(NSNumber* key in [[self arrReq] allKeys])
    {
        if ([key isKindOfClass:[NSNumber class]])
        {
            TencentApiReq *objReq = [[self arrReq] objectForKey:key];
            if ([objReq isKindOfClass:[TencentApiReq class]])
            {
                if([req nSeq] == [objReq nSeq]
                   &&[req nPlatform] == [objReq nPlatform])
                {
                    seq = key;
                    break;
                }
            }
        }
    }
    
    if (0 != [seq integerValue])
    {
        [[self arrReq] removeObjectForKey:seq];
    }
}


- (void)rmSeq:(NSInteger)seq
{
    [[self arrReq] removeObjectForKey:[NSNumber numberWithInteger:seq]];
}

- (NSInteger)addReq:(TencentApiReq *)req
{
    return [self seqFromReq:req];
}

- (NSInteger)seqFromReq:(TencentApiReq *)req
{
    if (nil == req)
    {
        return -1;
    }
    
    NSNumber* key = nil;
    for(key in [[self arrReq] allKeys])
    {
        if ([key isKindOfClass:[NSNumber class]])
        {
            TencentApiReq *objReq = [[self arrReq] objectForKey:key];
            if ([objReq isKindOfClass:[TencentApiReq class]])
            {
                if([req nSeq] == [objReq nSeq]
                   &&[req nPlatform] == [objReq nPlatform])
                {
                    //这样可以认为是同一个平台的同一个请求
                    return [key unsignedIntegerValue];
                }
            }
        }
    }
    
    NSInteger seq = [key integerValue] + 1;
    [[self arrReq] setObject:req forKey:[NSNumber numberWithUnsignedInteger:seq]];
    
    return seq;
}

- (TencentApiReq *)reqFromSeq:(NSInteger)seq
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        return req;
    }
    return nil;
}

- (TencentApiResp *)respFromSeq:(NSInteger)seq
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        return [TencentApiResp respFromReq:req];
    }
    
    return nil;
}

- (NSArray *)tencentMessageObjFromSeq:(NSInteger)seq
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        return [req arrMessage];
    }
    
    return nil;
}

- (NSArray *)tencentMessageObjFromMessageClass:(NSInteger)seq messageClass:(Class)messageClass
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        NSArray *array = [req arrMessage];
        NSMutableArray *messageArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (id obj in array)
        {
            if ([obj isKindOfClass:messageClass])
            {
                [messageArray addObject:obj];
            }
        }
        
        return __AUTORELEASE(messageArray);
    }
    
    return nil;
}

- (NSArray *)tencentMessageObjFromMessageType:(NSInteger)seq messageType:(NSUInteger)messageType
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    Class messageClass = nil;
    if (TencentImageObj == messageType)
    {
        messageClass = [TencentImageMessageObjV1 class];
    }
    else if(TencentAudioObj == messageType)
    {
        messageClass = [TencentAudioMessageObjV1 class];
    }
    else
    {
        return nil;
    }
    
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        NSArray *array = [req arrMessage];
        NSMutableArray *messageArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (id obj in array)
        {
            if ([obj isKindOfClass:messageClass])
            {
                [messageArray addObject:obj];
            }
        }
        
        return __AUTORELEASE(messageArray);
    }
    
    return nil;
}

- (BOOL)isContainMessageClss:(NSInteger)seq messageClass:(Class)messageClass
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        NSArray *array = [req arrMessage];
        for (id obj in array)
        {
            if ([obj isKindOfClass:messageClass])
            {
                return YES;
                break;
            }
        }
    }
    
    return NO;
}
- (BOOL)isContainMessageType:(NSInteger)seq messageType:(NSUInteger)messageType
{
    TencentApiReq *req = (TencentApiReq *)[[self arrReq] objectForKey:[NSNumber numberWithInteger:seq]];
    Class messageClass = nil;
    if (TencentImageObj == messageType)
    {
        messageClass = [TencentImageMessageObjV1 class];
    }
    else if(TencentAudioObj == messageType)
    {
        messageClass = [TencentAudioMessageObjV1 class];
    }
    else
    {
        return NO;
    }
    
    if(YES == [req isKindOfClass:[TencentApiReq class]])
    {
        NSArray *array = [req arrMessage];
        for (id obj in array)
        {
            if ([obj isKindOfClass:messageClass])
            {
                return YES;
                break;
            }
        }
    }
    
    return NO;
}
@end
