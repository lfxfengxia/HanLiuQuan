//
//  FXLoginUserInfo.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXLoginUserInfo.h"
#import "FXUserModel.h"
#import "FXDatabaseManager.h"
#import "Common.h"

@interface FXLoginUserInfo ()

@property (nonatomic,strong) NSUserDefaults *defaults;

@end

@implementation FXLoginUserInfo

+(instancetype)shareLoginUserInfo
{
    static FXLoginUserInfo *loginUserInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginUserInfo = [[FXLoginUserInfo alloc]init];
    });
    return loginUserInfo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveLoginUserInfoWithUser:(FXUserModel *)user
{
     [self.defaults setInteger:user.user_id forKey:kUsr_id];
//    NSArray *array = @[user.nickName,user.age,user.gender,user.address,user.description,user.icon_url,user.favourites_count,user.followers_count];
//    for (int i = 0; i < array.count; i ++ ) {
//        NSString *str = array[i];
//        if ([str isKindOfClass:[NSNull class]] || [str isEqual:@""]) {
//            str = @"00";
//        }
//
//    }
//    [self.defaults setObject:user.nickName forKey:kNickname];
//    [self.defaults setObject:user.age forKey:kAge];
//    [self.defaults setObject:user.gender forKey:kGender];
//    [self.defaults setObject:user.address forKey:kAddress];
//    [self.defaults setObject:user.descriptions forKey:kDescriptions];
//    [self.defaults setObject:user.icon_url forKey:kIcon_url];
//    [self.defaults setObject:user.favourites_count forKey:kFavourites];
//    [self.defaults setObject:user.followers_count forKey:kFollowers];
//    [self.defaults setBool:user.is_new forKey:kIS_new];
//    [self.defaults synchronize];
}

- (FXUserModel *)searchLoginUserInfo
{
    FXUserModel *user = [FXDatabaseManager selectLoginUserInfo];
    
    return user;

}

- (void)deleteLoginUserInfo
{
//    [self.defaults setValue:nil forKey:kUsr_id];
//    [self.defaults setValue:nil forKey:kNickname];
//    [self.defaults setValue:nil forKey:kAge];
//    [self.defaults setValue:nil forKey:kGender];
//    [self.defaults setValue:nil forKey:kAddress];
//    [self.defaults setValue:nil forKey:kDescriptions];
//    [self.defaults setValue:nil forKey:kIcon_url];
//    [self.defaults setValue:nil forKey:kFavourites];
//    [self.defaults setValue:nil forKey:kFollowers];
//    [self.defaults setBool:nil forKey:kIS_new];
}

@end
