//
//  ViewController.m
//  PDF_Demo
//
//  Created by NIT on 15-3-30.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *web;
@end

@implementation AgreementViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);

    [self setupNav];
//    [self getAgreement];
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)];
    _web.delegate = self;
    _web.backgroundColor = [UIColor clearColor];
    _web.scrollView.showsVerticalScrollIndicator = NO;
    _web.scrollView.directionalLockEnabled = YES;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.scrollView.bounces = NO;
    NSURL *URL = self.isUserUse ? [NSURL URLWithString:[NSString stringWithFormat:@"%@api.php?m=h5&mid=8&id=1&f=userAgreement", kHost]] : [NSURL URLWithString:[NSString stringWithFormat:@"%@", @"http://dev.yituiyun.cn/api.php?m=h5.agreement"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_web loadRequest:request];
    [self.view addSubview:_web];

}

- (void)setupNav
{
    
    [self.navigationController.navigationBar setTranslucent:YES];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.text = self.isUserUse ? @"用户服务协议" : @"平台服务协议";
    label.textColor = kUIColorFromRGB(0xf16156);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"backRed" selectedImage:@"backRed" target:self action:@selector(leftButtonItem)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 64, ZQ_Device_Width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)getAgreement
{
    __weak AgreementViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=data.contents"];
    [HFRequest requestWithUrl:URL parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 1) {
            [weakSelf loadWebPageWithString:[NSString stringWithFormat:@"%@", responseObject[@"userAgreement"]]];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试" yOffset:-200];
    }];
    
}


- (void)leftButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[urlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    myLabel.attributedText = attrStr;
    
    NSString *html_str = [NSString stringWithFormat:@"%@", myLabel.text];
    [_web loadHTMLString:html_str baseURL:nil];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self hideHud];
    [self showHudInView1:self.view hint:@"加载中..."];
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
