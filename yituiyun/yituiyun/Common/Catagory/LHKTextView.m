//
//  LHKTextView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/18.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKTextView.h"

@interface LHKTextView ()
@end

@implementation LHKTextView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.label.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.label];
}

-(void)setPlacolder:(NSString *)placolder{
    _placolder = placolder;
    self.label.text = self.placolder;
}
-(void)setPlacolderColor:(UIColor *)placolderColor{
    _placolderColor = placolderColor;
    self.label.textColor = _placolderColor;
}


@end
