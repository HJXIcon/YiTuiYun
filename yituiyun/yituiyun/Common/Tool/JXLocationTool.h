//
//  JXLocationTool.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/29.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>

@interface JXLocationTool : NSObject

+ (JXLocationTool *)shareInstance;

/**
 GPS定位获取当前位置
 
 @param success  成功
 @param errors 失败
 */
- (void)getCurrentLocations:(void(^)(NSDictionary *dict))success  error:(void(^)(BMKSearchErrorCode error))errors;

/**
 判断是否已超过中国范围
 */
- (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/**
 GPS定位获取当前地址名称和经纬度
 
 @param addressBlock  成功
 @param errors 失败
 */
- (void)getCurrentAddress:(void(^)(NSString *address,CLLocationCoordinate2D location))addressBlock  error:(void(^)(BMKSearchErrorCode error))errors;

/**
  是否是BD版
 */
+ (BOOL)isBD;

@end
