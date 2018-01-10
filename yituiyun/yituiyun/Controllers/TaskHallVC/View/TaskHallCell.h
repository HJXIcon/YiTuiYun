//
//  TaskHallCell.h
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectModel;
@protocol TaskHallCellDelegate <NSObject>

- (void)startButtonClickWithIndex:(NSIndexPath *)indexPath WithState:(NSString *)state;
- (void)cancelButtonClickWithIndex:(NSIndexPath *)indexPath;
- (void)stopButtonClickWithIndex:(NSIndexPath *)indexPath;

- (void)restartTaskWith:(NSString *)pid wihtT_demanType:(NSString *)t;

@end

@interface TaskHallCell : UITableViewCell
@property (weak, nonatomic) id <TaskHallCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) UIButton *button;

@end

