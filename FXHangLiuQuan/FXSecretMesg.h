//
//  FXSecretMesg.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXSecretMesg : NSObject
@property (nonatomic) NSInteger linkman_id;
@property (nonatomic, strong) NSString *sound_url;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *linkman_nickname;
@property (nonatomic, strong) NSString *image_icon_url;
@property (nonatomic, strong) NSString *last_message;
@property (nonatomic, strong) NSString *last_date;
@property (nonatomic, strong) NSString *unread_count;

- (instancetype)initWithData:(NSDictionary *)dict;
@end
