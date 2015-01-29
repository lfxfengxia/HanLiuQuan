//
//  FXNetworking.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXNetworking : NSObject

+ (void)sendHTTPFormatIsPost:(BOOL)format andParameters:(NSDictionary *)parameters andUrlString:(NSString *)urlString request:(BOOL)JSON notifationName:(NSString *)name;

@end
