//
//  LHKMapPopView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKMapPopView.h"

@implementation LHKMapPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)popView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}
-(void)setAnnotation:(LHKMapAnnotation *)annotation{
    
    _annotation = annotation;
    
    self.logoView.image = nil;
    self.titleLabel.text = annotation.title;
    self.telLabel.text = annotation.tel;
    self.addressLabel.text = annotation.address;
    NSString *imagePath = [NSString imagePathAddPrefix:annotation.imagePath];
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"logo"]];
//    NSLog(@"%@",self.logoView.image);
        
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

}
- (IBAction)popViewBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapPopViewBtnClick:)] ) {
        [self.delegate mapPopViewBtnClick:self.annotation];
    }
}



@end
