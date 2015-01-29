//
//  FXPossessTableViewCell.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXPossessTableViewCell.h"
#import "FXUserModel.h"
#import "UIImageView+WebCache.h"
#import "FXSecretMesg.h"
#import "UIImageView+WebCache.h"

@implementation FXPossessTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGFloat)cellSeceretKmiciHeight
{
    return 55;
}
- (void)setSecretKimciNumb:(FXUserModel *)model
{
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    [_name setTitle:model.nickName forState:UIControlStateNormal];
    [_seek setText:model.descriptions];
}

- (void)cellDataWithUser:(FXUserModel *)user
{
    
}

- (void)cellDataWithdictionary:(NSDictionary *)dic
{
    [self.name setTitle:dic[@"name"] forState:UIControlStateNormal];
    self.seek.text = dic[@"seek"];
    self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"img"]]];
    self.seekImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"img"]]];
}
- (CGFloat)cellMessageKimciHeight
{
    return 55;
}
- (void)setMessageKmiciNunb:(FXSecretMesg *)model
{
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.image_icon_url]];
    [_name setTitle:model.linkman_nickname forState:UIControlStateNormal];
}
@end
