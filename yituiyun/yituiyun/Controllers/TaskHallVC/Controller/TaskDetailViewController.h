//
//  TaskDetailViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface TaskDetailViewController : ZQ_ViewController
@property (nonatomic, copy) NSString *taskName;
@property (nonatomic, copy) NSString *doingDemandid;
@property (nonatomic, copy) NSString *doingName;
@property(nonatomic,strong) NSString * demand_status;
- (instancetype)initWithDataId:(NSString *)dataId WithType:(NSString *)type WithWhere:(NSInteger)where;

@end
