//
//  FXCommentDetailCell.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCommentDetailCell.h"
#import "FXTextHeight.h"
#import "UIImageView+WebCache.h"
#import "FXCommentModal.h"
#import "FXCommentDetailViewController.h"
#import "Common.h"

@interface FXCommentDetailCell ()

@property (nonatomic,strong) FXCommentDetailViewController *detailCommentVC;

@end

@implementation FXCommentDetailCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.detailCommentVC = [[FXCommentDetailViewController alloc]init];
    }
    return self;
}

- (void)awakeFromNib
{
    _sweipeLife = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(liftSlideButton:)];
    _sweipeLife.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_sweipeLife];
    _sweipeRigth = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(liftSlideButton:)];
    _sweipeRigth.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_sweipeRigth];
}
- (void)liftSlideButton:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        __block CGPoint point = self.contentView.center;
        if (point.x < kWidth/2.0) {
            
            [self outLiftViewCell];
            [UIView animateWithDuration:1.0 animations:^{
                point.x = point.x + 100;
                self.contentView.center = point;
            }];
        }
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        __block CGPoint point = self.contentView.center;
        if (point.x >= kWidth/2) {
            [UIView animateWithDuration:1.0 animations:^{
                if (_buttonlift == nil) {
                [self liftViewCell];
                }
                point.x = point.x - 100;
                self.contentView.center = point;
            }];
            
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self   outLiftViewCell];
    // Configure the view for the selected state
}
- (void)liftViewCell
{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(kWidth -70 -20 - 10, 30, 30, 30);
    [_button setImage:[UIImage imageNamed:@"内页-点赞@2x"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    _buttonlift = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonlift.tag = 1005;
    _buttonlift.frame = CGRectMake(kWidth - 40 - 10 , 30, 30, 30);
    if (_mark == NO) {
        [_buttonlift setImage:[UIImage imageNamed:@"内页-评论-评论@2x"] forState:UIControlStateNormal];
    }else{
        [_button setImage:[UIImage imageNamed:@"内页-点赞-press@2x"] forState:UIControlStateNormal];
        [_buttonlift setImage:[UIImage imageNamed:@"内页-评论-评论@2x"] forState:UIControlStateNormal];
    }
    [_buttonlift addTarget:self.detailCommentVC action:@selector(commentInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonlift];
}
- (void)outLiftViewCell
{
    if (_mark == YES) {
        _button.frame = CGRectMake(0, 0, 0, 0);
        _button= nil;
        
    }else{
        [_button removeFromSuperview];
        _button = nil;
        
    }
    if(_buttonlift){
        [_buttonlift removeFromSuperview];
        _buttonlift = nil;
    }
}
- (CGFloat)calculateCellHeight:(FXCommentModal *)modal
{
    CGFloat cellHeight = [FXTextHeight textHeightWith:modal.content_text fontSize:17 withWidth:kWidth - 59];
    return cellHeight + 52;
}

- (void)cellDataWithCommentModal:(FXCommentModal *)commentModal
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:commentModal.avatar_img]];
    if ([commentModal.usr_name isKindOfClass:[NSNull class]]) {
        commentModal.usr_name = @"匿名用户";
    }
    [self.nameBtn setTitle:commentModal.usr_name forState:UIControlStateNormal];
    self.contentL.text = commentModal.content_text;
    self.timeL.text = commentModal.date;
}
- (void)likeButton:(UIButton *)button
{
    if (_mark) {
        [_button setImage:[UIImage imageNamed:@"内页-点赞@2x"] forState:UIControlStateNormal];
        _mark = NO;
    }else{
    
        [_button setImage:[UIImage imageNamed:@"内页-点赞-press@2x"] forState:UIControlStateNormal];
        _mark = YES;
    }
}
@end
