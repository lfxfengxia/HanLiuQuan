//
//  FXHomeTableViewController.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@end
