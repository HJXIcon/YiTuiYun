//
//  CompanyTwoSectionView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyTwoSectionView.h"

@implementation CompanyTwoSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)sectionView{
    return [[[NSBundle mainBundle]loadNibNamed:@"CompanyPulishTwoFoodView" owner:nil options:nil]firstObject];
}



@end
