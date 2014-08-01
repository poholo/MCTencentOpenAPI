//
//  TencentMessagePack.h
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TencentMessageObject.h"
@interface TencentMessagePack : NSObject

+ (NSURL *)packTencentReqMessage:(TencentApiReq *)req;
+ (NSURL *)packTencentRespMessage:(TencentApiResp *)resp;
+ (BOOL)messageVaild:(NSObject *)obj;


@end
