//
//  TencentApiUtil.h
//  sdkDemo
//
//  Created by xiaolongzhang on 13-5-30.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TencentApiUtil : NSObject

+ (NSArray *)scheme:(NSString *)urlName;
+ (NSString *)md5:(NSString *)value;
+ (NSString *)GetURLWithParam:(NSString *)baseUrl withParam:(NSDictionary *)data;

@end
