//
//  FXNetworking.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXNetworking.h"
#import "AFHTTPRequestOperationManager.h"

@implementation FXNetworking

+ (void)sendHTTPFormatIsPost:(BOOL)format andParameters:(NSDictionary *)parameters andUrlString:(NSString *)urlString request:(BOOL)JSON notifationName:(NSString *)name
{
    __block NSMutableArray *dataArray ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (JSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|
        NSJSONReadingMutableLeaves];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (format) {
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            if ([name isEqualToString:@"sendText"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:name object:responseObject userInfo:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:name object:dataArray userInfo:nil];
            }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            NSLog(@"------%@",operation.responseString);
        }];
    }else{
        [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:dataArray userInfo:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            NSLog(@"+++++++%@",operation.responseString);
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
