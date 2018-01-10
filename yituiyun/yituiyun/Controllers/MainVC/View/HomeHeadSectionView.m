//
//  HomeHeadSectionView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "HomeHeadSectionView.h"

@interface HomeHeadSectionView ()

/**<#type#> */
@property(nonatomic,strong) UIButton * lastbtn;

@end

@implementation HomeHeadSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lastbtn = _fistBtn;
}
+(instancetype)sectionView{
    return ViewFromXib;
    
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    if (_lastbtn !=sender) {
        _lastbtn.selected = NO;
    }
    sender.selected = !sender.selected;
    self.lastbtn = sender;
    if (self.s_block) {
        self.s_block(sender.tag);
    }
}


@end
