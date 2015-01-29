//
//  FXCommentTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXCommentModal;

@interface FXCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *CommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;

@property (nonatomic)UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic)UISwipeGestureRecognizer *swipeRight;

@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic )BOOL mark;


- (void)setMessager:(FXCommentModal *)modal;
- (CGFloat)cellHeight:(FXCommentModal *)modal;

@end
