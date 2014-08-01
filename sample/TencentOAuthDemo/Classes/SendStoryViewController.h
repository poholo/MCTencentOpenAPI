//
//  SendStoryViewController.h
//  tencentOAuthDemo
//
//  Created by xiaolongzhang on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "TencentOpenAPI/TencentOAuth.h"

@interface SendStoryViewController:UIViewController
{
@private
    CGRect rect;
}

@property (strong, nonatomic)TencentOAuth *tencentOAuth;

-(IBAction)backgroundTap:(id)sender;

@end
