//
//  FXDatabaseManager.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXDatabaseManager.h"
#import "FMDB.h"
#import "FXMessageModal.h"
#import "FXCommentModal.h"
#import "FXSecretMesg.h"
#import "FXUserModel.h"
#import "Common.h"

#define kHQLFileName                @"HQL.db"
#define kMessage                    @"message"
#define kMesgComment                @"msegComment"
#define kSecretMesg                 @"secretMesg"
#define kUser                       @"user"

@implementation FXDatabaseManager

+ (void)initialize
{
    if (self == [FXDatabaseManager class]) {
        [FXDatabaseManager copyFile2DocumentDirectory];
    }
}

//获得dataPath

+ (NSString *)databasePath
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docPath stringByAppendingPathComponent:kHQLFileName];
}

//拷贝数据库到document directory

+ (void)copyFile2DocumentDirectory
{
    NSString *desPath = [FXDatabaseManager databasePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:desPath]) {
        NSString *sourPath = [[NSBundle mainBundle] pathForResource:kHQLFileName ofType:nil];
        [manager copyItemAtPath:sourPath toPath:desPath error:nil];
    }
}

//SQL语句创建

+ (NSString *)sqlStringWithTable:(NSString *)tableName andDictionary:(NSDictionary *)dic
{
    NSArray *allKeys = [dic allKeys];
    NSString *allKeysStr = [allKeys componentsJoinedByString:@", "];
    NSString *allValuesStr = [allKeys componentsJoinedByString:@", :"];
    allValuesStr = [@":"  stringByAppendingString:allValuesStr];
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,allKeysStr,allValuesStr];
}

+ (void)saveMessageToLocalWithArray:(NSArray *)messageArray
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FXDatabaseManager databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (NSDictionary *dic in messageArray) {
            NSString *sqlStr = [FXDatabaseManager sqlStringWithTable:kMessage andDictionary:dic];
            [db executeUpdate:sqlStr withParameterDictionary:dic];
        }
    }];

}

+ (NSArray *)selectMessageFromLocal
{
    FMDatabase *db = [FMDatabase databaseWithPath:[FXDatabaseManager databasePath]];
    NSString *sqlStr = @"SELECT * FROM message";
    FXMessageModal *message;
    NSMutableArray *messageArray = [NSMutableArray array];
    [db open];
    FMResultSet *rs = [db executeQuery:sqlStr];
    while ([rs next]) {
        message = [[FXMessageModal alloc]init];
        message.message_id = [rs intForColumn:kMessageId];
        message.titile = [rs stringForColumn:kMessageTitle];
        message.author = [rs stringForColumn:kAuthor];
//        NSString *dateStr = [rs stringForColumn:kDate];
//        message.date = [FXDatabaseManager formatWithDateString:dateStr];
        message.date = [rs stringForColumn:kDate];
        message.content = [rs stringForColumn:kContent];
        message.imgae = [rs stringForColumn:kImage];
        [messageArray addObject:message];
    }
    [rs close];
    [db close];
    return messageArray;
}

+ (void)saveCommentToLocalWithArray:(NSArray *)commentArray
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FXDatabaseManager databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (NSDictionary *dic in commentArray) {
            NSString *sqlStr = [FXDatabaseManager sqlStringWithTable:kMesgComment andDictionary:dic];
            [db executeUpdate:sqlStr withParameterDictionary:dic];
        }
    }];
}

+ (NSArray *)selectCommentFromLocalBy:(id)mesgID
{
    FMDatabase *db = [FMDatabase databaseWithPath:[FXDatabaseManager databasePath]];
    NSString *sqlStr = @"SELECT * FROM msegComment WHERE usr_id = ?";
    [db open];
    FMResultSet *rs = [db executeQuery:sqlStr,mesgID];
    FXCommentModal *comment;
    NSMutableArray *commentArray = [NSMutableArray array];
    while ([rs next]) {
        comment = [[FXCommentModal alloc]init];
        comment.usr_id = [rs intForColumn:kUsr_id];
        comment.usr_name = [rs stringForColumn:kUsr_name];
        comment.avatar_img = [rs stringForColumn:kAvatar];
        comment.attitude_count = [rs stringForColumn:kAttitude_count];
        comment.floor_num = [rs stringForColumn:kFloor_num];
//        NSString *dateStr = [rs stringForColumn:kDate];
//        comment.date = [FXDatabaseManager formatWithDateString:dateStr];
        comment.date = [rs stringForColumn:kDate];
        comment.content_text = [rs stringForColumn:kContent_text];
        [commentArray addObject:comment];
    }
    [rs close];
    [db close];
    return nil;
}

+ (void)saveSecretMessageWithArray:(NSArray *)secretMesgArray
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FXDatabaseManager databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (NSDictionary *dic in secretMesgArray) {
            NSString *sqlStr = [FXDatabaseManager sqlStringWithTable:kSecretMesg andDictionary:dic];
            [db executeUpdate:sqlStr withParameterDictionary:dic];
        }
    }];
}

+ (NSArray *)selectSecretMesgByUserID:(id)userID
{
    NSString *sqlStr = @"SELECT * FROM secretMesg WHERE linkman_id = %@";
    FMDatabase *db = [FMDatabase databaseWithPath:[FXDatabaseManager databasePath]];
    NSMutableArray *secretMesgArray = [NSMutableArray array];
    FXSecretMesg *secretMesg;
    [db open];
    FMResultSet *rs = [db executeQueryWithFormat:sqlStr,userID];
    while ([rs next]) {
        secretMesg.linkman_id = [rs intForColumn:kLinkman_id];
        secretMesg.sound_url = [rs stringForColumn:kSound_url];
        secretMesg.image_url = [rs stringForColumn:kImage_url];
        secretMesg.linkman_nickname = [rs stringForColumn:kLinkman_nickname];
        secretMesg.image_icon_url = [rs stringForColumn:kImage_icon_url];
        secretMesg.last_message = [rs stringForColumn:kLast_message];
//        NSString *dateStr = [rs stringForColumn:kLast_date];
//        secretMesg.last_date = [FXDatabaseManager formatWithDateString:dateStr];
        secretMesg.last_date = [rs stringForColumn:kLast_date];
        secretMesg.unread_count = [rs stringForColumn:kUnread_count];
        [secretMesgArray addObject:secretMesg];
    }
    [rs close];
    [db close];
    return secretMesgArray;
}

+ (void)saveLoginUserInfoWithDictionary:(NSDictionary *)userInfo
{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FXDatabaseManager databasePath]];
    NSString *delSqlStr = @"DELETE * FROM user";
    NSString *sqlStr = [FXDatabaseManager sqlStringWithTable:kUser andDictionary:userInfo];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeQuery:delSqlStr];
        [db executeUpdate:sqlStr withParameterDictionary:userInfo];
    }];
}

+ (FXUserModel *)selectLoginUserInfo
{
    NSString *sqlStr = @"SELECT * FROM user";
    FMDatabase *db = [FMDatabase databaseWithPath:[FXDatabaseManager databasePath]];
    [db open];
    FXUserModel *user;
    FMResultSet *rs = [db executeQuery:sqlStr];
    while ([rs next]) {
        user = [[FXUserModel alloc]init];
        user.nickName = [rs stringForColumn:kNickname];
        user.age = [rs stringForColumn:kAge];
        user.gender = [rs stringForColumn:kGender];
        user.address = [rs stringForColumn:kAddress];
        user.descriptions = [rs stringForColumn:kDescriptions];
        user.icon_url = [rs stringForColumn:kIcon_url];
        user.favourites_count = [rs stringForColumn:kFavourites];
        user.followers_count = [rs stringForColumn:kFollowers];
        user.is_new = [rs stringForColumn:kIS_new];
    }
    [rs close];
    [db close];
    return user;
}

+ (void)deleteLoginUserInfo
{
    [[NSUserDefaults standardUserDefaults] integerForKey:kHQL_id];
    NSString *sqlStr = @"DELETE * FROM user WHERE user_id = ?";
    FMDatabase *db = [FMDatabase databaseWithPath:[FXDatabaseManager databasePath]];
    [db open];
    [db executeUpdate:sqlStr];
    [db close];
}

+ (NSString *)formatWithDateString:(NSString *)dateString
{
    NSString *agoTime;
    NSString *formatt = @"EEE MMM dd HH:mm:ss zzz";
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:formatt];
    NSDate * date = [dateformatter dateFromString:dateString];
    NSTimeInterval time = [[[NSDate alloc]init] timeIntervalSinceDate:date];
    if (time < 60) {
        agoTime = @"刚刚";
    }else if(time > 60 && time < 3600){
        agoTime = [NSString stringWithFormat:@"%.f分钟之前",time/60];
    }else if(time >3600 && time < 3600 * 24){
        agoTime = [NSString stringWithFormat:@"%.f小时之前",time/3600];
    }else{
        NSString *formatterStr = @"MMM-dd HH:mm";
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        NSDate *date = [formatter dateFromString:formatterStr];
        agoTime = [formatter stringFromDate:date];
    }
    return agoTime;
}

@end
