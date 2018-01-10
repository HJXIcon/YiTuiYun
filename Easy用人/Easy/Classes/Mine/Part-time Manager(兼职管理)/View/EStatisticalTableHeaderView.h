//
//  EStatisticalTableHeaderView.h
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat const EStatisticalTableHeaderViewHeight;

@interface EStatisticalTableHeaderView : UIView
@property (nonatomic, assign) NSInteger peopleNum;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, copy) void(^filterBlock)(void);
@property (nonatomic, assign) BOOL hiddenPeopleNumLabel;

@end
