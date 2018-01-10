//
//  TaskHallEnterpriseDetailFootView.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskHallEnterpriseDetailFootView.h"

@implementation TaskHallEnterpriseDetailFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.baomingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.shoucangBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}

+(instancetype)footView{
    return ViewFromXib;
}
- (IBAction)shoucangClick:(UIButton *)sender {
    if (self.shoucangblock) {
        self.shoucangblock(sender);
    }
}
- (IBAction)baomingClick:(UIButton *)sender {
    if (self.baomingblock) {
        self.baomingblock(sender);
    }
}

@end
