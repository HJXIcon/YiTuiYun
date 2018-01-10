//
//  MyLogCell.h
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InformationModel;
@protocol MyLogCellDelegate <NSObject>

- (void)longPressCellWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyLogCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id <MyLogCellDelegate> delegate;
@property (nonatomic, strong) InformationModel *infoModel;
@property (nonatomic, assign) CGFloat height;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
