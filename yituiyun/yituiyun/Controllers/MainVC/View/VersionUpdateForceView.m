//
//  VersionUpdateForceView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "VersionUpdateForceView.h"

@implementation VersionUpdateForceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)forceView{
    return [[[NSBundle mainBundle]loadNibNamed:@"VersionView" owner:nil options:nil] lastObject];
}

- (IBAction)cancelbtnClick:(id)sender {
    
    exit(0);
}

- (IBAction)updateBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(forceViewBtnClick)]) {
        [self.delegate forceViewBtnClick];
    }
}

@end
