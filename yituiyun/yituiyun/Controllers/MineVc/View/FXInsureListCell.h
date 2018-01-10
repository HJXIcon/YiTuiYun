//
//  FXInsureListCell.h
//  yituiyun
//
//  Created by fx on 16/12/3.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXInsureListModel.h"

@protocol FXInsureListCellDelegate <NSObject>

/** 图片点击预览 */
- (void)imageClickWithIndex:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath;


@end
@interface FXInsureListCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic, strong) FXInsureListModel *insureModel;
@property (nonatomic, assign) id<FXInsureListCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
