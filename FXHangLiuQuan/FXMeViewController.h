//
//  FXMeViewController.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kMe,
    kOther
}userType;

@class FXUserModel;

@interface FXMeViewController : UIViewController

@property (nonatomic, assign) userType userType;
@property (nonatomic, strong) FXUserModel *user;

@end
