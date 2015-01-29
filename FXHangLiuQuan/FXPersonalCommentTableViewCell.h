//
//  FXPersonalCommentTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPersonalCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contenLabel;






- (CGFloat)heightForCommentCell;

@end
