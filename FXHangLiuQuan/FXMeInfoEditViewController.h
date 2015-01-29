//
//  FXMeInfoEditViewController.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/10.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kEditName,
    kEditSign
}editType;


@interface FXMeInfoEditViewController : UIViewController

@property (nonatomic, assign) editType editType;

@end
