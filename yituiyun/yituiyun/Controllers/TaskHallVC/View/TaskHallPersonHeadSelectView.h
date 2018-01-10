//
//  TaskHallPersonHeadSelectView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskHallPersonHeadSelectViewDelegate <NSObject>

-(void)mytaskBtnToClick:(UIButton *)btn;
-(void)myhistorytaskBtnToClick:(UIButton *)btn;


@end

@interface TaskHallPersonHeadSelectView : UIView
+(instancetype)headSelectView;

@property (weak, nonatomic) IBOutlet UIButton *taskBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyTaskbtn;
/**代理 */
@property(nonatomic,assign)id<TaskHallPersonHeadSelectViewDelegate> delegate;

@end
