//
//  JXShowAgreementViewController.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXShowAgreementViewController.h"
#import <WebKit/WebKit.h>

@interface JXShowAgreementViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *web;

@end

@implementation JXShowAgreementViewController

#pragma mark - Cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    
    
    NSString *js = @"document.documentElement.style.webkitUserSelect='none';" ;
    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    NSString *js2 = @"document.documentElement.style.webkitTouchCallout='none';";
    WKUserScript *script2 = [[WKUserScript alloc]initWithSource:js2 injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    [config.userContentController addUserScript:script];
    [config.userContentController addUserScript:script2];
    [config.userContentController addScriptMessageHandler:self name:@"observe"];
    
    
    _web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) configuration:config];
    _web.navigationDelegate = self;
    _web.backgroundColor = [UIColor clearColor];
    _web.scrollView.showsVerticalScrollIndicator = NO;
    _web.scrollView.directionalLockEnabled = YES;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.scrollView.bounces = NO;
    
    NSURL *URL;
    switch (self.style) {
        case JXShowAgreementUserUse:
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api.php?m=h5&mid=8&id=1&f=userAgreement", kHost]];
        }
            break;
            
        case JXShowAgreementFulltimeUser:
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", @"http://dev.yituiyun.cn/api.php?m=h5.agreement"]];
        }
            break;
            
        case JXShowAgreementFullDay:
        {
            NSString *user_id = [ZQ_AppCache userInfoVo].userID;
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api.php?m=h5.hetong&user_id=%@", kHost,user_id]];
        }
            break;
            
        default:
            break;
    }
    
//    NSURL *URL = self.style == JXShowAgreementUserUse ? [NSURL URLWithString:[NSString stringWithFormat:@"%@api.php?m=h5&mid=8&id=1&f=userAgreement", kHost]] : [NSURL URLWithString:[NSString stringWithFormat:@"%@", @"http://dev.yituiyun.cn/api.php?m=h5.agreement"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_web loadRequest:request];
    [self.view addSubview:_web];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
}

#pragma mark - Load Data
- (void)getAgreement
{
    __weak JXShowAgreementViewController *weakSelf = self;
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


- (void)loadWebPageWithString:(NSString*)urlString
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[urlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    myLabel.attributedText = attrStr;
    
    NSString *html_str = [NSString stringWithFormat:@"%@", myLabel.text];
    [_web loadHTMLString:html_str baseURL:nil];
}

#pragma mark - <UIWebViewDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideHud];
    [self showHudInView1:self.view hint:@"加载中..."];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideHud];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHud];
    [self showHint:@"加载失败,请重试"];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    [self hideHud];
    [self showHint:@"加载失败,请重试"];
}

@end
