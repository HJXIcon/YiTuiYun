//
//  TaskNodeCell.h
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DetailListBlock)();
@class TaskNodeModel;
@protocol TaskNodeCellDelegate <NSObject>

- (void)checkInButtonClickWithIndex:(NSIndexPath *)indexPath;
- (void)uploadButtonClickWithIndex:(NSIndexPath *)indexPath;


@end

@interface TaskNodeCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIButton *checkInButton;
@property (nonatomic, strong) UIButton *uploadButton;
@property (weak, nonatomic) id <TaskNodeCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) TaskNodeModel *model;
@property(nonatomic,copy)DetailListBlock  detialblock;
//状态栏
@property(nonatomic,strong) UILabel * statusLabel;

@property(nonatomic,strong) UILabel * timeLabel;

//状态btn
@property(nonatomic,strong) UIButton * statusBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

