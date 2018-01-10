//
//  VersionUpNormalView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "VersionUpNormalView.h"

@implementation VersionUpNormalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)normalView{
    return [[[NSBundle mainBundle]loadNibNamed:@"VersionView" owner:nil options:nil] firstObject];
}
- (IBAction)tishibtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [ZQ_AppCache saveVersion_tishi];
        [self.cancelBtn setTitleColor:UIColorFromRGBString(@"0x767676") forState:UIControlStateNormal];
    }else{
        [ZQ_AppCache clearVersionTishi];
                [self.cancelBtn setTitleColor:UIColorFromRGBString(@"0xc3c3c3") forState:UIControlStateNormal];
    }
    
}

- (IBAction)cancelBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(normalViewBtnClick:)]) {
        [self.delegate normalViewBtnClick:sender];
    }
}

- (IBAction)updateBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(normalViewBtnClick:)]) {
        [self.delegate normalViewBtnClick:sender];
    }

}



@end
