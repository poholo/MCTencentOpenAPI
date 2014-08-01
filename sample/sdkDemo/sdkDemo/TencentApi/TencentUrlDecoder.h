//
//  TencentUrlDecoder.h
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-29.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TencentUrlDecoder : NSObject

+(TencentUrlDecoder*)decoderWithUrl:(NSURL*)url;

@property(nonatomic,copy) NSString* scheme;
@property(nonatomic,copy) NSString* host;
@property(nonatomic,copy) NSString* path;
@property(nonatomic,readonly) NSDictionary* queryItem;

@end
