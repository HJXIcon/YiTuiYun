//
//  UITableView+HFExtension.m
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "UITableView+HFExtension.h"

@implementation UITableView (HFExtension)

-(void)setExtraCellLineHidden{
    UIView* view = [[UIView alloc] init];
    self.tableFooterView = view;
}

- (void)setHeadRefreshWithTarget:(id)target withAction:(SEL)action{
    if (target && action) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    } else {
        [self.mj_header removeFromSuperview];
    }
}

- (void)setFootRefreshWithTarget:(id)target withAction:(SEL)action{
    if (target && action) {
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    } else {
        [self.mj_footer removeFromSuperview];
    }
}

- (void)endRefreshing{
    [self reloadData];
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
}

- (void)endRefreshingWithNoMoreData{
    [self reloadData];
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
