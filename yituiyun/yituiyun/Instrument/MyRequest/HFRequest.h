//
//  HFRequest.h
//  EasyRepair
//
//  Created by joyman04 on 15/12/29.
//  Copyright © 2015年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//typedef NS_ENUM(NSInteger, FavourType) {
//    FavourDynamic = 1, //动态赞/取消赞
//    FavourCase  //案例赞/取消赞
//};

typedef NS_ENUM(NSInteger, ChangeType) {
    
    ActivityJoin = 1, //活动报名/取消报名
    ActivityCollect, //活动收藏/取消收藏
    ActivityFavour,//活动点赞/取消点赞
    DynamicFavour,//动态点赞/取消点赞
    Focus        //关注/取消关注
};


@interface HFRequest : NSObject

+ (void)requestWithUrl:(nullable NSString *)url
            parameters:(nullable id)parameters
               success:(nullable void (^)(NSURLSessionDataTask* _Nullable task, id _Nullable responseObject))success
               failure:(nullable void (^)(NSURLSessionDataTask* _Nullable task, NSError* _Nullable error))failure;


+ (void)uploadFileWithImage:(nullable UIImage*)image
                    success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;


@end
