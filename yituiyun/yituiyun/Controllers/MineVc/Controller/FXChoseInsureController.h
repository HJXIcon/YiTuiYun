//
//  FXChoseInsureController.h
//  yituiyun
//
//  Created by fx on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@class ProjectModel;

@interface FXChoseInsureController : ZQ_ViewController

@property (nonatomic, copy) NSString *taskId;       //任务id
@property (nonatomic, copy) NSString *taskStartDate;//任务开始时间
@property (nonatomic, copy) NSString *taskLastDays;//任务持续多少天
@property (nonatomic, copy) NSString *taskEndDate; //任务结束时间

- (instancetype)initWithProjectModel:(ProjectModel *)projectModel;

@end
