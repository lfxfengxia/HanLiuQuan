//
//  FXCommentDetailCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXCommentModal;

@interface FXCommentDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *recommentL;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (nonatomic)BOOL mark;

@property (nonatomic ,strong)UISwipeGestureRecognizer *sweipeLife;
@property (nonatomic ,strong)UISwipeGestureRecognizer *sweipeRigth;
@property (nonatomic ,strong) UIButton *button;
@property (nonatomic ,strong)UIButton *buttonlift;
- (CGFloat)calculateCellHeight:(FXCommentModal *)modal;

- (void)cellDataWithCommentModal:(FXCommentModal *)commentModal;
@end
