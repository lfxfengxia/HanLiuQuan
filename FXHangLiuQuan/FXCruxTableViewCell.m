//
//  FXCruxTableViewCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCruxTableViewCell.h"
#import "FXMessageModal.h"
#import "UIImageView+WebCache.h"

@implementation FXCruxTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessagerBoay:(FXMessageModal *)modal
{
    _subjectLabel.text = modal.titile;
    _mainBodyLabel.text = modal.content;
    [self.cruxImage sd_setImageWithURL:[NSURL URLWithString:modal.imgae]];
}

@end
