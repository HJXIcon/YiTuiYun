//
//  JianZhiFistCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiFistCell.h"

@implementation JianZhiFistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.listBtn.layer.cornerRadius = 3;
    self.listBtn.clipsToBounds = YES;
    self.listBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.listBtn.layer.borderWidth = 1;
    [self.descTextField addTarget:self action:@selector(descTextField:) forControlEvents:UIControlEventEditingChanged];
}


- (void)descTextField:(UITextField *)sender {
//    NSLog(@"----%@",sender.text);
   
    if (self.textfieldblock) {
        
        self.textfieldblock(sender.text);
    }
}
- (IBAction)listBtnClick:(UIButton *)sender {
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.listblock) {
        self.listblock(sender);
    }
}
- (IBAction)descBtnClick:(UIButton *)sender {
   [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.addressblock) {
//        NSLog(@"----");
        self.addressblock(sender);
    }
}

@end
