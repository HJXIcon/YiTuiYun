//
//  GuideCell.h
//  yituiyun
//
//  Created by 张强 on 2016/12/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GuideCellDelegate <NSObject>

- (void)buttonClick;

@end
@interface GuideCell : UICollectionViewCell
@property (nonatomic, assign) id <GuideCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end
