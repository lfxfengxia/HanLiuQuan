//
//  FXNewsTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXMessageModal;

@interface FXNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

//绑数据
- (void)setMessagerBoay:(FXMessageModal *)modal;
- (CGFloat)cellRowForHeight:(FXMessageModal *)modal;

@end
