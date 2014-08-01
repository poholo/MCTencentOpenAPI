//
//  NSURLRequest+IgnoreSSL.h
//  tencentOAuthDemo
//
//  Created by qqconnect on 13-5-20.
//
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end
