//
//  TodaySummaryViewController.h
//  yituiyun
//
//  Created by 张强 on 2016/11/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@class InformationModel;
@protocol TodaySummaryViewControllerDelegate <NSObject>

- (void)refreshData;

@end

@interface TodaySummaryViewController : ZQ_ViewController
@property (nonatomic,weak) id <TodaySummaryViewControllerDelegate> delegate;
- (instancetype)initWithInformationModel:(InformationModel *)model WithWhere:(NSInteger)where;
@end
