//
//  FXDatabaseManager.h
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXUserModel;

@interface FXDatabaseManager : NSObject

/**
 *  保存资讯，BBS所有信息
 *
 *  @param dataArray 网络请求的资讯数据
 */
+ (void)saveMessageToLocalWithArray:(NSArray *)messageArray;
/**
 *  查找本地的资讯信息
 *
 *  @return 查找的一组信息
 */
+ (NSArray *)selectMessageFromLocal;

/**
 *  保存资讯评论，BBS评论
 *
 *  @param commentArray 网络请求的评论数据
 */
+ (void)saveCommentToLocalWithArray:(NSArray *)commentArray;
/**
 *  根据制定消息返回所有评论
 *
 *  @param mesgID 指定消息
 *
 *  @return 一组评论
 */
+ (NSArray *)selectCommentFromLocalBy:(id)mesgID;

/**
 *  保存私信消息
 *
 *  @param secretMesgArray 网络请求的数据
 */
+ (void)saveSecretMessageWithArray:(NSArray *)secretMesgArray;
/**
 *  查找制定用户的私信列表
 *
 *  @param userID 指定用户的ID
 *
 *  @return 一组私信
 */
+ (NSArray *)selectSecretMesgByUserID:(id)userID;

/**
 *  保存登录用户信息
 *
 *  @param userInfo 网络请求的数据
 */
+ (void)saveLoginUserInfoWithDictionary:(NSDictionary *)userInfo;
/**
 *  数据库查询登录用户的信息
 *
 *  @return 返回user
 */
+ (FXUserModel *)selectLoginUserInfo;
/**
 *  本地删除用户信息
 */
+ (void)deleteLoginUserInfo;

+ (NSString *)formatWithDateString:(NSString *)dateString;

@end
