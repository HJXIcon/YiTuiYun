//
//  TaskHallCompanyHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/7/6.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskHallCompanyHeadViewDelegate <NSObject>

-(void)taskHallCompanyHeadViewBtnClick:(UIButton *)btn;

@end

@interface TaskHallCompanyHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *needingBtn;
@property (weak, nonatomic) IBOutlet UIButton *needStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *needFinishBtn;

@property(nonatomic,assign)id<TaskHallCompanyHeadViewDelegate>  delegate;

+(instancetype)headSelectView;
@end
