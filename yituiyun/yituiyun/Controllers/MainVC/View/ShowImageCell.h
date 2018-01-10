//
//  ShowImageCell.h
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowImageCellDelegate <NSObject>

- (void)buttonClick;

@end

@interface ShowImageCell : UICollectionViewCell
@property (nonatomic, assign) id <ShowImageCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@end
