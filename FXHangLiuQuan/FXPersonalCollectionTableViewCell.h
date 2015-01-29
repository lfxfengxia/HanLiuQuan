//
//  FXPersonalCollectionTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPersonalCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *textNameBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentTextView;


- (CGFloat)heightForCollectionCell;

@end
