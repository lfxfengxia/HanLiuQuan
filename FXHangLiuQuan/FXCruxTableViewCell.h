//
//  FXCruxTableViewCell.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXMessageModal;

@interface FXCruxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cruxImage;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;

- (void)setMessagerBoay:(FXMessageModal *)modal;

@end
