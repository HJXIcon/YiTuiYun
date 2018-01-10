//
//  LatestDynamicCell.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestDynamicCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSMutableDictionary *dynamicDic;
@property (nonatomic, assign) CGFloat height;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)makeView;
@end
