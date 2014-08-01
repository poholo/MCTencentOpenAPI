//
//  TencentMessageParse.h
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TencentMessageObject.h"

@interface TencentMessageParse : NSObject<NSKeyedUnarchiverDelegate>

+ (NSObject *)parseTencentMessage:(NSURL *)url;

@end
