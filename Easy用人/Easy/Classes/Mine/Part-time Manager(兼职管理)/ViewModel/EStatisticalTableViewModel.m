//
//  EStatisticalTableViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EStatisticalTableViewModel.h"
#import "EUserModel.h"
#import "EStatisticalTableModel.h"

@implementation EStatisticalTableViewModel

- (NSMutableArray<EStatisticalTableModel *> *)tableModels{
    if (_tableModels == nil) {
        _tableModels = [NSMutableArray array];
    }
    return _tableModels;
}

- (instancetype)init{
    if (self = [super init]) {
        self.currentPage = 1;
        self.totalPage = 1;
    }
    return self;
}

/**
 获取报名表
 
 @param demandPriceId 0 代表统计领队所有项目 不传为0
 @param targetUserId 被搜索的childUserId 可不传
 @param startTime 开始时间,时间戳， 可不传
 @param endTime 结束时间 可不传
 @param keys 搜索的关键字，可以是电话号码或者姓名 可不传
 */
- (void)demandGroupManageWithDemandPriceId:(NSString *)demandPriceId
                              targetUserId:(NSString *)targetUserId
                                 startTime:(NSString *)startTime
                                   endTime:(NSString *)endTime
                                      keys:(NSString *)keys
                                completion:(void(^)(void))completion{
    
    if (self.currentPage > self.totalPage) {
        [self  showHint:@"没有更多了~"];
        if (completion) {
            completion();
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"pageNum"] = @(self.currentPage);
    params[@"pageSize"] = @(10);
    if (!kStringIsEmpty(demandPriceId)) {
        params[@"demandPriceId"] = demandPriceId;
    }
    if (!kStringIsEmpty(targetUserId)) {
        params[@"targetUserId"] = targetUserId;
    }
    if (!kStringIsEmpty(startTime)) {
        params[@"startTime"] = startTime;
    }
    if (!kStringIsEmpty(endTime)) {
        params[@"endTime"] = endTime;
    }
    if (!kStringIsEmpty(keys)) {
        params[@"keys"] = keys;
    }
    
    
    [PPNetworkHelper POST:E_ApiRequset(kDemandGroupManage) parameters:params success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"errno"] intValue] != 0) {
            if (completion) {
                completion();
            }
            return ;
        }
        
        /// 数组为空
        if (kDictIsEmpty(responseObject[@"rst"])) {
            self.tableModels = nil;
            self.currentPage = 1;
            self.totalPage = 1;
            self.totalPrice = @"0";
            if (completion) {
                completion();
            }
            return;
        }
        self.currentPage = [responseObject[@"rst"][@"currentPage"] intValue];
        self.totalPage = [responseObject[@"rst"][@"totalPage"] intValue];
        self.totalPrice = responseObject[@"rst"][@"totalPrice"];
        if (self.currentPage == 1) {
            self.tableModels = [EStatisticalTableModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]];
        }
        else{
            [self.tableModels addObjectsFromArray:[EStatisticalTableModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]]];
        }
        
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
        
        if (completion) {
            completion();
        }
        [self showHint:@"请求失败，请重试"];
        
    }];
}
@end
