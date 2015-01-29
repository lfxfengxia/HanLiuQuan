//
//  FXSecretMsegTableViewCell.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXUserModel;
@interface FXSecretMsegTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UILabel *Introduce;
@property (weak, nonatomic) IBOutlet UIImageView *NoLike;



- (void)setSecretKimciNumb:(FXUserModel *)model;
-(CGFloat)cellSeceretKmiciHeight;

@end
