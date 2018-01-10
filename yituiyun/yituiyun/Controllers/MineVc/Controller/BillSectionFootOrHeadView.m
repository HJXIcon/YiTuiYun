//
//  BillSectionFootOrHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BillSectionFootOrHeadView.h"

@implementation BillSectionFootOrHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.panoneLabel.layer.cornerRadius = 10;
    self.panoneLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.panoneLabel.layer.borderWidth = 1;
    
}

+(instancetype)footOrHeadView{
    return ViewFromXib;
}

@end
