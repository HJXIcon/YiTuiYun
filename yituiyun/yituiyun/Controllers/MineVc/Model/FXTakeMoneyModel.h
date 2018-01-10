//
//  FXTakeMoneyModel.h
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXTakeMoneyModel : NSObject
@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *iconImg;

@property (nonatomic, copy) NSString *title;
/** 账号 微信 支付宝 银行卡号  */
@property (nonatomic, copy) NSString *accountNum;
/** 银行卡支行描述  */
@property (nonatomic, copy) NSString *branch;
/** 文字描述  */
@property (nonatomic, copy) NSString *describeStr;
/** 是否选择  */
@property (nonatomic, copy) NSString *isChose;
/** 持卡人  */
@property (nonatomic, copy) NSString *cardholder;
/** 微信收款二维码  */
@property (nonatomic, copy) NSString *wxCodeImg;

@end
