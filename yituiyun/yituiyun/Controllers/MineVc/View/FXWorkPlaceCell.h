//
//  FXWorkPlaceCell.h
//  yituiyun
//
//  Created by fx on 16/10/29.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXWorkPlaceModel.h"

@interface FXWorkPlaceCell : UITableViewCell

@property (nonatomic, strong) FXWorkPlaceModel *placeModel;

@property (nonatomic,assign) BOOL isChose;

+ (instancetype)placeCellWithTableView:(UITableView *)tableView;

@end
