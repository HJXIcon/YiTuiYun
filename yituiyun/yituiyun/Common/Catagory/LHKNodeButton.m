//
//  LHKNodeButton.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKNodeButton.h"

@implementation LHKNodeButton

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
    
    self.imageView.mj_y = 14;
    self.imageView.mj_centerX = self.frame.size.width*0.5;
    
    self.titleLabel.mj_y = self.imageView.mj_h+16;
    self.titleLabel.mj_centerX = self.frame.size.width*0.5;
    
}

@end
