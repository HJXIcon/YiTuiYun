//
//  FXInSurePayController.h
//  yituiyun
//
//  Created by fx on 16/11/16.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface FXInSurePayController : ZQ_ViewController

/** id  */
@property (nonatomic, copy) NSString *dataID;
/** 保险类型 1工资险 2人身险  */
@property (nonatomic, copy) NSString *type;
/** 保险价格  */
@property (nonatomic, copy) NSString *price;
/** 保险开始时间  */
@property (nonatomic, copy) NSString *startDateStr;
/** 保险结束时间  */
@property (nonatomic, copy) NSString *endDateStr;
/** 订单号  */
@property (nonatomic, copy) NSString *orderNum;

@end
