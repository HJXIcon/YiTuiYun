//
//  EBaseTableViewController.h
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewController.h"

/**
 集成上下拉加载TableVc
 */
@interface EBaseTableViewController : EBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 是否第一次进入界面已经加载过数据 */
@property (nonatomic, assign, getter=isRefresh) BOOL refresh;

- (void)loadFooterData;
- (void)loadHeaderData;
- (void)endRefreshing;

@end
