//
//  FXTakeMoneyCell.h
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXTakeMoneyModel.h"
#import "CardListModel.h"
@protocol FXTakeMoneyCellDelegate <NSObject>

- (void)buttonClickWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface FXTakeMoneyCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id <FXTakeMoneyCellDelegate> delegate;
@property (nonatomic, strong) CardListModel *takeMoneyModel;


+ (instancetype)takeMoneyCellWithTableView:(UITableView *)tableView;

@end
