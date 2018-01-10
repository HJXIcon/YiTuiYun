//
//  WorkuploadListCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/30.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyWorkModel.h"


@interface WorkuploadListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property(nonatomic,strong) CompanyWorkModel * model;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
