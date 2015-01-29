//
//  FXCommentModal.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCommentModal.h"
#import "Common.h"

@implementation FXCommentModal
- (instancetype)initWithData:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.usr_id = [dict[kUsr_id] intValue];
        self.usr_name = dict[kUsr_name];
        self.avatar_img = dict[kAvatar];
        self.attitude_count = dict[kAttitude_count];
        self.floor_num = dict[kFloor_num];
        self.date = dict[kCommentDate];
        self.content_text = dict[kContent_text];
    }
    return self;
}
@end
