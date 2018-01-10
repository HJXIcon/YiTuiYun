//
//  MoneyDetailCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tixianStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tixianMoneyLabel;

@end
