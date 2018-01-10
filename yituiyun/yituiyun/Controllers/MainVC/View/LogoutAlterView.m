//
//  LogoutAlterView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LogoutAlterView.h"

@implementation LogoutAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)alterView{
    return ViewFromXib;
    
    
}
- (IBAction)btnClick:(UIButton *)sender {
    
    if (self.l_block) {
        self.l_block();
//        self.layer.cornerRadius = 10;
//        self.clipsToBounds = YES;
    }
}

@end
