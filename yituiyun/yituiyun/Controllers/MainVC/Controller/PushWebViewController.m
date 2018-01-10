//
//  PushWebViewController.m
//  荣坤
//
//  Created by 张强 on 15/12/1.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "PushWebViewController.h"

@interface PushWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, copy) NSString *seleUrl;
@end

@implementation PushWebViewController
- (instancetype)initWith:(NSString *)url WithWhere:(NSInteger)where
{
    if (self = [super init]) {
        self.url = url;
        self.where = where;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self showHudInView1:self.navigationController.view hint:@"加载中..."];

    [self setupNav];
    [self setUpWebView];
}

- (void)setupNav{
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBtnDidClick)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)leftBtnDidClick
{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setUpWebView
{
    
    
    self.webView = [[UIWebView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.directionalLockEnabled = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.bounces = NO;
    _webView.scalesPageToFit = YES;
    [_webView setUserInteractionEnabled:YES];

    if (_where == 1) {
        NSURL *URL = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
        [_webView loadRequest:request];
    } else if (_where == 2) {
        [self loadWebPageWithString:_url];
    }
    [self.view addSubview:_webView];
    
    }

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.seleUrl = request.URL.absoluteString;
    return YES;
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[urlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    myLabel.attributedText = attrStr;
    
    NSString *html_str = [NSString stringWithFormat:@"%@", myLabel.text];
    [_webView loadHTMLString:html_str baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    //字体大小
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    //字体颜色
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
