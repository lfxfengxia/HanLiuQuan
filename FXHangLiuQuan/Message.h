//
//  Message.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-7.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MessageTypeIsMe = 0,
    MessageTypeIsYou = 1
    
} MessageType;
@interface Message : NSObject

@property (nonatomic) NSInteger linkman_id;
@property (nonatomic) NSInteger user_id;
@property (nonatomic ,strong) NSString *pm_text;
@property (nonatomic ,strong) NSString *pm_image;
@property (nonatomic ,strong) NSString *pm_sound;
@property (nonatomic ,strong) NSString *last_date;
@property (nonatomic ,strong) NSString *unread_count;
@property (nonatomic, assign) MessageType typeKmici;


- (instancetype)initWithDict:(NSDictionary *)dic;

@end


@interface MessageFarme : NSObject
@property (nonatomic)CGRect iconY;
@property (nonatomic)CGRect timeY;
@property (nonatomic)CGRect contentY;
@property (nonatomic)CGFloat cellHeightY;
@property (nonatomic ,strong)Message *meaageKmici;
@property (nonatomic)BOOL showTime;
@end