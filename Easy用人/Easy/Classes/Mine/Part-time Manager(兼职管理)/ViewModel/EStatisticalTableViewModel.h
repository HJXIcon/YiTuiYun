//
//  EStatisticalTableViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"

@class EStatisticalTableModel;
@interface EStatisticalTableViewModel : EBaseViewModel
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSString *totalPrice;

/// 兼职管理列表
@property (nonatomic, strong) NSMutableArray <EStatisticalTableModel *>*tableModels;

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
                                completion:(void(^)(void))completion;


@end
