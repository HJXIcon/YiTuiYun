//
//  EHomeViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/12.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"
#import "EHomeHotelModel.h"
#import "EHomeListModel.h"
#import "EHomeHrModel.h"

@interface EHomeViewModel : EBaseViewModel

// === >>> 酒店列表
@property (nonatomic, strong) NSArray<EHomeHotelModel *> *hotels;

// === >>> 打卡历史列表
/// 总的页数
@property (nonatomic, assign) int totalPage;
/// 总金额
@property (nonatomic, assign) CGFloat totalPrice;
/// 当前页
@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray<EHomeListModel *> *homeLists;

// ==>>> 关注的人力资源
@property (nonatomic, strong) NSArray <EHomeHrModel *>*hrs;

/**
 酒店列表

 @param hrId 人力公司ID
 */
- (void)getHotelListWithHrId:(NSString *)hrId completion:(void(^)(BOOL hasHotels))completion;

/**
 打卡历史列表

 @param hotelId 酒店ID, 0 或者不传表示全部
 @param startTime 开始时间,不传或者0，表示没选时间
 @param endTime 截止时间,不传或者0，表示没选时间
 */
- (void)getListWithHotelId:(NSString *)hotelId
                 startTime:(NSString *)startTime
                   endTime:(NSString *)endTime
                completion:(void(^)(void))completion;


/**
 获取关注的人力公司
 */
- (void)getMyFollowHr:(void(^)(void))completion;



/**
 获取版本号

 @param completion 版本号、appUrl、是否强制更新：1为是
 */
+ (void)getVersion:(void(^)(NSString *iosVersion, NSString *iosUrl,NSString *force))completion;

@end
