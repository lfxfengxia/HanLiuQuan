//
//  FXCommentDetailViewController.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXMessageModal;
@interface FXCommentDetailViewController : UIViewController

@property (nonatomic) int messageID;
@property (nonatomic, strong) FXMessageModal *commentModal;
@end
