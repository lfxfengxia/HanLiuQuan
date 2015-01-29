//
//  FXViewControllerManager.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXViewControllerManager.h"
#import "FXMainViewController.h"
#import "FXGuideViewController.h"
#import "FXAppDelegate.h"
#import "Common.h"

static BOOL isNotFirstLaunch = NO;

@implementation FXViewControllerManager

+ (void)initialize
{
    if (self == [FXViewControllerManager class]) {
        isNotFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kIsNotFirstLanuch];
    }
}

+(id)rootViewController
{
    if (isNotFirstLaunch) {
        FXMainViewController *mainVC = [[FXMainViewController alloc]init];
        return mainVC;
    }else{
        FXGuideViewController *guideVC =[[FXGuideViewController alloc]init];
        return guideVC;
    }
}

+(void)guideEnd
{
    FXAppDelegate *appDelegate = (FXAppDelegate *)[[UIApplication sharedApplication] delegate];
    FXMainViewController *mainVC = [[FXMainViewController alloc]init];
    appDelegate.window.rootViewController = mainVC;
    mainVC.selectedIndex = 2;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kIsNotFirstLanuch];
    [defaults synchronize];
}

@end
