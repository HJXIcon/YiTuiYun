//
//  ContactUsCell.h
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsCell : UITableViewCell


@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detaiLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
