//
//  FXSecretMesg.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSecretMesg.h"
#import "Common.h"

@implementation FXSecretMesg

- (instancetype)initWithData:(NSDictionary *)dict
{
    if (self == [super init]) {
        self.linkman_id = [dict[kLinkman_id] integerValue];
        self.sound_url = dict[kSound_url];
        self.image_url = dict[kImage_url];
        self.linkman_nickname = dict[kLinkman_nickname];
        self.image_icon_url = dict[kImage_icon_url];
        self.last_message = dict[kLast_message];
        self.last_date = dict[kLast_date];
        self.unread_count = dict[kUnread_count];
    }
    return self;
}
@end
