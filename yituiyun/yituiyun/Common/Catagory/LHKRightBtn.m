//
//  LHKRightBtn.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKRightBtn.h"

@implementation LHKRightBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    
    self.titleLabel.mj_x = 10;
    self.titleLabel.mj_centerY = self.frame.size.height*0.5;
    
    
    
    self.imageView.mj_x = CGRectGetMaxX(self.titleLabel.frame)+5;
    self.imageView.mj_centerY = self.frame.size.height*0.5;
    
   
}



@end
