//
//  FXUpLoadImageCell.h
//  yituiyun
//
//  Created by fx on 16/11/9.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXUpLoadImageCellDelegate <NSObject>

- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath;
- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface FXUpLoadImageCell : UITableViewCell

@property (nonatomic, assign) id<FXUpLoadImageCellDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,assign) CGFloat height;
@property (strong, nonatomic) UILabel *nameLabel;
@property (nonatomic, assign) NSInteger maxNum;

+ (FXUpLoadImageCell *)cellWithTableView:(UITableView*)tableView;
- (void)makeView;
- (void)readOnlyMakeView;
@end
