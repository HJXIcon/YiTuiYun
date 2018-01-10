//
//  FistProjectSectionView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FistProjectSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIView *fenjieLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLable;
@property (weak, nonatomic) IBOutlet UILabel *jiedanLabel;

@property (weak, nonatomic) IBOutlet UILabel *chengdanLabel;

@property (weak, nonatomic) IBOutlet UILabel *notagsTimeLabel;

+(instancetype)sectionView;
@end
