//
//  EWebViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EWebViewController.h"
#import <WebKit/WebKit.h>

@interface EWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *web;
@property (nonatomic, strong) UILabel *URLLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation EWebViewController

#pragma mark - *** lazy load
- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, E_StatusBarAndNavigationBarHeight, kScreenW, 2)];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"ff9000"];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *js = @"document.documentElement.style.webkitUserSelect='none';" ;
    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    NSString *js2 = @"document.documentElement.style.webkitTouchCallout='none';";
    WKUserScript *script2 = [[WKUserScript alloc]initWithSource:js2 injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
   
    // 自适应屏幕宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUserScript];
    [config.userContentController addUserScript:script];
    [config.userContentController addUserScript:script2];
    
    
    _web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    _web.navigationDelegate = self;
    _web.backgroundColor = [UIColor clearColor];
    _web.scrollView.showsVerticalScrollIndicator = NO;
    _web.scrollView.directionalLockEnabled = YES;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.scrollView.bounces = NO;
    _web.scrollView.alwaysBounceHorizontal = NO;
    
    NSURL *URL = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_web loadRequest:request];
    [self.view addSubview:_web];
    
    /// 进度条
    [self.view addSubview:self.progressView];
    [_web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.web.frame = self.view.bounds;
}

- (void)dealloc {
    [self.web removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter]postNotificationName:ReloadHomeDataAfterScanNotificationName object:nil];
}

#pragma mark - *** KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = NO;
        self.progressView.progress = self.web.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




#pragma mark - <UIWebViewDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideHud];
    [self showHudInView1:self.view hint:@"加载中..."];
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hideHud];
    
    //获取网页title
    NSString *htmlTitle = @"document.title";
    
    [webView evaluateJavaScript:htmlTitle completionHandler:^(NSString *title, NSError * _Nullable error) {
        if (!kStringIsEmpty(title)) {
            self.navigationItem.title = title;
        }
    }];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHud];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self showFailLoadView];
    if (self.isShowURLWhenFail) {
        self.URLLabel.text = self.urlString;
    }
    [self hideHud];
    [self showHint:@"加载失败,请重试"];
    
}


/// 加载失败
- (void)showFailLoadView{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 168) {
            [obj removeFromSuperview];
        }
    }];
    
    UIView *failLoadView = [[UIView alloc]initWithFrame:self.view.bounds];
    failLoadView.tag = 168;
    failLoadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:failLoadView];
    [self.view bringSubviewToFront:failLoadView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadAction)];
    [failLoadView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"home_meiwang"];
    [failLoadView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(failLoadView).offset(E_RealHeight(175));
        make.centerX.mas_equalTo(failLoadView);
        make.size.mas_equalTo(CGSizeMake(95 * 0.5, 32));
    }];
    
    UILabel *label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"#383838"] text:@"无法打开网页" textAlignment:NSTextAlignmentCenter];
    [failLoadView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(failLoadView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(E_RealHeight(26));
    }];
    
    UILabel *reloadLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"#a7a7a7"] text:@"点击空白处刷新" textAlignment:NSTextAlignmentCenter];
    [failLoadView addSubview:reloadLabel];
    [reloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(failLoadView);
        make.top.mas_equalTo(label.mas_bottom).offset(E_RealHeight(15));
    }];

    self.URLLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"#a7a7a7"] text:@"" textAlignment:NSTextAlignmentCenter];
    self.URLLabel.numberOfLines = 0;
    [failLoadView addSubview:self.URLLabel];
    [self.URLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(failLoadView);
        make.top.mas_equalTo(reloadLabel.mas_bottom).offset(E_RealHeight(15));
        make.left.mas_equalTo(failLoadView).offset(30);
        make.right.mas_equalTo(failLoadView).offset(-30);
    }];
    
}

- (void)reloadAction{
    NSURL *URL = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [self.web loadRequest:request];
}


@end
