//
//  FXPersonInfoCell.h
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPersonInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

//电话
@property (nonatomic, strong) UILabel *telNumLabel;
@property (nonatomic, strong) UIButton *changeTelBtn;
//身高cm
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *cmLabel;

@end
