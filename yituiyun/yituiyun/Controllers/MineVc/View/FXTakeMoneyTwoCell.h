//
//  FXTakeMoneyCell.h
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXTakeMoneyModel.h"
@protocol FXTakeMoneyTwoCellDelegate <NSObject>

- (void)buttonClickWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface FXTakeMoneyTwoCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id <FXTakeMoneyTwoCellDelegate> delegate;
@property (nonatomic, strong) FXTakeMoneyModel *takeMoneyModel;

+ (instancetype)takeMoneyCellWithTableView:(UITableView *)tableView;

@end
