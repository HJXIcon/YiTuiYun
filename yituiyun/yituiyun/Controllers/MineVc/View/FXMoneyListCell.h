//
//  FXMoneyListCell.h
//  yituiyun
//
//  Created by fx on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXMoneyListModel.h"

@interface FXMoneyListCell : UITableViewCell

@property (nonatomic, strong) FXMoneyListModel *listModel;

+ (instancetype)moneyListCellWithTableView:(UITableView *)tableView;

@end
