//
//  FXCommentCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCommentCell.h"
#import "FXMessageModal.h"
#import "FXDatabaseManager.h"
#import "UIImageView+WebCache.h"

@implementation FXCommentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataWithModal:(FXMessageModal *)modal
{
    NSString *title = modal.author;
    if ([title isKindOfClass:[NSNull class]] || [title isEqual:@""]) {
        title = @"未知用户";
    }
    [self.nameBtn setTitle:title forState:UIControlStateNormal];
    self.timeLabel.text = modal.date;
    self.titleL.text = modal.titile;
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:modal.imgae]];
    UIImage *btnImage = image.image;
    if (!btnImage) {
        btnImage = [UIImage imageNamed:@"57x57.jpg"];
    }
    [self.imageBtn setImage:btnImage forState:UIControlStateNormal];
}
- (void)setDataKmici:(FXMessageModal *)modal
{
    if (_finfMe == nil
        || [_finfMe isKindOfClass:[NSNull class]]) {
        _finfMe.text = modal.titile;
    } else {
        _finfMe.text = modal.titile;
    }
}
@end
