//
//  TaskSecondCell.h
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSecondCell : UITableViewCell
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *singleLabel;
@property (nonatomic, strong) UILabel *promotionLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

