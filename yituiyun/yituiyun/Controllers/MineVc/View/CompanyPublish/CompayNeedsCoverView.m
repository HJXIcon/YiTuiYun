//
//  CompayNeedsCoverView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompayNeedsCoverView.h"

@implementation CompayNeedsCoverView

+(instancetype)coverView{
    return ViewFromXib;
}
- (IBAction)publishBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(compayNeedsCoverViewBtnClick:)]) {
        [self.delegate compayNeedsCoverViewBtnClick:self];
    }
}
- (IBAction)publishJianZhiClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(compayNeedsCoverViewJianZhiBtnClick:)]) {
        [self.delegate compayNeedsCoverViewJianZhiBtnClick:self];
    }

}
@end
