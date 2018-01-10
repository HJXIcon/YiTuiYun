//
//  TaskDetailNavView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskDetailNavView.h"

@interface TaskDetailNavView ()
/**上一个 */
@property(nonatomic,strong) UIButton * lastbtn;
@end

@implementation TaskDetailNavView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.oneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.oneBtn.layer.borderWidth = 1;
    
    self.twoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.twoBtn.layer.borderWidth = 1;
    self.lastbtn = self.oneBtn;
    
}
- (IBAction)TaskDetailNav:(UIButton *)sender {
    
    if (sender.selected || sender == self.lastbtn) {
        return ;
    }
    self.lastbtn.selected = NO;
    sender.selected = !sender.selected;
    
    self.lastbtn = sender;
    
    if (self.nav_block) { // 101 102
        self.nav_block(sender.tag - 101);
    }
}
+(instancetype)navView{
    return ViewFromXib;
}
@end
