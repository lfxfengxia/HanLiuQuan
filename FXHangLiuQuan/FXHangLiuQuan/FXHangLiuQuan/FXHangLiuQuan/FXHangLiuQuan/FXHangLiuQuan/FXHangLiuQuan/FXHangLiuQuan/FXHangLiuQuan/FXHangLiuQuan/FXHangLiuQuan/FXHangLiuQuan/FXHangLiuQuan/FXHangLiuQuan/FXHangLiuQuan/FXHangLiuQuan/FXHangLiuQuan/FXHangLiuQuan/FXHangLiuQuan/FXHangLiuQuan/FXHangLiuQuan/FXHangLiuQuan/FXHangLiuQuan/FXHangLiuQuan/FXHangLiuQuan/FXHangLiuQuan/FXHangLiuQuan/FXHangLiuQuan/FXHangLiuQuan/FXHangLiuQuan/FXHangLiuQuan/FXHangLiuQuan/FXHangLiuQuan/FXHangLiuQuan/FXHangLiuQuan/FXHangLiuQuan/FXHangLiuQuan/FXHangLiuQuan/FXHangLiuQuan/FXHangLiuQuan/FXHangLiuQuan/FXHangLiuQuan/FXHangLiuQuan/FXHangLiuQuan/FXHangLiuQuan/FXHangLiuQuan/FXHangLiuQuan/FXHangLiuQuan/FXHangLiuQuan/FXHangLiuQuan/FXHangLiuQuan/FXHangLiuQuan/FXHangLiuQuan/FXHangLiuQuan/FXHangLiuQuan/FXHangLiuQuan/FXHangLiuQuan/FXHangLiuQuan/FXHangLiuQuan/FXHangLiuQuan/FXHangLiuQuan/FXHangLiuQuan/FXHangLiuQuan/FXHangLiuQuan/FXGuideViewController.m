//
//  FXGuideViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXGuideViewController.h"
#import "FXViewControllerManager.h"
#import "Common.h"

@interface FXGuideViewController ()

@end

@implementation FXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addimgView];
    [self comeInHanLiuQuanBtn];
}

- (void)addimgView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    if (kHeight == 568) {
        imageView.image = [UIImage imageNamed:@"start640x1136"];
    }else{
        imageView.image = [UIImage imageNamed:@"start320x480"];
    }
    
    [self.view addSubview:imageView];
}

- (void)comeInHanLiuQuanBtn
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    btn.center = CGPointMake(self.view.center.x, kHeight - 100);
    [btn setTitle:@"开始体验" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comeInHLQ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - action

- (void)comeInHLQ
{
    [FXViewControllerManager guideEnd];
}

@end
