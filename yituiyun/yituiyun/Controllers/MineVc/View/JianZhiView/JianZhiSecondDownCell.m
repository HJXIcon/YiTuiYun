//
//  JianZhiSecondDownCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiSecondDownCell.h"

@implementation JianZhiSecondDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.listBtn.layer.cornerRadius = 3;
    self.listBtn.layer.borderColor = UIColorFromRGBString(@"0xe1e1e1").CGColor;
    self.listBtn.layer.borderWidth = 1;
    self.listBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)textField1Click:(UITextField *)sender {
    if (self.textfieldblock1) {
        self.textfieldblock1(sender.text);
    }
}
- (IBAction)textField2Click:(UITextField *)sender {
    if (self.textfieldblock2) {
        self.textfieldblock2(sender.text);
    }
}
- (IBAction)listBtnClick:(UIButton *)sender {
    if (self.sexblock) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        self.sexblock(sender);
    }
}

@end
