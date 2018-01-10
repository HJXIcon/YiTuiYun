//
//  TaskHallCompanyHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/6.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskHallCompanyHeadView.h"

@implementation TaskHallCompanyHeadView

+(instancetype)headSelectView{
    return [[[NSBundle mainBundle]loadNibNamed:@"TaskHallPersonHeadSelectView" owner:nil options:nil] lastObject];
}

//ing
- (IBAction)needIngBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.needStopBtn.selected = NO;
    self.needFinishBtn.selected = NO;
   
    if ([self.delegate respondsToSelector:@selector(taskHallCompanyHeadViewBtnClick:)] ) {
        [self.delegate taskHallCompanyHeadViewBtnClick:sender];
    }


}

//stop
- (IBAction)needStopBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.needingBtn.selected = NO;
    self.needFinishBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(taskHallCompanyHeadViewBtnClick:)] ) {
        [self.delegate taskHallCompanyHeadViewBtnClick:sender];
    }

}

//finish
- (IBAction)needFinishBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.needStopBtn.selected = NO;
    self.needingBtn.selected = NO;
    if ([self.delegate respondsToSelector:@selector(taskHallCompanyHeadViewBtnClick:)] ) {
        [self.delegate taskHallCompanyHeadViewBtnClick:sender];
    }


}

@end
