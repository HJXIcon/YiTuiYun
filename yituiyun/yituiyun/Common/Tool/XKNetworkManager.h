//
//  XKNetworkManager.h
//  Minshuku
//
//  Created by Nicholas on 16/5/10.
//  Copyright © 2016年 Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetworkReachability [XKNetworkManager networkStateChange] // 有网

typedef void (^ErrorBlock)(NSError *error);

@interface XKNetworkManager : NSObject

/// 判断网络连接
+ (BOOL)networkStateChange;
/**
 *  判断定位服务是否开启
 *
 *  @return YES or NO
 */
+ (BOOL)locationServicesEnabled;
/**
 *  判断是否网络连接
 */
+ (void)hasNetwork:(void(^)())hasBlock hasNotNetwork:(void(^)())hasNotBlock;
/**
 *  一般POST通用
 *
 *  @param parameters 上传的参数
 *  @param success    上传成功的处理
 *  @param failure    上传失败的处理
 */
+ (void)POSTToUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void(^)(CGFloat progress))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
/**
 *  上传视频
 *
 *  @param urlString  服务器地址
 *  @param parameters 参数
 *  @param videoName  视频名
 *  @param videoPath  视频地址
 *  @param imageName  图片名
 *  @param imagePath  图片地址
 *  @param progress   进度
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)POSTVideoToUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters videoName:(NSString *)videoName videoPath:(NSString *)videoPath imageName:(NSString *)imageName imagePath:(NSString *)imagePath progress:(void (^)(CGFloat progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure;
/**
 *  GET请求，一般请求数据用
 *
 *  @param urlString  地址
 *  @param parameters 参数
 *  @param progress   进度
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)GETDataFromUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
///上传图片
+ (void)xk_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end


































