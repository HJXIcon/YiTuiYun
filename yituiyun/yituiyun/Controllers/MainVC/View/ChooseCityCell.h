//
//  ChooseCityCell.h
//  同门艺人
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseCityCellDelegate;

@interface ChooseCityCell : UITableViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,assign) CGFloat cellHight;//cell的高度
@property (weak, nonatomic) id <ChooseCityCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) UILabel *cityNameLabel;

- (void)btnLayOut;
@end

@protocol ChooseCityCellDelegate <NSObject>

- (void)seleCityButtonClick:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath;

@end
