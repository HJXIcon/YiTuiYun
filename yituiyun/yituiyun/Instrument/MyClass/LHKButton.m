//
//  LHKButton.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKButton.h"

@implementation LHKButton

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.center = CGPointMake(midX, midY + 15);
    self.imageView.center = CGPointMake(midX, midY - 20);
    
//    [self.titleLabel sizeToFit];
    
}


@end
