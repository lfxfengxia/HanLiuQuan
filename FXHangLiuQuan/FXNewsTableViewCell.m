//
//  FXNewsTableViewCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXNewsTableViewCell.h"
#import "FXMessageModal.h"
#import "UIImageView+WebCache.h"

@implementation FXNewsTableViewCell

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
    _headingLabel.text = modal.titile;
    _mainBodyLabel.text = modal.content;
    [self.image sd_setImageWithURL:[NSURL URLWithString:modal.imgae]];
}

- (CGFloat)cellRowForHeight:(FXMessageModal *)modal
{
    CGFloat sizeHeight = 0;
    //_subjectLabel.text = modal.titile;
    NSString *kmiciArray = modal.imgae;
    if (kmiciArray != 0) {
        NSInteger iamgeHeight = 114;
        sizeHeight += iamgeHeight;
    }
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    sizeHeight += size.height;
    return sizeHeight;
    
}

@end
