//
//  FXQQLoginViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXQQLoginViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "AFNetworking/AFHTTPRequestOperationManager.h"
#import "FXAppDelegate.h"
#import "FXMainViewController.h"
#import "Common.h"


@interface FXQQLoginViewController ()<TencentSessionDelegate>\

@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@property (nonatomic,strong) NSArray *permissions;

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UILabel *labelAccessToken;

@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *appId;
@property (nonatomic,strong) NSString *localAppId;
@property (nonatomic,strong) NSString *redirectURI;
@property (nonatomic,strong) NSDate *expirationDate;
@property (nonatomic,strong) NSString *openId;

@end

@implementation FXQQLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tencentOAuth authorize:self.permissions inSafari:YES];
}

#pragma mark - property init

- (TencentOAuth *)tencentOAuth
{
    if (_tencentOAuth == nil) {
        _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"222222" andDelegate:self];
        _tencentOAuth.redirectURI = @"www.qq.com";
    }
    return _tencentOAuth;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _labelTitle.font = [UIFont systemFontOfSize:15];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labelTitle;
}

- (UILabel *)labelAccessToken
{
    if (_labelAccessToken == nil) {
        _labelAccessToken = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _labelAccessToken.font = [UIFont systemFontOfSize:15];
        _labelAccessToken.textAlignment = NSTextAlignmentCenter;
    }
    return _labelAccessToken;
}

- (NSArray *)permissions
{
    if (_permissions == nil) {
        _permissions = @[@"get_user_info",@"get_simple_userinfo",@"add_t"];
    }
    return _permissions;
}

#pragma mark - tencent session delegate

- (void)tencentDidLogin
{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]) {
        self.labelAccessToken.text = self.tencentOAuth.accessToken;
        self.accessToken = [self.tencentOAuth accessToken];
        self.openId = [self.tencentOAuth openId];
        self.appId = self.tencentOAuth.appId;
        self.expirationDate = self.tencentOAuth.expirationDate;
        self.localAppId = self.tencentOAuth.localAppId;
        self.redirectURI = self.tencentOAuth.redirectURI;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogining];
        [self dismiss];
    }else{
        self.labelTitle.text = @"登录失败";
        [self animationLabel:self.labelTitle];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.labelTitle.text = @"登录失败";
        [self animationLabel:self.labelTitle];
    }
}

-(void)tencentDidNotNetWork
{
    self.labelTitle.text = @"无网络连接，请设置网络";
    [self animationLabel:self.labelTitle];
}

#pragma mark - action

- (void)animationLabel:(UILabel *)label
{
    [self.view addSubview:label];
    [UIView animateWithDuration:1.5 animations:^{
        label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            label.alpha = 0.0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

- (void)dismiss
{
    FXAppDelegate *appDelegate = (FXAppDelegate *)[[UIApplication sharedApplication] delegate];
    FXMainViewController *mainVC = (FXMainViewController *)appDelegate.window.rootViewController;
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    mainVC.selectedIndex = 2;
}

@end
