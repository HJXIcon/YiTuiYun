//
//  MineTableViewCell.h
//  dongmibangshou
//
//  Created by LUKHA_Lu on 16/2/17.
//  Copyright © 2016年 KNKane. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MineTableViewCellDelegate <NSObject>

- (void)longPressCellWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MineTableViewCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id <MineTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detaiLabel;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *lineView;
@property(nonatomic,strong) UILabel * jianzhinumberLabel;
@end
