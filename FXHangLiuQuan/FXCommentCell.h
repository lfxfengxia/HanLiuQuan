//
//  FXCommentCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXMessageModal;
@interface FXCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic )BOOL mark;
#pragma mark ------
@property (weak, nonatomic) IBOutlet UILabel *finfMe;



- (void)setDataWithModal:(FXMessageModal *)modal;

- (void)setDataKmici:(FXMessageModal *)modal;


@end

