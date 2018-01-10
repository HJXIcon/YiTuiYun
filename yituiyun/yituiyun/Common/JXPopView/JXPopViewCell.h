//
//  JXPopViewCell.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPopModel;
UIKIT_EXTERN float const PopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const PopoverViewCellTitleLeftEdge; ///< 标题左边边距

@interface JXPopViewCell : UITableViewCell

/** model*/
@property (nonatomic, strong) JXPopModel *model;

+ (instancetype)cellForTableView:(UITableView *)tableView;
+ (UIFont *)titleFont;
+ (CGSize)imageSize;

@end
