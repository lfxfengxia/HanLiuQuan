//
//  FXAboutHanLiuQuanViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXAboutHanLiuQuanViewController.h"

@interface FXAboutHanLiuQuanViewController ()

@end

@implementation FXAboutHanLiuQuanViewController

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

- (IBAction)showVersion:(UIButton *)sender {
    UILabel *versionLabel = [self setupVersionLabel:sender];
    [UIView animateWithDuration:2.0 animations:^{
        versionLabel.alpha = 1;
    }];
}

- (UILabel *)setupVersionLabel:(UIButton *)sender
{
    CGFloat hight = sender.bounds.size.height;
    CGFloat width = sender.bounds.size.width;
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + hight + 20, width, hight * 2)];
    versionLabel.text = @"您目前使用的是最新版本";
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.backgroundColor = [UIColor blackColor];
    versionLabel.alpha = 0;
    [self.view addSubview:versionLabel];
    return versionLabel;
}

@end
