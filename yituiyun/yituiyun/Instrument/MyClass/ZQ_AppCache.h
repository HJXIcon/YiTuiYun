//
//  ZQ_AppCache.h
//  商派
//
//  Created by NIT on 15-3-24.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfoModel;

@interface ZQ_AppCache : NSObject

//保存用户信息
+ (void)saveUserInfo:(NSDictionary *)dic;
//取出用户信息
+ (NSDictionary *)takeOutUserInfo;

//存好友信息
+ (void)saveUserFriendInfo:(NSDictionary *)info WithName:(NSString *)name;
//取好友信息
+ (NSDictionary *)takeOutFriendInfo:(NSString *)name;


//存Information缓存
+ (void)cacheInformationItems:(NSArray *)Items;
//取Information缓存
+ (NSMutableArray *)getCacheInformationItems;
//判断Information缓存是否超过时间
+ (BOOL)isDynamicInformationItemsStale;

//清理缓存
+ (void)clearCache;

//获取缓存大小



+ (void)save:(UserInfoModel *)userInfoVo;


+ (UserInfoModel *)userInfoVo;


+ (void)removeUserInfoVo;

//判断企业账号是否登入
+(BOOL)qiyeHadLogin;
//判断是否有权限进行商家写入
+(BOOL)canSellerWrite;

+(NSString *)getUid;

/*********版本相关***************/
+(void)saveVersion:(NSString *)version;
+(NSString *)getlocalsaveVersion;
+(void)clearlocalVersion;
+(NSString *)getSystemVersion;

+(void)saveVersion_tishi;
+(NSString *)getVersionTiShi;
+(void)clearVersionTishi;
+(BOOL)isShowVersionImage;
@end
