//
//  showContentViewController.m
//  sdkDemo
//
//  Created by qqconnect on 13-6-8.
//  Copyright (c) 2013年 qqconnect. All rights reserved.
//

#import "showContentViewController.h"

@interface showContentViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *audioUrl;
@property (strong, nonatomic) IBOutlet UITextField *videoUrl;


@end

@implementation showContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self textTitle] setText:[self sTitle]];
    [[self imageView] setImage:[self objImage]];
    [[self audioUrl] setText:[self sAudioUrl]];
    [[self videoUrl] setText:[self sVideoUrl]];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [[self navigationItem] setLeftBarButtonItem:leftItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    
    [self setSTitle:nil];
    [self setObjImage:nil];
    [self setSAudioUrl:nil];
    [self setSVideoUrl:nil];
    [super viewDidUnload];
}

- (void)close
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0)
    {
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [[self navigationController] dismissModalViewControllerAnimated:YES];
    }
  
}
@end
