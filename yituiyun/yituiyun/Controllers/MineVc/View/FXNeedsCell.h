//
//  FXNeedsCell.h
//  yituiyun
//
//  Created by fx on 16/11/1.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXNeedsModel.h"

@interface FXNeedsCell : UITableViewCell

@property (nonatomic, strong) FXNeedsModel *needsModel;

+ (instancetype)needsCellWithTableView:(UITableView *)tableView;

@end
