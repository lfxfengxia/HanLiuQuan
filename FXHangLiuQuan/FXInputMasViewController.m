//
//  FXInputMasViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXInputMasViewController.h"
#import "FXRegsterInfoViewController.h"
#import "FXLoginViewController.h"

#import <SMS_SDK/SMS_SDK.h>

@interface FXInputMasViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,strong) NSString *phoneNum;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation FXInputMasViewController

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
}

#pragma mark - property init

- (UIAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc]initWithTitle:@"验证码获取失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新获取", nil];
    }
    return _alertView;
}

#pragma mark - action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sure:(id)sender {
    [SMS_SDK commitVerifyCode:self.textField.text result:^(enum SMS_ResponseState state) {
        NSLog(@"response state : %u",state);
        if (state == 1) {
            FXRegsterInfoViewController *registerInfoVC = [[FXRegsterInfoViewController alloc]init];
            registerInfoVC.phoneNumStr = self.phoneNum;
            [self.navigationController pushViewController:registerInfoVC animated:YES];
            
        }else{
            [self.alertView show];
        }
    }];
}

- (IBAction)login:(id)sender {
    FXLoginViewController *loginVC = [[FXLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)sendAgain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - view delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self sendAgain:nil];
    }
}

@end
