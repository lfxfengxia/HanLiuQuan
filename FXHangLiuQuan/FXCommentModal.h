//
//  FXCommentModal.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXCommentModal : NSObject
@property (nonatomic) NSInteger usr_id;
@property (nonatomic, strong) NSString *usr_name;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *attitude_count;
@property (nonatomic, strong) NSString *floor_num;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *content_text;

- (instancetype)initWithData:(NSDictionary *)dict;
@end
