//
//  ChooseImageCell.h
//  tongmenyiren
//
//  Created by 张强 on 16/9/14.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseImageCellDelegate <NSObject>

- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath;
- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface ChooseImageCell : UITableViewCell
@property (nonatomic,weak) id <ChooseImageCellDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,assign) CGFloat height;
@property (strong, nonatomic) UILabel *nameLabel;


+ (ChooseImageCell *)cellWithTableView:(UITableView*)tableView;
- (void)makeView;
- (void)readOnlyMakeView;

@end
