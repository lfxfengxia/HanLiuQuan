//
//  FXSettingViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSettingViewController.h"
#import "FXIdeaViewController.h"
#import "FXAboutHanLiuQuanViewController.h"
#import "Common.h"

@interface FXSettingViewController () <UIAlertViewDelegate>

@end

@implementation FXSettingViewController

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
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - action

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toogleColor:(UISwitch *)sender {
}

- (IBAction)toogleMseg:(UISwitch *)sender {
}

- (IBAction)clean:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"清理缓存！" message:@"清理缓存后，您的账号信息及缓存将会清空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (IBAction)idea:(id)sender {
    FXIdeaViewController *ideaVC = [[FXIdeaViewController alloc]init];
    [self.navigationController pushViewController:ideaVC animated:YES];
}

- (IBAction)hanLiuQuan:(id)sender {
    FXAboutHanLiuQuanViewController *aboutHLQVC = [[FXAboutHanLiuQuanViewController alloc]init];
    [self.navigationController pushViewController:aboutHLQVC animated:YES];
}

- (IBAction)score:(id)sender {
}

#pragma mark - custom method

- (UILabel *)setupCleanLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.center = self.view.center;
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    label.text = @"正在清除";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0;
    [self.view addSubview:label];
    return label;
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UILabel *cleanLabel = [self setupCleanLabel];
        [UIView animateWithDuration:2.0 animations:^{
            cleanLabel.alpha = 1.0;
            //清理数据库，清理缓存
            [[NSUserDefaults standardUserDefaults] setObject:NO forKey:kIsLogining];
        } completion:^(BOOL finished) {
            cleanLabel.text = @"清理完成";
            [UIView animateWithDuration:2.0 animations:^{
                cleanLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                [cleanLabel removeFromSuperview];
            }];
        }];
    }
}

@end
