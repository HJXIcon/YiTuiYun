//
//  InformationDetailViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "InformationModel.h"

@interface InformationDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) InformationModel *model;
@property (nonatomic, strong) InformationModel *model1;
@property (nonatomic, strong) UIButton *collectionButton;
@end

@implementation InformationDetailViewController
- (instancetype)initWithInformationModel:(InformationModel *)informationModel
{
    self = [super init];
    if (self) {
        self.model1 = informationModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[InformationModel alloc] init];
    [self setupNav];
    [self setUpScrollView];
    [self dataArrayFromNetwork];
    [MobClick event:@"newDetailsNums"];

}

#pragma mark 请求网络数据
- (void)dataArrayFromNetwork {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak InformationDetailViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"newsId"] = weakSelf.model1.InfoId;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.newsDetail"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        NSDictionary *dic = responseObject[@"rst"];
        if ([responseObject[@"errno"] intValue] == 0) {
            weakSelf.model.title = [NSString stringWithFormat:@"%@", dic[@"title"]];
            weakSelf.model.time = [NSString stringWithFormat:@"%@", dic[@"inputtime"]];
            weakSelf.model.InfoId = [NSString stringWithFormat:@"%@", dic[@"newsId"]];
            weakSelf.model.isCoollection = [NSString stringWithFormat:@"%@", dic[@"isCollect"]];
            weakSelf.model.url = [NSString stringWithFormat:@"%@api.php?m=h5&mid=1&id=%@&f=content", kHost, weakSelf.model.InfoId];
            
            [weakSelf setUpHeaderView];
            [weakSelf setUpWebView];
        } else {
            [weakSelf hideHud];
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"资讯详情";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpScrollView{
    //创建一个UIScrollView添加到当前视图上
    self.scrollView = [[UIScrollView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64)];
    _scrollView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _scrollView.contentOffset = CGPointMake(0, 0.1);
    _scrollView.scrollEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}

#pragma mark - HeaderView()
- (void)setUpHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 10, ZQ_Device_Width, 90)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, ZQ_Device_Width - 44, 90 - 45)];
    label.text = _model.title;
    label.textColor = kUIColorFromRGB(0x404040);
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //时间戳转换成时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_model.time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 90 - 35, ZQ_Device_Width - 44, 25)];
    label1.text = confromTimespStr;
    label1.textColor = kUIColorFromRGB(0x808080);
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label1];
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([_model.isCoollection isEqualToString:@"1"]) {
        [_collectionButton setImage:[UIImage imageNamed:@"collectionYes"] forState:UIControlStateNormal];
        
    } else {
        [_collectionButton setImage:[UIImage imageNamed:@"collectionNo"] forState:UIControlStateNormal];
    }
    _collectionButton.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 32, 90 - 35, 35, 35);
    [_collectionButton addTarget:self action:@selector(collectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_collectionButton];
}

#pragma mark - WebView()
- (void)setUpWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:ZQ_RECT_CREATE(0, 110, ZQ_Device_Width, 0.1)];
    _webView.delegate = self;
    _webView.backgroundColor = kUIColorFromRGB(0xffffff);
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.directionalLockEnabled = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.bounces = NO;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setScrollEnabled:NO];
    NSURL *url = [NSURL URLWithString:_model.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [_webView loadRequest:request];
    [_scrollView addSubview:_webView];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *htmlHeightStr = [_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    NSInteger htmlHeight = [htmlHeightStr integerValue];

    webView.frame = ZQ_RECT_CREATE(0, 110, ZQ_Device_Width, (CGFloat)htmlHeight);
    _scrollView.contentSize = CGSizeMake(ZQ_Device_Width, 110 + htmlHeight);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHud];
    [self showHint:@"加载失败,请重试"];
}

- (void)collectionButtonClick
{
    __weak InformationDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"did"] = _model.InfoId;
    params[@"uid"] = model.userID;
    params[@"type"] = @"1";
    if ([_model.isCoollection isEqualToString:@"1"]) {
        params[@"status"] = @"0";
    } else {
        params[@"status"] = @"1";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.collect"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            if ([_model.isCoollection isEqualToString:@"1"]) {
                _model.isCoollection = @"0";
                [_collectionButton setImage:[UIImage imageNamed:@"collectionNo"] forState:UIControlStateNormal];
                [weakSelf showHint:@"已取消收藏"];
            } else {
                _model.isCoollection = @"1";
                [_collectionButton setImage:[UIImage imageNamed:@"collectionYes"] forState:UIControlStateNormal];
                [weakSelf showHint:@"已收藏"];
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
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
