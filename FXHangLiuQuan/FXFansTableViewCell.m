//
//  FXFansTableViewCell.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXFansTableViewCell.h"
#import "FXUserModel.h"
#import "UIImageView+WebCache.h"

@implementation FXFansTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFansKmiciNumb:(FXUserModel *)model
{
    [_IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    //_Like sd_setImageWithURL:[NSURL URLWithString:model.]
    [_Introduce setText:model.nickName];
    [_name setTitle:model.descriptions forState:UIControlStateNormal];
}
- (CGFloat)cellFansKmiciHeight
{
    return 55;
}
@end
