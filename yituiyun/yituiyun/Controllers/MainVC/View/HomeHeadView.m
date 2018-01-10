//
//  HomeHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "HomeHeadView.h"

@interface HomeHeadView ()
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation HomeHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.searchBtn.layer.cornerRadius= 15;
    self.searchBtn.clipsToBounds = YES;
    self.searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WRadio(250)*0.5);
    
}
+(instancetype)headView{
    return  [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
}
- (IBAction)cityBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headViewcityBtnClick:)]) {
        [self.delegate headViewcityBtnClick:sender];
    }
}
- (IBAction)headViewSearchBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headViewSoSouBtnClick:)]) {
        [self.delegate headViewSoSouBtnClick:sender];
    }
}


@end
