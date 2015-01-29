//
//  FXOnePersonalTableViewController.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceToolBar.h"
@class MessageFarme,Message;
@interface FXOnePersonalTableViewController : UITableViewController
@property (nonatomic ,strong)  UITableView *tableView;

@property (nonatomic ,strong)  UITextField *messageField;
@property (nonatomic ,strong) UIButton *speakBtn;
@end
