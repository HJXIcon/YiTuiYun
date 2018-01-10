//
//  TaskHallPersonHeadSelectView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskHallPersonHeadSelectView.h"

@implementation TaskHallPersonHeadSelectView



+(instancetype)headSelectView{
    return [[[NSBundle mainBundle]loadNibNamed:@"TaskHallPersonHeadSelectView" owner:nil options:nil] firstObject];
}


#pragma mark--btn的点击事件

- (IBAction)taskBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.historyTaskbtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(mytaskBtnToClick:)]) {
        [self.delegate mytaskBtnToClick:sender];
    }
}
- (IBAction)historyBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.taskBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(myhistorytaskBtnToClick:)]) {
        [self.delegate myhistorytaskBtnToClick:sender];
    }
    
}

@end
