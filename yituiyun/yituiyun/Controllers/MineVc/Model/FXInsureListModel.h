//
//  FXInsureListModel.h
//  yituiyun
//
//  Created by fx on 16/12/2.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXInsureListModel : NSObject

/** 任务名  */
@property (nonatomic, copy) NSString *taskName;
/** 保险类型 1工资险，2人身险 */
@property (nonatomic, copy) NSString *insureType;
/** 保险开始时间  */
@property (nonatomic, copy) NSString *startTime;
/** 保险结束时间  */
@property (nonatomic, copy) NSString *endTime;
/** 购买时间  */
@property (nonatomic, copy) NSString *buyTime;
/** 购买金额  */
@property (nonatomic, copy) NSString *price;
/** 凭证  */
@property (nonatomic, strong) NSMutableArray *imgUrlArray;

@end
