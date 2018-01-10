//
//  CancelTaskCell.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NodeTextBlock)(NSString *text);

@interface CancelTaskCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *textField;
/**nod_blcok */
@property(nonatomic,copy)NodeTextBlock nodetextBlock;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) UIView * lineView;

@end
