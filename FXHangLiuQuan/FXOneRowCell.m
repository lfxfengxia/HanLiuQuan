//
//  FXOneRowCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXOneRowCell.h"
#import "FXTextHeight.h"
#import "FXMessageModal.h"
@implementation FXOneRowCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)calculateCellHeight:(FXMessageModal *)modal
{
    CGFloat cellHeight = 0;
//    if ([modal.content isKindOfClass:[NSNull class]] || [modal.content isEqual:@""]) {
//        modal.content = @"";
//    }else{
        cellHeight = [FXTextHeight textHeightWith:modal.content fontSize:15 withWidth:0];
        cellHeight += 250;
        return cellHeight;
//    }
    
}

- (void)setDataWithModal:(FXMessageModal *)modal
{
    self.titleL.text = modal.titile;
    self.timeL.text = modal.date;
//    self.likeL.text = [NSString stringWithFormat:@"%d浏览 %d赞 %d收藏",modal];
    self.contentL.text = modal.content;
}
@end
