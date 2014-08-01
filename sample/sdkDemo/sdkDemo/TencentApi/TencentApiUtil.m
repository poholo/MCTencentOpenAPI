//
//  TencentApiUtil.m
//  sdkDemo
//
//  Created by xiaolongzhang on 13-5-30.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#import "TencentApiUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TencentApiUtil

+ (NSString *)md5:(NSString *)value
{
    if (value == nil)
    {
        return nil;
    }
    
	// MD5一下
	const char* str = [value UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
}

+ (NSArray *)scheme:(NSString *)urlName
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    id value = [dic objectForKey:@"CFBundleURLTypes"];
    if (YES == [value isKindOfClass:[NSArray class]])
    {
        NSArray *urlType = (NSArray *)value;
        for (id key in urlType)
        {
            if ([key isKindOfClass:[NSDictionary class]])
            {
                id plistSchemeIdentifier = [key objectForKey:@"CFBundleURLName"];
                if ([plistSchemeIdentifier isKindOfClass:[NSString class]]
                    && [plistSchemeIdentifier isEqualToString:urlName])
                {
                    return[key objectForKey:@"CFBundleURLSchemes"];
                }
            }
        }
    }
    
    return nil;
}

+ (NSString *)GetURLWithParam:(NSString *)baseUrl withParam:(NSDictionary *)data
{
    if (nil == baseUrl)
    {
        return nil;
    }
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:baseUrl];
    NSMutableString *param = [[NSMutableString alloc] initWithString:@""];
    
    BOOL isFirst = YES;
    for (id key in[data allKeys])
    {
        if (YES == isFirst)
        {
            [param appendString:@"?"];
            isFirst = NO;
        }
        else
        {
            [param appendString:@"&"];
        }
        
        [param appendString:(NSString *)key];
        [param appendString:@"="];
        
        NSString *value = [data objectForKey:key];
        CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes
        (NULL, (CFStringRef)value, NULL,
         (CFStringRef)@"!*’();:&=+$,/?%#[]", kCFStringEncodingUTF8);
        
        if (NULL != encodedValue)
        {
#if __has_feature(objc_arc)
            [param appendString:(NSString *)CFBridgingRelease(encodedValue)];
#else
            [param appendString:(NSString *)(encodedValue)];
            CFRelease(encodedValue);
#endif
        }
    }
    
    [url appendString:param];
    __RELEASE(param);
    return __AUTORELEASE(url);
}

@end
