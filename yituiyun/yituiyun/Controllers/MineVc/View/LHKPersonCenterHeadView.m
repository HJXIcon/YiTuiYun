//
//  LHKPersonCenterHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKPersonCenterHeadView.h"
#import "LHKButton.h"

@implementation LHKPersonCenterHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)headView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    
//    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
//    if ([userModel.jobType integerValue] != 1){
//        [self.jobTypeBtn setImage:[UIImage imageNamed:@"personcenter_mylog"] forState:UIControlStateNormal];
//        [self.jobTypeBtn setTitle:@"我的日志" forState:UIControlStateNormal];
//    }else{
//        [self.jobTypeBtn setImage:[UIImage imageNamed:@"personcenter_zhigongrenwu"] forState:UIControlStateNormal];
//        [self.jobTypeBtn setTitle:@"职工任务" forState:UIControlStateNormal];
//
//    }
}
- (IBAction)headViewBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(personCenterHeadViewButtonClick:)] ) {
        [self.delegate personCenterHeadViewButtonClick:sender];
    }

}


@end
