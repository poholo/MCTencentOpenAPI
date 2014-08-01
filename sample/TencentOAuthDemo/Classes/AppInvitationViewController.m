//
//  AppInvitationViewController.m
//  tencentOAuthDemo
//
//  Created by 易壬俊 on 13-6-3.
//
//

#import "AppInvitationViewController.h"

@interface AppInvitationViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) TencentOAuth *tencentOAuth;
@property (strong, nonatomic) NSArray *acts;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *sourceTextField;
@property (retain, nonatomic) IBOutlet UITextField *picurlTextField;
@property (retain, nonatomic) IBOutlet UITextField *descTextField;
@property (retain, nonatomic) IBOutlet UITextField *actTextField;

@property (retain, nonatomic) IBOutlet UIPickerView *actPickerView;

@end

@implementation AppInvitationViewController

- (id)initWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _tencentOAuth = tencentOAuth;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.acts = @[@"进入应用", @"领取奖励", @"获取能量", @"帮助TA"];
    UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    [self.actPickerView selectRow:0 inComponent:0 animated:YES];
    self.actTextField.text = self.acts[0];
}

- (void)viewDidUnload
{
    [self setSourceTextField:nil];
    [self setPicurlTextField:nil];
    [self setDescTextField:nil];
    [self setActTextField:nil];
    [self setActPickerView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [_sourceTextField release];
    [_picurlTextField release];
    [_descTextField release];
    [_actTextField release];
    [_actPickerView release];
    [_scrollView release];
    [super dealloc];
}

- (IBAction)doAppInvitationTest:(id)sender
{
    [_tencentOAuth sendAppInvitationWithDescription:self.descTextField.text
                                           imageURL:[NSURL URLWithString:self.picurlTextField.text]
                                             source:self.sourceTextField.text];
}

- (IBAction)cancel:(id)sender
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self_parentViewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self_parentViewController dismissModalViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.actTextField) {
        [self.actPickerView.superview setHidden:NO];
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.actPickerView.frame;
            rect.origin.y -= rect.size.height;
            [self.actPickerView setFrame:rect];
        } completion:NULL];
        return NO;
    } else {
        return YES;
    }
}

- (void)hideKeyboard:(id)gestureRecognizer
{
    if (self.sourceTextField.isFirstResponder)
        [self.sourceTextField resignFirstResponder];
    if (self.picurlTextField.isFirstResponder)
        [self.picurlTextField resignFirstResponder];
    if (self.descTextField.isFirstResponder)
        [self.descTextField resignFirstResponder];
}

- (IBAction)hideActPickerView:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.actPickerView.frame;
        rect.origin.y = CGRectGetMaxY([sender frame]);
        [self.actPickerView setFrame:rect];
    } completion:^(BOOL finished) {
        [sender setHidden:YES];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.acts count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.acts[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.actTextField.text = self.acts[row];
}

@end
