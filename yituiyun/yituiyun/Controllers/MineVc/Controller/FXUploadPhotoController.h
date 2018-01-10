//
//  FXUploadPhotoController.h
//  yituiyun
//
//  Created by fx on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXUploadPhotoControllerDelegate <NSObject>

- (void)uploadSuccess;

@end
@interface FXUploadPhotoController : ZQ_ViewController

/** 提示语  */
@property (nonatomic, copy) NSString *tipStr;
/** id （保险的订单id） */
@property (nonatomic, copy) NSString *dataID;
/** 保险类型 1工资险 2人身险  */
@property (nonatomic, copy) NSString *type;
/** 保险价格  */
@property (nonatomic, copy) NSString *price;
/** 保险开始时间  */
@property (nonatomic, copy) NSString *startDateStr;
/** 保险结束时间  */
@property (nonatomic, copy) NSString *endDateStr;
/** 支付方式 0微信 1支付宝 */
@property (nonatomic, copy) NSString *payType;


@property (nonatomic, assign) id<FXUploadPhotoControllerDelegate> delegate;

@end
