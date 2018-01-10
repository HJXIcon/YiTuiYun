//
//  FirstProjectOrTaskDetailCell.h
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectModel;
@protocol FirstProjectOrTaskDetailCellDelegate;

@interface FirstProjectOrTaskDetailCell : UITableViewCell
@property (weak, nonatomic) id <FirstProjectOrTaskDetailCellDelegate> delegate;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) CGFloat cellHight;//cell的高度


@property(nonatomic,strong) ProjectModel * model;

- (void)btnLayOut:(ProjectModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@protocol FirstProjectOrTaskDetailCellDelegate <NSObject>

- (void)moreAdressButtonClick;

@end
