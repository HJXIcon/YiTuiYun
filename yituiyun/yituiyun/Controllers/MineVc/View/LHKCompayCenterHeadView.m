//
//  LHKCompayCenterHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/22.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKCompayCenterHeadView.h"

@implementation LHKCompayCenterHeadView
+(instancetype)headView{
    return [[[NSBundle mainBundle]loadNibNamed:@"LHKPersonCenterHeadView" owner:nil options:nil] lastObject];
}
- (IBAction)headViewBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(compayCenterHeadViewButtonClick:)] ) {
        [self.delegate compayCenterHeadViewButtonClick:sender];
    }
    
}


@end
