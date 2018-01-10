//
//  FXChoseTityCell.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXCityModel.h"

@interface FXChoseTityCell : UITableViewCell

@property (nonatomic, strong) FXCityModel *cityModel;

@property (nonatomic,assign) BOOL isSelect;

+ (instancetype)choseCellWithTableView:(UITableView *)tableView;


@end
