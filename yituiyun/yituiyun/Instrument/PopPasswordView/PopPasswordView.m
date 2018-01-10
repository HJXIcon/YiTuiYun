//
//  PopPasswordView.m
//  TTPassword
//
//  Created by ttcloud on 16/6/20.
//  Copyright © 2016年 ttcloud. All rights reserved.
//

#import "PopPasswordView.h"
@implementation PopPasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.showView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _showView.backgroundColor = kUIColorFromRGB(0xededed);
        [self addSubview:_showView];
        
        UIButton *disbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        disbtn.frame=CGRectMake(0, 0, 50, 50);

        [disbtn setImage:[UIImage imageNamed:@"shutDown"] forState:UIControlStateNormal];
        disbtn.contentMode=UIViewContentModeScaleAspectFit;
        [disbtn addTarget:self action:@selector(disbtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:disbtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disbtn.frame), 0, ZQ_Device_Width - CGRectGetMaxX(disbtn.frame) * 2, 45)];
        UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
        if ([userInfo.identity integerValue] == 6) {
            label.text = @"输入提现密码";
        } else if ([userInfo.identity integerValue] == 5) {
            label.text = @"输入钱包支付密码";
        }
        label.textColor = kUIColorFromRGB(0x404040);
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [_showView addSubview:label];
        
        UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(label.frame), ZQ_Device_Width, 1)];
        view1.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [_showView addSubview:view1];
        
        self.password = [[TTPasswordView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(view1.frame)+20, ZQ_Device_Width-30, (ZQ_Device_Width-30)/6 - 10)];
        self.password.textField.keyboardType=UIKeyboardTypeNumberPad;
        self.password.elementCount = 6;
        [[self.password layer] setCornerRadius:4];
        [[self.password layer] setMasksToBounds:YES];
        self.password.elementColor=kUIColorFromRGB(0xededed);
        [_showView addSubview:self.password];
        __weak PopPasswordView *weakself = self;
        self.password.passwordBlock = ^(NSString *password) {
            if (password.length==6) {
                if (self.delegate&&[self.delegate respondsToSelector:@selector(useStoreCode:)]) {
                    [weakself.delegate useStoreCode:password];
                }
            }
        };
        
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetButton.frame = CGRectMake(ZQ_Device_Width - 134, CGRectGetMaxY(self.password.frame), 120, 40);
        [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [forgetButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forgotPasswordClick) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:forgetButton];
        
    }
    return self;
}

-(void)disbtnAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(disAction)]) {
        [self.delegate disAction];
    }
    
}

- (void)forgotPasswordClick
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(forgotPasswordClick)]) {
        [self.delegate forgotPasswordClick];
    }
}

-(void)failPassword:(NSNumber *)number
{
//    NSString *str=[NSString stringWithFormat:@"密码错误，您还有%@次机会",number];
//    self.tip.text=str;
//    self.tip.textColor=kUIColorFromRGB(0xff3674);
    [self.password clearText];
    
}
@end

