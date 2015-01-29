//
//  FXMainViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXMainViewController.h"
#import "FXHomeViewController.h"
#import "FXForumTableViewController.h"
#import "FXMeViewController.h"

@interface FXMainViewController ()

@end

@implementation FXMainViewController

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
    [self addTabBarItems];
    
}

#pragma mark - add tabBar Items

- (void)addTabBarItems
{
    FXHomeViewController *homeVC = [[FXHomeViewController alloc]init];
    UINavigationController *homeNVC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    FXForumTableViewController *messageVC = [[FXForumTableViewController alloc]init];
    UINavigationController *messageNVC = [[UINavigationController alloc]initWithRootViewController:messageVC];
    FXMeViewController *aboutMeVC = [[FXMeViewController alloc]init];
    UINavigationController *aboutMeNVC = [[UINavigationController alloc]initWithRootViewController:aboutMeVC];
    self.viewControllers = @[homeNVC,messageNVC,aboutMeNVC];
}

@end
