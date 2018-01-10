//
//  FXMoneyListModel.h
//  yituiyun
//
//  Created by fx on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXMoneyListModel : NSObject

/** id  */
@property (nonatomic, copy) NSString *itemId;
/** title  */
@property (nonatomic, copy) NSString *itemTitle;
/** 时间  */
@property (nonatomic, copy) NSString *time;
/** 数量  */
@property (nonatomic, copy) NSString *num;
/** 项目名称  */
@property (nonatomic, copy) NSString *projectName;
/** 姓名  */
@property (nonatomic, copy) NSString *nickName;
/** 类型 1充值，2退款，3支付工资，4提现；1+；2，4—；3（个人+，企业-）  */
@property (nonatomic, copy) NSString *type;
/** 钱包余额  */
@property (nonatomic, copy) NSString *balance;
/** 状态 0排队等候，1正在处理中，2已完成，3申请驳回  */
@property (nonatomic, copy) NSString *state;
/** 交易方式 1微信，2支付宝，3银行卡  */
@property (nonatomic, copy) NSString *tradeType;
/** 备注  */
@property (nonatomic, copy) NSString *note;
/** 流水号  */
@property (nonatomic, copy) NSString *serialNumber;
@end
