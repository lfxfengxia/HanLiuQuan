//
//  FXLoginUserInfo.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXUserModel;

@interface FXLoginUserInfo : NSObject

+ (instancetype)shareLoginUserInfo;

- (void)saveLoginUserInfoWithUser:(FXUserModel *)user;

- (FXUserModel *)searchLoginUserInfo;

- (void)deleteLoginUserInfo;

@end
