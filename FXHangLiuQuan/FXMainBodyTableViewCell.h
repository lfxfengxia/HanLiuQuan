//
//  FXMainBodyTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXMessageModal;
@interface FXMainBodyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;


@property (nonatomic ,strong)FXMessageModal *modalKmici;
//绑数据
- (void)setMessagerBoay:(FXMessageModal *)modal;
- (CGFloat)cellHeight:(FXMessageModal *)modal;

@end
