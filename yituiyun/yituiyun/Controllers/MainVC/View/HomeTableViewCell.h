//
//  HomeTableViewCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeTableModel.h"
#import "CompanyNeedListModel.h"

@interface HomeTableViewCell : UITableViewCell
/**模型数据 */
@property(nonatomic,strong) homeTableModel * model;
@property (weak, nonatomic) IBOutlet UIView *titlepanView;
@property (weak, nonatomic) IBOutlet UILabel *jianzhistatusLabel;
@property(nonatomic,strong) CompanyJianZhiModel * fujinjianzhimodel;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;


@property (weak, nonatomic) IBOutlet UILabel *zhaopinPersonNumberLabel;

@end
