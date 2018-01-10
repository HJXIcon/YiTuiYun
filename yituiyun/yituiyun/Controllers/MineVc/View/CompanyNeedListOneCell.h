//
//  CompanyNeedListOneCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/17.
//  Copyright © 2017年 张强. All rights reserved.
//

typedef void (^AginOrPayBlock)();
typedef void(^CancelTaskBlock)();
typedef void(^OneCellDeleBlock)();

#import <UIKit/UIKit.h>
#import "CompanyNeedListModel.h"

@interface CompanyNeedListOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *againPulishOrPay;
@property(nonatomic,strong) CompanyNeedListModel * model;
@property(nonatomic,copy) AginOrPayBlock agin_payBlock;
@property(nonatomic,copy) CancelTaskBlock  cancelBlock;
@property(nonatomic,copy) OneCellDeleBlock  onedeleteblock;

@property (weak, nonatomic) IBOutlet UILabel *fistLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



@end
