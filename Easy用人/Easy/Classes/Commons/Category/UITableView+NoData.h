//
//  UITableView+placeholder.h
//  BeautifulAgent
//
//  Created by 吴灶洲 on 2017/7/20.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENoDataView.h"

@interface UITableView (NoData)
///>>> 加载数据之前使用
@property (nonatomic, strong) UIView *noDataView;

@end
