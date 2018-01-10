//
//  EFeedbackViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EFeedbackViewController.h"
#import "JXPlaceholderTextView.h"
#import "EMineViewModel.h"

/// 来限制最大输入只能500个字符
#define MAX_LIMIT_NUMS  500

@interface EFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) JXPlaceholderTextView *textView;
@property (nonatomic, strong) UILabel *textNumLabel;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation EFeedbackViewController

#pragma mark - *** lazy load
- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [JXFactoryTool creatButton:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"提交" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(sureAction:)];
        _sureBtn.centerX = self.view.centerX;
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        _sureBtn.cornerRadius = E_RealHeight(25);
        [_sureBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _sureBtn;
}

- (UILabel *)textNumLabel{
    if (_textNumLabel == nil) {
        _textNumLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#505050"] text:@"0/500" textAlignment:0];
    }
    return _textNumLabel;
}

- (JXPlaceholderTextView *)textView{
    if (_textView == nil) {
        _textView = [[JXPlaceholderTextView alloc]init];
        _textView.placeholder = @"请输入你的意见反馈";
        _textView.placeholderColor = [UIColor colorWithHexString:@"#b2b2b2"];
        _textView.delegate = self;
    }
    return _textView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    
    /// textView光标起点
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(25));
        make.right.mas_equalTo(-E_RealWidth(25));
        make.top.mas_equalTo(E_RealHeight(24) + E_StatusBarAndNavigationBarHeight);
        make.height.mas_equalTo(E_RealHeight(185));
    }];
    
    [self.view addSubview:self.textNumLabel];
    [self.textNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.textView);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(E_RealHeight(10));
    }];
    
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(300), E_RealHeight(50)));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(E_RealHeight(79));
    }];
    
}


#pragma mark - *** Actions
- (void)sureAction:(UIButton *)button{
    if (kStringIsEmpty(self.textView.text)) {
        return [self showHint:@"请输入反馈内容"];
    }
    [EMineViewModel feedbackWithContent:self.textView.text completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - *** UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.textNumLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,textView.text.length),MAX_LIMIT_NUMS];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0){
        return YES;
    }
    else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

@end
