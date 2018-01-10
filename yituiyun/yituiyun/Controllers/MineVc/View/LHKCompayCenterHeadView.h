//
//  LHKCompayCenterHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/22.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHKCompayCenterHeadViewDelegate <NSObject>

-(void)compayCenterHeadViewButtonClick:(UIButton *)btn;

@end

@interface LHKCompayCenterHeadView : UIView
+(instancetype)headView;
@property(nonatomic,assign)id<LHKCompayCenterHeadViewDelegate> delegate;

@end
