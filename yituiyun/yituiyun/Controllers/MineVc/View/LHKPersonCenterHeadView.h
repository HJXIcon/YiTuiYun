//
//  LHKPersonCenterHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHKButton.h"

@protocol LHKPersonCenterHeadViewDelegate <NSObject>

-(void)personCenterHeadViewButtonClick:(UIButton *)btn;

@end

@interface LHKPersonCenterHeadView : UIView
@property (weak, nonatomic) IBOutlet LHKButton *jobTypeBtn;

@property(nonatomic,assign)id<LHKPersonCenterHeadViewDelegate> delegate;
+(instancetype)headView;
@end
