//
//  UIViewController+EHint.h
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXDatePickerView.h"

extern NSInteger const KEHintTag;
extern NSInteger const KEHintDateTag;

/**
 提示
 */
@interface UIViewController (EHint)



/**
 提示新版本
 
 @param describe 描述详情
 @param isShowNeverUpdate 是否显示不再更新
 @param cancelBlock 取消回调
 @param updateBlock 更新回调
 */
- (void)jx_showNewVersionWithDes:(NSString *)describe
               isShowNeverUpdate:(BOOL)isShowNeverUpdate
                     cancelBlock:(void(^)(BOOL isNever))cancelBlock
                     updateBlock:(void(^)(void))updateBlock;

/**
 提示手机号相同
 */
- (void)jx_showSamePhone;


/**
 展示日期选择

 @param completeBlock 回调block 包含开始时间、结束时间
 */
- (void)jx_showDataPickerWithCompleteBlock:(void(^)(NSDate *beginDate, NSDate *endDate))completeBlock;

@end
