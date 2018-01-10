//
//  FistProjectSectionView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "FistProjectSectionView.h"

@implementation FistProjectSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)sectionView{
    return [[[NSBundle mainBundle]loadNibNamed:@"FistProjectSectionView" owner:nil options:nil]firstObject];
}

@end
