//
//  NotificationMessageCell.h
//  yituiyun
//
//  Created by LUKHA_Lu on 16/2/17.
//  Copyright © 2016年 KNKane. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationMessageModel;
@interface NotificationMessageCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic, strong) NotificationMessageModel *messageModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
