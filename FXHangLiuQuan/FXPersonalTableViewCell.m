//
//  FXPersonalTableViewCell.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-16.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXPersonalTableViewCell.h"

@implementation FXPersonalTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellDataWith:(NSDictionary *)dic
{
//    _iconImageYou.image = [UIImage imageNamed:@"icon"];
//    _dataTimeYou.text = dic[@"data"];
//    _findMe = dic[@"text"];
}

- (CGFloat)cellHeightWithLabelStr:(NSString *)text
{
    self.findYou.text = text;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
