//
//  UITableView+HFExtension.h
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HFExtension)

-(void)setExtraCellLineHidden;

- (void)setHeadRefreshWithTarget:(id)target withAction:(SEL)action;
- (void)setFootRefreshWithTarget:(id)target withAction:(SEL)action;

- (void)endRefreshing;
- (void)endRefreshingWithNoMoreData;

@end
