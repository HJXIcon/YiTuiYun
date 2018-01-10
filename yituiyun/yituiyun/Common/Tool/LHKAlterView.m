//
//  LHKAlterView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKAlterView.h"

@interface LHKAlterView ()
@property (weak, nonatomic) IBOutlet UIView *panView;

@end

@implementation LHKAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)alterView{
    return ViewFromXib;
}

-(void)awakeFromNib{
    self.alterView.layer.cornerRadius = 5;
    self.alterView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelcaozuo)];
    [self.panView addGestureRecognizer:tap];
}

-(void)cancelcaozuo{
    if (self.cancelblock) {
        self.cancelblock(self);
    }else{
        [self removeFromSuperview];
    }

}

- (IBAction)oneCancelBtnClick:(id)sender {
    self.cancelblock(self);
}

- (IBAction)oneSureBtnClick:(id)sender {
    self.makesurelblock(self);
}
- (IBAction)TwoBtnClick:(id)sender {
    self.makesurelblock(self);
}

+(instancetype)alterViewWithTitle:(NSString *)titel andDesc:(NSString *)desc WithCancelBlock:(CancelBlock)cancelblock WithMakeSure:(MakeSureBlock)makesureblock{
    
    LHKAlterView *alterView = [LHKAlterView alterView];
    alterView.twoSureBtn.hidden = YES;
    alterView.frame = [UIScreen mainScreen].bounds;
    alterView.oneLabel.text = titel;
    alterView.twoLabel.text = desc;
    alterView.cancelblock = cancelblock;
    alterView.makesurelblock = makesureblock;
   
    return alterView;
}

+(instancetype)alterViewWithTitle:(NSString *)titel andDesc:(NSString *)desc WithMakeSure:(MakeSureBlock)makesureblock{
    
    LHKAlterView *alterView = [LHKAlterView alterView];
    alterView.frame = [UIScreen mainScreen].bounds;
    alterView.oneLabel.text = titel;
    alterView.twoLabel.text = desc;
    alterView.oneCancelBtn.hidden = YES;
    alterView.oneSureBtn.hidden = YES;

    alterView.makesurelblock = makesureblock;
    
    return alterView;
}


@end
