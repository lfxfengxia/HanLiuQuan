//
//  Message.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-7.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "Message.h"

@implementation Message

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
//        _linkman_id = [dict[@"linkman_id"] integerValue];
//        _user_id = [dict[@"user_id"] integerValue];
//        _pm_text = dict[@"pm_text"];
//        _pm_image = dict[@"pm_image"];
//        _pm_sound = dict[@"pm_sound"];
//        _last_date = dict[@"last_date"];
//        _unread_count = dict[@"unread_count"];
        _pm_image = dict[@"icon"];
        _last_date = dict[@"time"];
        _unread_count = dict[@"content"];

    }
    return self;
}
@end


@implementation MessageFarme

- (void)setMeaageKmici:(Message *)meaageKmici
{
#pragma mark --- 具体的
    //屏幕的宽度
    CGFloat screenY = [UIScreen mainScreen].bounds.size.width;
    if (_showTime) {
    //显示时间的位置
        //CGFloat timeL = 10;
        CGSize timeSize = [_meaageKmici.last_date sizeWithFont:[UIFont systemFontOfSize:9]];
        //显示时间尺寸的宽度
        //CGFloat timeKmici = (screenY - timeSize.width)/2;
        CGFloat timeKmici = 100;
        //_timeY = CGRectMake(timeKmici, timeL, timeSize.width + 15, timeSize.height + 10);
        _timeY = CGRectMake(timeKmici, 10, timeSize.width + 150, timeSize.height + 50);
    }
#pragma mark -- 计算头像的高度
    CGFloat iconL = 10;
#pragma mark --- 如果时自己头像显示在右边
    if (_meaageKmici.typeKmici == MessageTypeIsMe) {
        iconL = screenY - (10 + 40);
    }else if (_meaageKmici.typeKmici == MessageTypeIsYou){
        iconL = screenY - (10 + 200);
    }
    CGFloat iconKimci = CGRectGetMaxY(_timeY) + 10;
    _iconY = CGRectMake(iconL, iconKimci, 40, 40);
#pragma mark -- 计算显示内容的高度
    CGFloat conntentKimci = CGRectGetMaxX(_iconY) + 10;
    //让高度为头像显示的高度
    CGFloat conntentKimciKorea = iconKimci;
    CGSize conntentKimciSize = [_meaageKmici.unread_count sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(180, CGFLOAT_MAX)];
    if (_meaageKmici.typeKmici == MessageTypeIsMe) {
        conntentKimci = (iconL - 10 - conntentKimciSize.width -25 -15);
        conntentKimci = (iconL - 10 - 100);
    }else if    (_meaageKmici.typeKmici == MessageTypeIsYou){
        conntentKimci = (iconL-10 -140);
    }
//    _contentY = CGRectMake(conntentKimci, conntentKimciKorea, conntentKimciSize.width + 20 + 19, conntentKimciSize.height + 19 +10);
    _contentY= CGRectMake(50, conntentKimciKorea, 230, 100);
#pragma mark -- 计算整体高度 未计算成功
    _cellHeightY = MAX(CGRectGetMaxY(_contentY), CGRectGetMaxY(_iconY)) + 10;
}
@end