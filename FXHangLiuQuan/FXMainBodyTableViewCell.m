//
//  FXMainBodyTableViewCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXMainBodyTableViewCell.h"
#import "FXMessageModal.h"
#import "UIImageView+WebCache.h"
#import "FXUserModel.h"

@implementation FXMainBodyTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}       

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setMessagerBoay:(FXMessageModal *)modal
{
    _headingLabel.text = modal.titile;
    _authorLabel.text = modal.author;
    _dateLabel.text = modal.date;
    _mainBodyLabel.text = modal.content;
    _typeLabel.text = modal.theme;
    [self.image sd_setImageWithURL:[NSURL URLWithString:modal.imgae]];
}

- (CGFloat)cellHeight:(FXMessageModal *)modal
{
    CGFloat sizeHeight = 0;
    _headingLabel.text = modal.titile;
    _mainBodyLabel.text = modal.content;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    sizeHeight += size.height;
    return sizeHeight;
    
}

@end
 
