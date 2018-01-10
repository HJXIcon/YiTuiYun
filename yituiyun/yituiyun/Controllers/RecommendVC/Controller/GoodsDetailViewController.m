//
//  GoodsDetailViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsModel.h"
#import "SDCycleScrollView.h"
//#import "FXPersonInfoController.h"
#import "JXPersonInfoViewController.h"
#import "FXCompanyInfoController.h"

@interface GoodsDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *numsLabel;
@property (nonatomic, strong) GoodsModel *model;
@property (nonatomic, strong) GoodsModel *model1;
@property (nonatomic, strong) ZQImageAndLabelButton *collectionButton;
@property (nonatomic, strong) UIButton *operationButton;
@end

@implementation GoodsDetailViewController
- (instancetype)initWithGoodsModel:(GoodsModel *)goodsModel
{
    self = [super init];
    if (self) {
        self.model1 = goodsModel;
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
    self.model = [[GoodsModel alloc] init];
    [self setupNav];
    [self setUpScrollView];
    [self dataArrayFromNetwork];
    [MobClick event:@"goodsDetailsNums"];

}

#pragma mark 请求网络数据
- (void)dataArrayFromNetwork {
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    __weak GoodsDetailViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"goodsId"] = weakSelf.model1.goodsId;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.goodsDetail"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        NSDictionary *dic = responseObject[@"rst"];
        if ([responseObject[@"errno"] intValue] == 0) {
            weakSelf.model.title = [NSString stringWithFormat:@"%@", dic[@"title"]];
            weakSelf.model.imageArray = [NSMutableArray arrayWithArray:dic[@"showImages"]];
            weakSelf.model.price = [NSString stringWithFormat:@"%@", dic[@"price"]];
            weakSelf.model.originalPrice = [NSString stringWithFormat:@"%@", dic[@"oldPrice"]];
            weakSelf.model.nums = [NSString stringWithFormat:@"%@", dic[@"joinNum"]];
            weakSelf.model.goodsId = [NSString stringWithFormat:@"%@", dic[@"goodsId"]];
            weakSelf.model.isCollection = [NSString stringWithFormat:@"%@", dic[@"isCollect"]];
            weakSelf.model.phone = [NSString stringWithFormat:@"%@", dic[@"tel"]];
            weakSelf.model.link = [NSString stringWithFormat:@"%@api.php?m=h5&mid=10&id=%@&f=content", kHost, weakSelf.model.goodsId];
            weakSelf.model.isStatus = [NSString stringWithFormat:@"%@", dic[@"status"]];
            weakSelf.model.isAppointment = [NSString stringWithFormat:@"%@", dic[@"isJoin"]];
            [weakSelf setUpHeaderView];
            [weakSelf setUpWebView];
            [weakSelf setUpFooterView];
        } else {
            
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"商品详情";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpScrollView{
    //创建一个UIScrollView添加到当前视图上
    self.scrollView = [[UIScrollView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64 - 50)];
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
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Width/2 + 145)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in _model.imageArray) {
        [array addObject:[NSString stringWithFormat:@"%@%@", kHost, dic[@"url"]]];
    }
    SDCycleScrollView *imagePlayerView = [SDCycleScrollView cycleScrollViewWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Width/2) imageURLsGroup:array where:1];
    imagePlayerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    imagePlayerView.delegate = self;
    imagePlayerView.dotColor = [UIColor whiteColor];
    imagePlayerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [view addSubview:imagePlayerView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, CGRectGetMaxY(imagePlayerView.frame) + 5, ZQ_Device_Width - 24, 50)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.numberOfLines = 2;
    nameLabel.text = _model.title;
    nameLabel.textColor = kUIColorFromRGB(0x404040);
    [view addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, CGRectGetMaxY(nameLabel.frame), ZQ_Device_Width - 24, 30)];
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.textColor = kUIColorFromRGB(0xf16156);
    NSString *priceString = [NSString stringWithFormat:@"¥%@", _model.price];
    CGSize priceSize = [priceString sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, 30)];
    priceLabel.frame = ZQ_RECT_CREATE(12, CGRectGetMaxY(nameLabel.frame), priceSize.width, 30);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    priceLabel.attributedText = str;
    [view addSubview:priceLabel];
    
    UILabel *originalPriceLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(priceLabel.frame) + 10, CGRectGetMaxY(nameLabel.frame), ZQ_Device_Width - 24, 30)];
    originalPriceLabel.font = [UIFont systemFontOfSize:14];
    originalPriceLabel.textColor = kUIColorFromRGB(0x808080);
    NSString *oldPriceString = [NSString stringWithFormat:@"¥%@", _model.originalPrice];
    CGSize originalPriceSize = [oldPriceString sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 30)];
    originalPriceLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(priceLabel.frame) + 10, CGRectGetMaxY(nameLabel.frame)+2, originalPriceSize.width, 30);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldPriceString attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    if (![ZQ_CommonTool isEmpty:_model.originalPrice]) {
        originalPriceLabel.attributedText = string;
    }
    [view addSubview:originalPriceLabel];
    
    self.numsLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 100, CGRectGetMaxY(nameLabel.frame), 100, 30)];
    _numsLabel.font = [UIFont systemFontOfSize:12];
    _numsLabel.textColor = kUIColorFromRGB(0xABABAB);
    _numsLabel.text = [NSString stringWithFormat:@"%@人已预定", _model.nums];
    CGSize numSize = [_numsLabel.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 30)];
    _numsLabel.frame = ZQ_RECT_CREATE(ZQ_Device_Width - numSize.width - 12, CGRectGetMaxY(nameLabel.frame)+4, numSize.width, 30);
    [view addSubview:_numsLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Width/2+95, ZQ_Device_Width, 10)];
    lineView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [view addSubview:lineView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, ZQ_Device_Width/2+117.5, 15, 15)];
    imageV.image = [UIImage imageNamed:@"goodsDel"];
    [view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, ZQ_Device_Width/2+105, ZQ_Device_Width - 38, 39)];
    label.textColor = kUIColorFromRGB(0x404040);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"商品详情";
    label.font = [UIFont systemFontOfSize:15.f];
    [view addSubview:label];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Width/2+144, ZQ_Device_Width, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xeeeeee);
    [view addSubview:lineView1];

}

#pragma mark - WebView()
- (void)setUpWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Width/2 + 145, ZQ_Device_Width, 0.1)];
    _webView.delegate = self;
    _webView.backgroundColor = kUIColorFromRGB(0xffffff);
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.directionalLockEnabled = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.bounces = NO;
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setScrollEnabled:NO];
    NSURL *url = [NSURL URLWithString:_model.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [_webView loadRequest:request];
    [_scrollView addSubview:_webView];
}

- (void)setUpFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 114, ZQ_Device_Width, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    self.collectionButton = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, 100, 50)];
    if ([_model.isCollection isEqualToString:@"1"]) {
        _collectionButton.imageV.image = [UIImage imageNamed:@"collectionYes"];
        _collectionButton.label.text = @"已收藏";
        _collectionButton.label.textColor = kUIColorFromRGB(0xf16156);
    } else {
        _collectionButton.imageV.image = [UIImage imageNamed:@"collectionNo"];
        _collectionButton.label.text = @"收藏";
        _collectionButton.label.textColor = kUIColorFromRGB(0x808080);
    }
    _collectionButton.imageV.frame = ZQ_RECT_CREATE(15, 15, 20, 20);
    _collectionButton.label.font = [UIFont systemFontOfSize:15];
    _collectionButton.label.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_collectionButton.imageV.frame) + 10, 0, CGRectGetWidth(_collectionButton.frame) - CGRectGetMaxX(_collectionButton.imageV.frame) - 10, 50);
    [_collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:_collectionButton];
    
    self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _operationButton.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_collectionButton.frame), 8, ZQ_Device_Width - CGRectGetMaxX(_collectionButton.frame) - 12, 34);
    _operationButton.layer.cornerRadius = 4;
    _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    if ([_model.isAppointment isEqualToString:@"1"]) {
        [_operationButton setTitle:@"取消预定" forState:UIControlStateNormal];
        _operationButton.backgroundColor = kUIColorFromRGB(0xcccccc);
    } else {
        [_operationButton setTitle:@"立即预订" forState:UIControlStateNormal];
        _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
    }
    [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:_operationButton];
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
    
    webView.frame = ZQ_RECT_CREATE(0, ZQ_Device_Width/2 + 145, ZQ_Device_Width, (CGFloat)htmlHeight);
    
    [self setUpStorePhoneView:ZQ_Device_Width/2 + 145 + htmlHeight];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHud];
    [self showHint:@"加载失败,请重试"];
}

- (void)setUpStorePhoneView:(CGFloat)fl
{
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
    Button.frame = CGRectMake(0, fl, ZQ_Device_Width, 60);
    Button.backgroundColor = kUIColorFromRGB(0xffffff);
    [Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:Button];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 10)];
    lineView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [Button addSubview:lineView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 22.5, 15, 15)];
    imageV.image = [UIImage imageNamed:@"storePhone"];
    [Button addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 80, 40)];
    label.textColor = kUIColorFromRGB(0x808080);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"商品电话";
    label.font = [UIFont systemFontOfSize:14.f];
    [Button addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, ZQ_Device_Width - 115, 40)];
    label1.textColor = kUIColorFromRGB(0x808080);
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = _model.phone;
    label1.font = [UIFont systemFontOfSize:14.f];
    [Button addSubview:label1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 50, ZQ_Device_Width, 10)];
    lineView1.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [Button addSubview:lineView1];
    
    _scrollView.contentSize = CGSizeMake(ZQ_Device_Width, fl + 60);
}

- (void)collectionButtonClick:(ZQImageAndLabelButton *)button{
    __weak GoodsDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"did"] = _model.goodsId;
    params[@"uid"] = model.userID;
    params[@"type"] = @"2";
    if ([_model.isCollection isEqualToString:@"1"]) {
        params[@"status"] = @"0";
    } else {
        params[@"status"] = @"1";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.collect"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            if ([_model.isCollection isEqualToString:@"1"]) {
                _model.isCollection = @"0";
                _collectionButton.imageV.image = [UIImage imageNamed:@"collectionNo"];
                _collectionButton.label.text = @"收藏";
                [weakSelf showHint:@"已取消"];
                _collectionButton.label.textColor = kUIColorFromRGB(0x808080);
            } else {
                _model.isCollection = @"1";
                _collectionButton.imageV.image = [UIImage imageNamed:@"collectionYes"];
                _collectionButton.label.text = @"已收藏";
                 [weakSelf showHint:@"已收藏"];
                _collectionButton.label.textColor = kUIColorFromRGB(0xf16156);
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)operationButtonClick:(UIButton *)button{
    if ([_model.isStatus isEqualToString:@"1"]) {
        __weak GoodsDetailViewController *weakSelf = self;
        [self showHudInView:self.view hint:@"加载中..."];
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"uModelid"] = model.identity;
        params[@"uid"] = model.userID;
        NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.infoStatus"];
        [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf hideHud];
            if ([responseObject[@"errno"] intValue] == 0) {
                NSDictionary *dic = responseObject[@"rst"];
                if ([dic[@"isperfected"] intValue] == 0) {
//                    [WCAlertView showAlertWithTitle:@"提示"
//                                            message:@"您的信息不完善，完善信息后即可体验更多功能"
//                                 customizationBlock:^(WCAlertView *alertView) {
//                                     
//                                 } completionBlock:
//                     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                         if (buttonIndex == 0) {
//                             if ([model.identity integerValue] == 6) {
//                                 FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
//                                 personVc.hidesBottomBarWhenPushed = YES;
//                                 [self.navigationController pushViewController:personVc animated:YES];
//                             } else {
//                                 FXCompanyInfoController *infoVc = [[FXCompanyInfoController alloc]init];
//                                 infoVc.hidesBottomBarWhenPushed = YES;
//                                 [self.navigationController pushViewController:infoVc animated:YES];
//                             }
//                         }
//                     } cancelButtonTitle:@"去完善" otherButtonTitles:nil, nil];
                    
                    LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"您的信息不完善，完善信息后即可体验更多功能" WithMakeSure:^(LHKAlterView *alterView) {
                        
                        if ([model.identity integerValue] == 6) {
//                                                             FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
                            JXPersonInfoViewController *personVc = [[JXPersonInfoViewController alloc]init];
                                                             personVc.hidesBottomBarWhenPushed = YES;
                                                             [self.navigationController pushViewController:personVc animated:YES];
                                                         } else {
                                                             FXCompanyInfoController *infoVc = [[FXCompanyInfoController alloc]init];
                                                             infoVc.hidesBottomBarWhenPushed = YES;
                                                             [self.navigationController pushViewController:infoVc animated:YES];
                                                         }
                        
                        [alterView removeFromSuperview];
                        
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:alt];
                    
                } else {
                    [weakSelf bookingGoods];
                }
            } else {
                [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf hideHud];
            [weakSelf showHint:@"加载失败，请检查网络"];
        }];
    } else {
        [ZQ_UIAlertView showMessage:@"此商品已下架，暂不能预约" cancelTitle:@"确定"];
        return;
    }
}

- (void)bookingGoods
{
    __weak GoodsDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"goodsid"] = _model.goodsId;
    params[@"memberid"] = model.userID;
    if ([_model.isAppointment isEqualToString:@"1"]) {
        params[@"status"] = @"0";
    } else {
        params[@"status"] = @"1";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.goodsJoin"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            if ([_model.isAppointment isEqualToString:@"1"]) {
                [ZQ_UIAlertView showMessage:@"取消预定成功" cancelTitle:@"知道了"];
                [_operationButton setTitle:@"立即预订" forState:UIControlStateNormal];
                _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
                _model.isAppointment = @"0";
                _model.nums = [NSString stringWithFormat:@"%zd", [_model.nums integerValue] - 1];
                _numsLabel.text = [NSString stringWithFormat:@"%@人已预定", _model.nums];
                
                if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(bookingGoodsButtonClickWithIndex:WithNum::)]) {
                    [_delegate bookingGoodsButtonClickWithIndex:_indexPath WithNum:_model.nums];
                }
            } else {

                
                
                LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"此商品预定成功，客服人员将会电话联系您，请您耐心等待" WithMakeSure:^(LHKAlterView *alterView) {
                    
                    
                    
                    [alterView removeFromSuperview];
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:alt];

                
                
                [_operationButton setTitle:@"取消预定" forState:UIControlStateNormal];
                _operationButton.backgroundColor = kUIColorFromRGB(0xcccccc);
                _model.isAppointment = @"1";
                _model.nums = [NSString stringWithFormat:@"%zd", [_model.nums integerValue] + 1];
                _numsLabel.text = [NSString stringWithFormat:@"%@人已预定", _model.nums];
                
                if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(bookingGoodsButtonClickWithIndex:WithNum::)]) {
                    [_delegate bookingGoodsButtonClickWithIndex:_indexPath WithNum:_model.nums];
                }
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)buttonClick:(UIButton *)button{
    [WCAlertView showAlertWithTitle:@"提示"
                            message:@"您确定给商家拨打电话吗？"
                 customizationBlock:^(WCAlertView *alertView) {
                     
                 } completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _model.phone]]];
         }
     } cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
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
