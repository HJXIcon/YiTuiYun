//
//  CompanyTwoFootView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyTwoFootView.h"

@implementation CompanyTwoFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)footView{
    return [[[NSBundle mainBundle]loadNibNamed:@"CompanyPulishTwoFoodView" owner:nil options:nil]lastObject];
}
- (IBAction)addDatasClick:(id)sender {
    if (self.add_block) {
        self.add_block();
    }
}
@end
