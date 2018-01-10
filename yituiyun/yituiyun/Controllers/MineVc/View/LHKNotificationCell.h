//
//  LHKNotificationCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/28.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHKNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *shenTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contenetLabel;

@end
