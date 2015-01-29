//
//  FXDataModal.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXMessageModal : NSObject
@property (nonatomic) int message_id;
@property (nonatomic, strong) NSString *titile;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *imgae;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *theme;

- (instancetype)initWithData:(NSDictionary *)dict;
@end
