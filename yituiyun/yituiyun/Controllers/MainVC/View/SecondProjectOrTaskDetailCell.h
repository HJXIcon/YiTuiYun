//
//  SecondProjectOrTaskDetailCell.h
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondProjectOrTaskDetailCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) CGFloat cellHight;//cell的高度

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, copy) NSString *descString;
@property(nonatomic,strong) UIImageView * iconImageView;



- (void)btnLayOut;
- (void)btnLayOut1;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

