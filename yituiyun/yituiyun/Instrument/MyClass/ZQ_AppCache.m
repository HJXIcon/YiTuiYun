//
//  ZQ_AppCache.m
//  商派
//
//  Created by NIT on 15-3-24.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import "ZQ_AppCache.h"
#import "UserInfoModel.h"

#define kAssetStaleSeconds 60
#define KNACCOUNTPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"registeredUserInfo.data"]

@interface ZQ_AppCache ()
+ (NSString *)cacheDirectory;
@end

@implementation ZQ_AppCache
#pragma mark - 自己的基本信息
+ (void)saveUserInfo:(NSDictionary *)dic
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [path objectAtIndex:0];
    NSString *appCachePath = [cacheDirectory stringByAppendingPathComponent:@"AppUserInfo"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:appCachePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:appCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *dicPath = [appCachePath stringByAppendingPathComponent:@"user_Info"];
    [data1 writeToFile:dicPath atomically:YES];
}

+ (NSDictionary *)takeOutUserInfo
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [path objectAtIndex:0];
    NSString *appCachePath = [cacheDirectory stringByAppendingPathComponent:@"AppUserInfo"];
    NSString *dicPath = [appCachePath stringByAppendingPathComponent:@"user_Info"];
    NSData *data = [NSData dataWithContentsOfFile:dicPath];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dic;
}



#pragma mark - 好友基本信息
+ (void)saveUserFriendInfo:(NSDictionary *)info WithName:(NSString *)name
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [path objectAtIndex:0];
    NSString *appCachePath = [cacheDirectory stringByAppendingPathComponent:@"friendInfo"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:appCachePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:appCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:info];
    NSString *dicPath = [appCachePath stringByAppendingPathComponent:name];
    [data1 writeToFile:dicPath atomically:YES];
}

+ (NSDictionary *)takeOutFriendInfo:(NSString *)name
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [path objectAtIndex:0];
    NSString *appCachePath = [cacheDirectory stringByAppendingPathComponent:@"friendInfo"];
    NSString *dicPath = [appCachePath stringByAppendingPathComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:dicPath];
    NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info;
}


#pragma mark - 缓存
//获得document中AppCache的路径
+ (NSString *)cacheDirectory
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [path objectAtIndex:0];
    NSString *appCachePath = [cacheDirectory stringByAppendingPathComponent:@"friendInfo"];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:appCachePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:appCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return appCachePath;
}

//清理缓存
+ (void)clearCache
{
    NSArray *cacheItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[ZQ_AppCache cacheDirectory] error:nil];
    for (NSString *path in cacheItems) {
        [[NSFileManager defaultManager] removeItemAtPath:[[ZQ_AppCache cacheDirectory] stringByAppendingPathComponent:path] error:nil];
    }
}

//获得document中AppCache中要保存文件的路径
+(NSString *)fullpathOfFilename:(NSString *)filename {
    
    NSString *documentsPath = [self cacheDirectory];
    return [documentsPath stringByAppendingPathComponent:filename];
}
//添加缓存
+ (void)cacheData:(NSData *)data toFile:(NSString *)fileName
{
    //缓存数据模型
    NSString *archivePath = [self fullpathOfFilename:fileName];
    [data writeToFile:archivePath atomically:YES];
}
//取缓存
+ (NSData *)dataForFile:(NSString *)fileName
{
    NSString *archivePath = [self fullpathOfFilename:fileName];
    NSData *data = [NSData dataWithContentsOfFile:archivePath];
    return data;
}

//缓存数组
+ (void)cacheInformationItems:(NSArray *)Items
{
    NSData  *data1 = [NSKeyedArchiver archivedDataWithRootObject:Items];
    [self cacheData:data1 toFile:@"information"];
}

//取出数组缓存
+ (NSMutableArray *)getCacheInformationItems
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"information"]];
}

//判断information缓存是否超过时间
+ (BOOL)isDynamicInformationItemsStale
{
    NSString *f = [self fullpathOfFilename:@"information"];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval stalenessLeval = [currentDate timeIntervalSinceDate:[[[NSFileManager defaultManager] attributesOfItemAtPath:f error:nil] fileModificationDate]];
    
    return stalenessLeval > kAssetStaleSeconds;
}

+ (void)save:(UserInfoModel *)userInfoVo{
    [NSKeyedArchiver archiveRootObject:userInfoVo toFile:KNACCOUNTPATH];
}

+ (UserInfoModel *)userInfoVo{
    UserInfoModel *userInfoVo = [NSKeyedUnarchiver unarchiveObjectWithFile:KNACCOUNTPATH];
    return userInfoVo;
}

+ (void)removeUserInfoVo {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:KNACCOUNTPATH error:nil];
}


//判断企业是否登入过
+(BOOL)qiyeHadLogin{
    
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    
    if (![user.userID isEqualToString:@"0"] && [user.userID isEqualToString:@"5"]) {
        return YES;
    }else{
        return NO;
    }
    
}

+(BOOL)canSellerWrite{
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    
        
    if ([user.userID isEqualToString:@"0"]) {
        return NO;
    }
    //1 全职  //2兼职
    if ([user.identity isEqualToString:@"6"] && ([user.jobType isEqualToString:@"1"] || [user.jobType isEqualToString:@"2"] )) {
       
        return YES;
    }else{
        return NO;
    }

}

+(NSString *)getUid{
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    
    return user.userID;
}

/***************Version*************/

+(void)saveVersion:(NSString *)version{
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:Kversion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString *)getlocalsaveVersion{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Kversion];
}

+(void)clearlocalVersion{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Kversion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getSystemVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString * app_Version = infoDictionary[@"CFBundleShortVersionString"];
    
    return app_Version;

}



+(void)saveVersion_tishi{
    [[NSUserDefaults standardUserDefaults] setObject:@"versiontishi" forKey:KversionTishi];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString *)getVersionTiShi{
   
    return [[NSUserDefaults standardUserDefaults] objectForKey:KversionTishi];
}

+(void)clearVersionTishi{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KversionTishi];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isShowVersionImage{
    NSString *str = [ZQ_AppCache getlocalsaveVersion];
    
    if ([str isEqualToString:@""] || str ==nil) {
        return NO;
    }else{
        NSString *appsystem =[ZQ_AppCache getSystemVersion];
        if (![appsystem isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}
/**************************************/

@end
