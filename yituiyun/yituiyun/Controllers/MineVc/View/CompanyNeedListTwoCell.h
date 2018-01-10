//
//  CompanyNeedListTwoCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/17.
//  Copyright © 2017年 张强. All rights reserved.
//

typedef void(^DeleteBlock)();
#import <UIKit/UIKit.h>
#import "CompanyNeedListModel.h"

@interface CompanyNeedListTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property(nonatomic,strong) CompanyNeedListModel * model;
//@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(nonatomic,copy)DeleteBlock  delteBlock;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *fistLabel;
@end
