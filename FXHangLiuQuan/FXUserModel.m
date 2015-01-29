//
//  FXUserModel.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/8.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXUserModel.h"
#import "Common.h"

@implementation FXUserModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self == [super init]) {
        self.user_id = [dict[kUserId] integerValue];
        self.nickName = dict[kNickname];
        self.age = dict[kAge];
        self.favourites_count = dict[kFavourites];
        self.followers_count = dict[kFollowers];
        self.gender = dict[kGender];
        self.address = dict[kDescriptions];
        self.icon_url = dict[kIcon_url];
        self.is_new = dict[kIS_new];
    }
    return self;
}

@end
