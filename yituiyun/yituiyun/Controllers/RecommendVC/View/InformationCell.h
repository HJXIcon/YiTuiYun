//
//  InformationCell.h
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InformationModel;

@interface InformationCell : UITableViewCell
@property (nonatomic, strong) InformationModel *infoModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
