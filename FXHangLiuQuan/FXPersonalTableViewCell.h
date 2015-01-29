//
//  FXPersonalTableViewCell.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-16.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPersonalTableViewCell : UITableViewCell
#pragma mark --- me

@property (weak, nonatomic) IBOutlet UILabel *dataTimeME;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageMe;
@property (weak, nonatomic) IBOutlet UILabel *findMe;



#pragma mark --- you
@property (weak, nonatomic) IBOutlet UILabel *dataTimeYou;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageYou;

@property (weak, nonatomic) IBOutlet UILabel *findYou;

- (CGFloat)cellHeightWithLabelStr:(NSString *)text;

@end
