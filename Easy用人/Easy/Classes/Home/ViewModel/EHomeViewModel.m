//
//  EHomeViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/12.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeViewModel.h"
#import "EUserModel.h"

@implementation EHomeViewModel

- (NSMutableArray<EHomeListModel *> *)homeLists{
    if (_homeLists == nil) {
        _homeLists = [NSMutableArray array];
    }
    return _homeLists;
}

- (instancetype)init{
    if (self = [super init]) {
        self.currentPage = 1;
        self.totalPage = 1;
    }
    return self;
}

- (void)getHotelListWithHrId:(NSString *)hrId completion:(void(^)(BOOL hasHotels))completion{
    
    [self jx_showLoadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"hrId"] = hrId;
    [PPNetworkHelper POST:E_ApiRequset(kHotelList) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        if ([responseObject[@"errno"] intValue] != 0) {
            if (completion) {
                completion(NO);
            }
            return ;
        }
        self.hotels = [EHomeHotelModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"]];
        
        if (completion) {
            completion(self.hotels.count);
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showHint:@"请求失败~"];
    }];
    
}

/**
 打卡历史列表
 
 @param hotelId 酒店ID, 0 或者不传表示全部
 @param startTime 开始时间,不传或者0，表示没选时间
 @param endTime 截止时间,不传或者0，表示没选时间
 */
- (void)getListWithHotelId:(NSString *)hotelId
                 startTime:(NSString *)startTime
                   endTime:(NSString *)endTime
                completion:(void(^)(void))completion{
    
    if (self.currentPage > self.totalPage) {
        if (completion) {
            completion();
        }
        [self showHint:@"没有更多了~"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    if (!kStringIsEmpty(hotelId)) params[@"hotelId"] = hotelId;
    if (!kStringIsEmpty(startTime)) params[@"startTime"] = startTime;
    if (!kStringIsEmpty(endTime)) params[@"endTime"] = endTime;
    params[@"pageSize"] = @(10);
    params[@"pageNum"] = @(self.currentPage);
    
    [PPNetworkHelper POST:E_ApiRequset(kList) parameters:params success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"errno"] intValue] != 0) {
            if (completion) {
                completion();
            }
            return ;
        }
        self.homeLists = [EHomeListModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]];
        
        self.totalPage = [responseObject[@"rst"][@"totalPage"] intValue];
        self.totalPrice = [responseObject[@"rst"][@"totalPrice"] floatValue];
        self.currentPage = [responseObject[@"rst"][@"currentPage"] intValue];
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取关注的人力公司
 */
- (void)getMyFollowHr:(void(^)(void))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kMyFollowHr) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        if ([responseObject[@"errno"] intValue] != 0) {
            if (completion) {
                completion();
            }
            return ;
        }
        self.hrs = [EHomeHrModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"]];
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 获取版本号
 */
+ (void)getVersion:(void(^)(NSString *iosVersion, NSString *iosUrl,NSString *force))completion{
    
    [PPNetworkHelper POST:E_ApiRequset(kVersion) parameters:nil success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"errno"] intValue] != 0) {
            return ;
        }
        
        if (completion) {
            completion(responseObject[@"rst"][@"iosVersion"],responseObject[@"rst"][@"iosUrl"],responseObject[@"rst"][@"force"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
