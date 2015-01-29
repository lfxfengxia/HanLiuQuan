//
//  FXPossessTableViewCell.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXUserModel,FXSecretMesg;
@interface FXPossessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UILabel *seek;
@property (weak, nonatomic) IBOutlet UIImageView *seekImage;


- (void)setSecretKimciNumb:(FXUserModel *)model;
-(CGFloat)cellSeceretKmiciHeight;

- (void)cellDataWithUser:(FXUserModel *)user;

//私信删除测试
- (void)cellDataWithdictionary:(NSDictionary *)dic;


- (CGFloat)cellMessageKimciHeight;
- (void)setMessageKmiciNunb:(FXSecretMesg *)model;

@end
