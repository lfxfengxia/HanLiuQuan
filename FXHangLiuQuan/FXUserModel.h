//
//  FXUserModel.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/8.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FXUserModel : NSObject
@property (nonatomic) NSInteger user_id;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *descriptions;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSString *favourites_count;
@property (nonatomic, strong) NSString *followers_count;
@property (nonatomic) BOOL is_new;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
