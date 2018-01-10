//
//  FillUserAgreementViewController.m
//  yituiyun
//
//  Created by NIT on 15-3-30.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "FillUserAgreementViewController.h"

@interface FillUserAgreementViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *needsName;
@property (nonatomic, assign) BOOL isAgree;
@end

@implementation FillUserAgreementViewController
- (instancetype)initWithCompanyName:(NSString *)companyName WithNeedsName:(NSString *)needsName
{
    self = [super init];
    if (self) {
        self.companyName = companyName;
        self.needsName = needsName;
        self.isAgree = YES;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showHudInView1:self.navigationController.view hint:@"加载中..."];
    
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);

    [self setupNav];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ZQ_Device_Width - 20, 100)];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = kUIColorFromRGB(0x404040);
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    NSString *string = [NSString stringWithFormat:@"        %@    公司(以下简称乙方)就    %@    项目与北京易推云网络科技有限公司(以下简称甲方)在法律允许范围内经双方同意友好达成此协议，以乙方确认提交后生效。", _companyName, _needsName];
    NSMutableAttributedString *countStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:@"公司(以下简称乙方)就"];
    [countStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(4, _companyName.length+8)];
    [countStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(4, _companyName.length+8)];
    [countStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(range.location+range.length, _needsName.length+8)];
    [countStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(range.location+range.length, _needsName.length+8)];
    label.attributedText = countStr;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame), ZQ_Device_Width - 60, 20)];
    label1.text = @"协议内容如下：";
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:label1];
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(label1.frame)+10, self.view.frame.size.width-60, self.view.frame.size.height - 64 - CGRectGetMaxY(label1.frame) - 20 - 104)];
    _web.delegate = self;
    _web.backgroundColor = [UIColor clearColor];
    _web.scrollView.directionalLockEnabled = YES;
    _web.scrollView.bounces = NO;
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api.php?m=h5&mid=8&id=1&f=jobStrategy", kHost]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_web loadRequest:request];
    [self.view addSubview:_web];
    
    [self setupProtocolView];
}

- (void)setupNav
{
    self.title = @"易推云平台使用协议";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 阅读协议
- (void)setupProtocolView{
    UIView *line = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 64 - 104, ZQ_Device_Width, 4)];
    line.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [self.view addSubview:line];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(10, ZQ_Device_Height - 64 - 90, 20, 20);
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"agreement_YES"] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
    
    CGSize describSize = [@"我已经阅读并同意" sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(ZQ_Device_Width, agreeBtn.height)];
    UILabel *describLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeBtn.frame) + 10, agreeBtn.y, describSize.width, agreeBtn.height)];
    describLabel.text = @"我已经阅读并同意";
    describLabel.font = [UIFont systemFontOfSize:16];
    describLabel.textAlignment = NSTextAlignmentCenter;
    describLabel.textColor = kUIColorFromRGB(0x404040);
    [self.view addSubview:describLabel];
    
    CGSize protocolSize = [@"《易推云平台使用协议》" sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(ZQ_Device_Width, describLabel.height)];
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(describLabel.frame), describLabel.y, protocolSize.width, describLabel.height)];
    protocolLabel.text = @"《易推云平台使用协议》";
    protocolLabel.font = [UIFont systemFontOfSize:16];
    protocolLabel.textColor = MainColor;
    [self.view addSubview:protocolLabel];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.frame = CGRectMake(10, CGRectGetMaxY(protocolLabel.frame) + 10, self.view.frame.size.width - 20, 40);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTintColor:kUIColorFromRGB(0xffffff)];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[submitButton layer] setCornerRadius:4];
    [[submitButton layer] setMasksToBounds:YES];
    submitButton.backgroundColor = kUIColorFromRGB(0xf16156);
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)agreeBtnDidClick:(UIButton *)button{
    if (_isAgree == NO) {
        [button setBackgroundImage:[UIImage imageNamed:@"agreement_YES"] forState:UIControlStateNormal];
        _isAgree = YES;
    } else if (_isAgree == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"agreement_NO"] forState:UIControlStateNormal];
        _isAgree = NO;
    }
}

- (void)submitButtonClick:(UIButton *)button{
    
    if (_isAgree == NO) {
        [ZQ_UIAlertView showMessage:@"只有同意此协议后，才可以发布需求" cancelTitle:@"确定"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAgreementWithCompanyName:WithNeedsName:)]) {
        [self.delegate userAgreementWithCompanyName:_companyName WithNeedsName:_needsName];
        [self leftBarButtonItem];
    }
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    //字体大小
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
//    //字体颜色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor='#808080'"];
    // 修改背景颜色
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f1f1f1'"];
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHud];
    [self showHint:@"加载失败,请重试"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
