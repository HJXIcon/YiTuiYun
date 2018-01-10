//
//  EHomeListHeaderFooterView.h
//  Easy
//
//  Created by yituiyun on 2017/11/27.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat const EHomeListHeaderViewHeight;

/**
 列表的headerView
 */
@interface EHomeListHeaderView : UIView

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) void(^filterBlock)(void);
@end
