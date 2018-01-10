//
//  TaskDetailSectionHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailSectionHeadView : UIView
+(instancetype)sectionHeadView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsSubLabel;

@property (weak, nonatomic) IBOutlet UIView *fenjieLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiedanLabel;
@property (weak, nonatomic) IBOutlet UILabel *chengdanLabel;

@end
