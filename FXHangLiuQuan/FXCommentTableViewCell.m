//
//  FXCommentTableViewCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCommentTableViewCell.h"
#import "FXTextHeight.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "FXCommentModal.h"

@implementation FXCommentTableViewCell
- (void)awakeFromNib
{
    // Initialization code

    _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextButton:)];
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeGesture];
    _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextButton:)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_swipeRight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self removeFromCell];
}

- (void)nextButton:(UISwipeGestureRecognizer *)tap
{
    if (tap.direction == UISwipeGestureRecognizerDirectionRight) {
        __block CGPoint point = self.contentView.center;
        if (point.x < kWidth/2.0) {
            [self  removeFromCell];
            [UIView animateWithDuration:1.0 animations:^{
                point.x=point.x + 100;
                self.contentView.center=point;
            }];
        }
    }else if (tap.direction == UISwipeGestureRecognizerDirectionLeft){
        __block CGPoint point = self.contentView.center;
        if (point.x >= kWidth/2.0) {
            [UIView animateWithDuration:1.0 animations:^{
                if (self.likeBtn == nil) {
                    [self loadViewCellData];
                }
                point.x = point.x - 100;
                self.contentView.center=point;
            }];
        }
    }
}
- (void)loadViewCellData
{
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeBtn.frame = CGRectMake(kWidth - 40 - 40 - 10, 40, 40, 40);
    [_likeBtn setImage:[UIImage imageNamed:@"内页-点赞-press"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(likeViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.likeBtn];
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentBtn.frame =CGRectMake(kWidth - 40, 40, 40 , 40);
    [_commentBtn setImage:[UIImage imageNamed:@"内页-评论-press"] forState:UIControlStateNormal];
    [self addSubview:self.commentBtn];
}
- (void)removeFromCell
{
    if (self.likeBtn) {
        [self.likeBtn removeFromSuperview];
        self.likeBtn = nil;
    }
    if (self.commentBtn) {
        [self.commentBtn removeFromSuperview];
        self.commentBtn = nil;
    }
}
- (void)likeViewButton:(UIButton *)btn
{
    if (_mark) {
        [btn setImage:[UIImage imageNamed:@"内页-点赞@2x"] forState:UIControlStateNormal];
        _mark = YES;
    }else{
        [btn setImage:[UIImage imageNamed:@"内页-点赞-press@2x"] forState:UIControlStateNormal];
        _mark = NO;
    }
}

#pragma mark - 绑定数据，计算高度
- (void)setMessager:(FXCommentModal *)modal
{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:modal.avatar_img]];
    _nameButton.titleLabel.text = modal.usr_name;
    _CommentLabel.text = modal.content_text;
    _floorLabel.text = modal.floor_num;
    _dateLabel.text = modal.date;
    _answerButton.titleLabel.text = modal.attitude_count;
}

- (CGFloat)cellHeight:(FXCommentModal *)modal
{
    CGFloat cellHeight = 0;
    _CommentLabel.text = modal.content_text;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    cellHeight += size.height;
    return cellHeight;
}


@end
