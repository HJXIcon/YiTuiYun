//
//  NeedDataModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/16.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeedDataModel : NSObject

//任务名称
@property(nonatomic,strong) NSString * taskName;
//任务类型
@property(nonatomic,strong) NSString * taskType;
//任务单价
@property(nonatomic,strong) NSString * tasksingle;
//任务数量
@property(nonatomic,strong) NSString * taskNumber;
//截止时间
@property(nonatomic,strong) NSString * taskTime;
//项目执行区域
@property(nonatomic,strong) NSMutableArray * taskZone;
//任务介绍
@property(nonatomic,strong) NSString * taskDesc;
//任务步骤
@property(nonatomic,strong) NSMutableArray * taskSetpArray;
//任务要求
@property(nonatomic,strong) NSMutableArray * taskrequireArray;
//任务费用
@property(nonatomic,assign) CGFloat totalFee;

@property(nonatomic,strong) NSString * logoImageurl;

//需求ID
@property(nonatomic,strong) NSString * demandID;

+(instancetype)shareInstance;

-(void)cleanData;
@end
