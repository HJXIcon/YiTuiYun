//
//  TaskDetailSectionHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskDetailSectionHeadView.h"

@implementation TaskDetailSectionHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)sectionHeadView{
    return [[[NSBundle mainBundle]loadNibNamed:@"FistProjectSectionView" owner:nil options:nil]lastObject];
}

@end
