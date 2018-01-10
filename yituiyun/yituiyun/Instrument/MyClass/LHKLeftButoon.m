//
//  LHKLeftButoon.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/25.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKLeftButoon.h"

@implementation LHKLeftButoon

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
    
    self.titleLabel.mj_x = 0;
    self.titleLabel.mj_centerY = self.frame.size.height*0.5;
    
    self.imageView.mj_x = self.titleLabel.mj_w+2;
    self.imageView.mj_centerY = self.frame.size.height*0.5;
}

-(void)setHighlighted:(BOOL)highlighted{
    
}
@end
