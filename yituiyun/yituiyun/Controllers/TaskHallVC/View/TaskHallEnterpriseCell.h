//
//  TaskHallEnterpriseCell.h
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectModel;
@protocol TaskHallEnterpriseCellDelegate <NSObject>

- (void)startButtonClickWithIndex:(NSIndexPath *)indexPath WithState:(NSString *)state;
- (void)cancelButtonClickWithIndex:(NSIndexPath *)indexPath;
- (void)stopButtonClickWithIndex:(NSIndexPath *)indexPath;
@end

@interface TaskHallEnterpriseCell : UITableViewCell
@property (weak, nonatomic) id <TaskHallEnterpriseCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) UIButton *button;

@end

