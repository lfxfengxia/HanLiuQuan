//
//  FXPersonalWriteTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPersonalWriteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeAndCollectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commetnUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;



- (CGFloat)heightForWriteCell;

@end
