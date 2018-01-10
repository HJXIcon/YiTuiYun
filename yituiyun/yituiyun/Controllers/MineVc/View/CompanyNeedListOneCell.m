//
//  CompanyNeedListOneCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/17.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyNeedListOneCell.h"

@interface CompanyNeedListOneCell ()


@end

@implementation CompanyNeedListOneCell
- (IBAction)deleteBtnClick:(id)sender {
    
    if ([_model.status isEqualToString:@"1"] || [_model.status isEqualToString:@"4"]) {//删除
        if (self.onedeleteblock) {
            self.onedeleteblock();
        }
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cancelBtn.layer.cornerRadius = 3;
    self.cancelBtn.clipsToBounds  = YES;
    self.deleteBtn.layer.cornerRadius = 3;
    self.deleteBtn.clipsToBounds  = YES;

    self.againPulishOrPay.layer.cornerRadius = 3;
    self.againPulishOrPay.clipsToBounds = YES;
    
    
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = UIColorFromRGBString(@"0xaaaaaa").CGColor;
    
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = UIColorFromRGBString(@"0xaaaaaa").CGColor;
}

- (void)setModel:(CompanyNeedListModel *)model{
    _model = model;
    if ([model.status isEqualToString:@"3"]) {
        [self.againPulishOrPay setTitle:@"去支付" forState:UIControlStateNormal];
        self.cancelBtn.hidden = NO;
        self.againPulishOrPay.hidden = NO;
        self.deleteBtn.hidden = YES;
        

        
        
    }
    if ([model.status isEqualToString:@"1"] || [model.status isEqualToString:@"4"]) {
     
        self.cancelBtn.hidden = YES;
        self.againPulishOrPay.hidden = YES;
        self.deleteBtn.hidden = NO;
        
        

    }
    
    
}

- (IBAction)cnacelTaskClick:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    

    
    
}
- (IBAction)againPublishOrPay:(id)sender {
     //待付款
        if (self.agin_payBlock) {
            self.agin_payBlock();
        }

    
}

@end
