//
//  UserAgreementCell.h
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserAgreementModel;
@interface UserAgreementCell : UITableViewCell
@property (nonatomic, strong) UserAgreementModel *userAgreementModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
