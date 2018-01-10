//
//  TaskEnterpriseDetailViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface TaskEnterpriseDetailViewController : ZQ_ViewController
@property (nonatomic, copy) NSString *applyStop;
@property (nonatomic, copy) NSString *applyQuest;
- (instancetype)initWithDataId:(NSString *)dataId WithType:(NSString *)type WithWhere:(NSInteger)where;

@end
