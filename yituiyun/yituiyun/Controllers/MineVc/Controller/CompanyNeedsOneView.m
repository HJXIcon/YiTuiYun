//
//  CompanyNeedsOneView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyNeedsOneView.h"
#import "NeedDataModel.h"

@implementation CompanyNeedsOneView

- (IBAction)priceTishiClick:(UIButton *)sender {
    if (self.tishiBlock) {
        self.tishiBlock();
    }
}

- (IBAction)deleBtnClick:(UIButton *)sender {
    
    if (self.deleteblock) {
        self.deleteblock(sender);
    }
}
- (IBAction)coverBtnClick:(UIButton *)sender {
    if (self.logoblock) {
        self.logoblock(self.logoBtn);
    }
}

+(instancetype)oneView{
    return ViewFromXib;
}
//任务名称
- (IBAction)textNamCLICK:(UITextField *)sender {
    [NeedDataModel shareInstance].taskName = sender.text;
}
//任务类型
- (IBAction)taskTypeClick:(id)sender {
    if (self.typeBlock) {
        self.typeBlock(sender);
    }
}
- (IBAction)taskPriceClick:(UITextField *)sender {
      [NeedDataModel shareInstance].tasksingle = sender.text;
}
- (IBAction)numberTextField:(UITextField *)sender {
     [NeedDataModel shareInstance].taskNumber = sender.text;
}
- (IBAction)timeSelectClick:(id)sender {
    if (self.timeBlock) {
        self.timeBlock(sender);
    }
}
//logobtnClick
- (IBAction)logobtnClick:(UIButton *)sender {
    
    if (self.logoblock) {
        self.logoblock(sender);
    }
}


@end
