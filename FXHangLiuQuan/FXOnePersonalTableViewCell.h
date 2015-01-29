//
//  FXOnePersonalTableViewCell.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFarme,Message;
@interface FXOnePersonalTableViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *iocnImage;
@property (weak, nonatomic) UIImageView *xx;
@property (weak, nonatomic) UILabel *comment;
@property (nonatomic ,strong)UIButton   *timeButton;
@property (nonatomic ,strong)UIImageView *iconView;
@property (nonatomic ,strong)UIButton    *contentButton;
@property (nonatomic,strong)MessageFarme *messageFarmeKmici;

- (void)setMessageFarmeKmici:(MessageFarme *)messageFarmeKmici;
@end
