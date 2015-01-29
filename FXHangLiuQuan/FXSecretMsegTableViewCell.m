//
//  FXSecretMsegTableViewCell.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSecretMsegTableViewCell.h"
#import "FXUserModel.h"
#import "UIImageView+WebCache.h"

@implementation FXSecretMsegTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSecretKimciNumb:(FXUserModel *)model
{
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    [_name setTitle:model.nickName forState:UIControlStateNormal];
    [_Introduce setText:model.descriptions];
}
- (CGFloat)cellSeceretKmiciHeight
{
    return 55;
}
@end
