//
//  TencentUrlDecoder.m
//  TencentOpenApi_IOS
//
//  Created by xiaolongzhang on 13-5-29.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "TencentUrlDecoder.h"

@implementation TencentUrlDecoder

@synthesize scheme = _scheme;
@synthesize host = _host;
@synthesize path = _path;
@synthesize queryItem = _queryItem;

-(id)init
{
    if (self = [super init])
    {
        _queryItem = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    __RELEASE(_queryItem);
    __RELEASE(_scheme);
    __RELEASE(_host);
    __RELEASE(_path);
    __SUPER_DEALLOC;
}


+(TencentUrlDecoder*)decoderWithUrl:(NSURL *)url
{
    if (url == nil)
    {
        return nil;
    }
    
    TencentUrlDecoder* decoder = [[TencentUrlDecoder alloc] init];
    decoder.scheme = [url scheme];
    decoder.host = [url host];
    NSString *path = nil;
    if (2 > [[url path] length])
    {
        path = nil;;
    }
    else
    {   
        path = [[url path] substringFromIndex:1];
    }
    decoder.path = path;
    NSString* queryString = [url query];
    
    if (queryString) {
        NSArray* queryStringItem = [queryString componentsSeparatedByString:@"&"];
        NSString* item = nil;
        for (item in queryStringItem) {
            
            NSRange firstEquSymbolRange = [item rangeOfString:@"="];
            
            if (firstEquSymbolRange.location == NSNotFound) {
                continue;
            }
            
            NSString* key = [item substringWithRange:NSMakeRange(0, firstEquSymbolRange.location)];
            if(firstEquSymbolRange.location+1 > item.length){
                continue;
            }
            
            NSString* value = [item substringFromIndex:firstEquSymbolRange.location+1];
            
            
            [decoder.queryItem setValue:value forKey:key];
        }
    }
    
    return __AUTORELEASE(decoder);
}

@end
