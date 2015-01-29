//
//  FXOnePersonalTableViewCell.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXOnePersonalTableViewCell.h"
#import "Message.h"

@implementation FXOnePersonalTableViewCell


- (void)awakeFromNib
{
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
#pragma mark -- 创建事件按钮
        _timeButton = [[UIButton alloc] init];
        [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _timeButton.enabled = NO;
        [self.contentView addSubview:_timeButton];
#pragma mark -- 头像
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
#pragma mark -- 创建内容
        _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contentButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _contentButton.titleLabel.numberOfLines  = 0;
        [self.contentView addSubview:_contentButton];
    }
    return self;
}
- (void)setMessageFarmeKmici:(MessageFarme *)messageFarmeKmici
{
    _messageFarmeKmici = messageFarmeKmici;
    Message *messageL = _messageFarmeKmici.meaageKmici;
#pragma mark -- 设置时间
    [_timeButton setTitle:@"20150101" forState:UIControlStateNormal];
    _timeButton.frame = _messageFarmeKmici.timeY;
#pragma mark --设置头像
    _iconView.image = [UIImage imageNamed:@"他人-导航-加好友-press@2x"];
    _iconView.frame = _messageFarmeKmici.iconY;
#pragma mark -- 设置内容
    //[_contentButton setTitle:messageL.content forState:UIControlStateNormal];
//    [_contentButton setTitle:@"要么爱要么被爱" forState:UIControlStateNormal];
    _contentButton.contentEdgeInsets = UIEdgeInsetsMake(10, 25, 15, 15);
    _contentButton.frame = _messageFarmeKmici.contentY;
    if (messageL.typeKmici == MessageTypeIsMe) {
        _contentButton.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 15, 25);
    }
    UIImage *normal , *focused;
    if (messageL.typeKmici == MessageTypeIsMe) {
        normal = [UIImage imageNamed:@"他人-导航-加好友-press@2x"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
#pragma mark ---设置背景图片
        focused = [UIImage imageNamed:@"关注列表-取消关注@2x"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        normal  = [UIImage imageNamed:@"他人-导航-加好友-press@2x"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"关注列表-取消关注@2x"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }
    [_contentButton setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentButton setBackgroundImage:focused forState:UIControlStateNormal];
}
@end
