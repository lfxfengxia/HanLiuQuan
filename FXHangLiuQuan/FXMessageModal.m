//
//  FXDataModal.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXMessageModal.h"
#import "Common.h"

@implementation FXMessageModal
- (instancetype)initWithData:(NSDictionary *)dict
{
    if (self == [super init]) {
        self.message_id = [dict[kMessageId] intValue];
        self.titile = dict[kMessageTitle];
        self.author = dict[kAuthor];
        self.imgae = dict[kImage];
        self.content = dict[kContent];
        self.date = dict[kDate];
        self.theme = dict[kTheme];
    }
    return self;
}
@end


