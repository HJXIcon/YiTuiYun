//
//  AddOrderView.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "AddOrderView.h"

@implementation AddOrderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)orderView{
    return ViewFromXib;
}

- (IBAction)numberTextChange:(UITextField *)sender {
    
    
    NSString *money = sender.text;
    if (sender.text.length>4) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [SVProgressHUD showErrorWithStatus:@"超过最大数量"];
        
        money = [money substringToIndex:4];
        self.numberTextField.text = money;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }
    if (self.numberblock) {
        self.numberblock(money);
    }
}
- (IBAction)priceTextFieldClick:(UITextField *)sender {
    
    if (self.priceblock) {
        self.priceblock(sender.text);
    }
}


@end
