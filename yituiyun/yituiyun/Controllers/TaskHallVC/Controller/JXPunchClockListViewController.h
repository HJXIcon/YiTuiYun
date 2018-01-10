//
//  JXPunchClockListViewController.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXBaseTableViewController.h"

/**
 打卡列表VC
 */
@interface JXPunchClockListViewController : JXBaseTableViewController
@property (nonatomic, strong) NSString *job_id;

/**
 重新加载数据
 */
- (void)reloadNodeListDataArray;
@end
