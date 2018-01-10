//
//  EBaseCollectionViewController.h
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewController.h"

@interface EBaseCollectionViewController : EBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

/** 是否第一次进入界面 */
@property (nonatomic, assign, getter=isRefresh) BOOL refresh;

- (void)loadFooterData;
- (void)loadHeaderData;
- (void)endRefreshing;

@end
