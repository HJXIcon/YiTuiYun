//
//  FXInSurePayController.m
//  yituiyun
//
//  Created by fx on 16/11/16.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXInSurePayController.h"
#import "FXUploadPhotoController.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "Base64.h"
#import "getIPhoneIP.h"
#import "Order.h"

#import "WXApi.h"
#import "WXApiObject.h"

@interface FXInSurePayController ()

@property (nonatomic, strong) UIImageView *choseAliView;
@property (nonatomic, strong) UIImageView *choseWxView;
@property (nonatomic, copy) NSString *payWay;//支付方式 1微信 2支付宝
@property (nonatomic, copy) NSString *alipayUrl; //支付宝回调地址
@end

@implementation FXInSurePayController{
    BOOL _choseAli;
    BOOL _choseWx;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailure) name:@"wechatPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"aliPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailure) name:@"aliPayFailure" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPayFailure" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    _choseAli = NO;
    _choseWx = NO;
    
    /*************************** 分割线 **********************************/
//    self.price = @"0.01"; //测试价格 待删除
    /*************************** 分割线 **********************************/

    self.title = @"付款";
    [self setUpViews];

}
- (void)setUpViews{
    UIView *bgfirView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 60)];
    bgfirView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:bgfirView];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额:¥%@", self.price]];
    [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, [str length])];
    [str addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x404040) range:NSMakeRange(0, 5)];

    moneyLabel.attributedText = str;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:19];
    [bgfirView addSubview:moneyLabel];
    
    UIView *bgsecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgfirView.frame) + 10, self.view.frame.size.width, 180)];
    bgsecView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:bgsecView];
    
    UILabel *choseTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    choseTipLabel.text = @"选择支付方式";
    choseTipLabel.textColor = kUIColorFromRGB(0x404040);
    choseTipLabel.textAlignment = NSTextAlignmentLeft;
    choseTipLabel.font = [UIFont systemFontOfSize:14];
    [bgsecView addSubview:choseTipLabel];
    
    UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(choseTipLabel.frame), self.view.frame.size.width, 1)];
    lineFirView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [bgsecView addSubview:lineFirView];
    
    UIImageView *alipayImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineFirView.frame) + 22.5, 25, 25)];
    alipayImg.image = [UIImage imageNamed:@"alipay.png"];
    [bgsecView addSubview:alipayImg];
    
    UILabel *alipayLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alipayImg.frame) + 10, CGRectGetMaxY(lineFirView.frame) + 15, 200, 20)];
    alipayLable.text = @"支付宝";
    alipayLable.textAlignment = NSTextAlignmentLeft;
    alipayLable.textColor = kUIColorFromRGB(0x404040);
    alipayLable.font = [UIFont systemFontOfSize:17];
    [bgsecView addSubview:alipayLable];
    
    UILabel *aliTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alipayImg.frame) + 10, CGRectGetMaxY(alipayLable.frame), 200, 20)];
    aliTipLabel.text = @"推荐支付宝用户使用";
    aliTipLabel.textAlignment = NSTextAlignmentLeft;
    aliTipLabel.textColor = kUIColorFromRGB(0x808080);
    aliTipLabel.font = [UIFont systemFontOfSize:13];
    [bgsecView addSubview:aliTipLabel];
    
    UIButton *aliButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aliButton.frame = CGRectMake(self.view.frame.size.width - 70, CGRectGetMaxY(lineFirView.frame), 70, 70);
    [aliButton addTarget:self action:@selector(choseAliPay) forControlEvents:UIControlEventTouchUpInside];
    [bgsecView addSubview:aliButton];
    
    self.choseAliView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 20, 20)];
    _choseAliView.image = [UIImage imageNamed:@"unchose.png"];
    [aliButton addSubview:_choseAliView];
    
    UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(alipayImg.frame) + 22.5, self.view.frame.size.width, 1)];
    lineSecView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [bgsecView addSubview:lineSecView];
    
    UIImageView *wechatImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineSecView.frame) + 22.5, 25, 25)];
    wechatImg.image = [UIImage imageNamed:@"wechatpay.png"];
    [bgsecView addSubview:wechatImg];
    
    UILabel *wechatLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wechatImg.frame) + 10, CGRectGetMaxY(lineSecView.frame) + 15, 200, 20)];
    wechatLabel.text = @"微信";
    wechatLabel.textAlignment = NSTextAlignmentLeft;
    wechatLabel.textColor = kUIColorFromRGB(0x404040);
    wechatLabel.font = [UIFont systemFontOfSize:17];
    [bgsecView addSubview:wechatLabel];
    
    UILabel *wechatTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wechatImg.frame) + 10, CGRectGetMaxY(wechatLabel.frame), 200, 20)];
    wechatTipLabel.text = @"推荐微信用户使用";
    wechatTipLabel.textAlignment = NSTextAlignmentLeft;
    wechatTipLabel.textColor = kUIColorFromRGB(0x808080);
    wechatTipLabel.font = [UIFont systemFontOfSize:13];
    [bgsecView addSubview:wechatTipLabel];
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wxButton.frame = CGRectMake(self.view.frame.size.width - 70, CGRectGetMaxY(lineSecView.frame), 70, 70);
    [wxButton addTarget:self action:@selector(choseWxPay) forControlEvents:UIControlEventTouchUpInside];
    [bgsecView addSubview:wxButton];
    
    self.choseWxView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 20, 20)];
    _choseWxView.image = [UIImage imageNamed:@"unchose.png"];
    [wxButton addSubview:_choseWxView];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(0, self.view.frame.size.height - 40 - 64, self.view.frame.size.width, 40);
    payButton.layer.cornerRadius = 5;
    payButton.backgroundColor = MainColor;
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}

- (void)choseAliPay{
    if (_choseAli) {
        _choseAli = NO;
        _choseAliView.image = [UIImage imageNamed:@"unchose.png"];
    }else{
        _choseAli = YES;
        _choseWx = NO;
        _choseAliView.image = [UIImage imageNamed:@"chose.png"];
        _choseWxView.image = [UIImage imageNamed:@"unchose.png"];
    }
}
- (void)choseWxPay{
    if (_choseWx) {
        _choseWx = NO;
        _choseWxView.image = [UIImage imageNamed:@"unchose.png"];
    }else{
        _choseWx = YES;
        _choseAli = NO;
        _choseWxView.image = [UIImage imageNamed:@"chose.png"];
        _choseAliView.image = [UIImage imageNamed:@"unchose.png"];
    }
}
//点击支付按钮 判断此订单是否生成过 有订单号直接支付，无则生成订单
- (void)payButtonClick{
    if (!_choseWx && !_choseAli) {
        [self showHint:@"请选择支付方式"];
        return;
    }
    if (!_orderNum) {
        [self makePayOrder];
    }else{
        if (_choseAli) {
            self.payWay = @"2";
            [USERDEFALUTS setObject:@"ali" forKey:@"payStyle"];
            [USERDEFALUTS synchronize];
            [self getNetWorkForAliPay];
        }else{
            self.payWay = @"1";
            [USERDEFALUTS setObject:@"wechat" forKey:@"payStyle"];
            [USERDEFALUTS synchronize];
            NSString *moneyStr;
            moneyStr = [NSString stringWithFormat:@"%zd",(NSInteger)([self.price floatValue] * 100)];
            NSDictionary *dic = @{
                                  @"orderBody":@"易推云保险支付",
                                  @"payAmount":moneyStr,
                                  @"orderCode":self.orderNum,
                                  };
            
            [self getNetWorkForWechat:dic];
        }
    }
}
//生成订单
- (void)makePayOrder{

    __block typeof(self) weakSelf = self;
    if (_choseAli) {
        self.payWay = @"2";
    }else{
        self.payWay = @"1";
    }
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.addInsurance"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"demandid":self.dataID,
                          @"type":self.type,
                          @"memberid":userModel.userID,
                          @"price":self.price,
                          @"startDate":self.startDateStr,
                          @"endDate":self.endDateStr,
                          @"payType":self.payWay
                          };
    [weakSelf showHudInView:weakSelf.view hint:@"提交中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            self.orderNum = tempDic[@"orderNo"];
            //成功接着支付
            if (_choseAli) {
                self.payWay = @"2";
                [USERDEFALUTS setObject:@"ali" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];
                [self getNetWorkForAliPay];
            }else{
                self.payWay = @"1";
                [USERDEFALUTS setObject:@"wechat" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];
                NSString *moneyStr;
                moneyStr = [NSString stringWithFormat:@"%zd",(NSInteger)([self.price floatValue] * 100)];
                NSDictionary *dic = @{
                                      @"orderBody":@"易推云保险支付",
                                      @"payAmount":moneyStr,
                                      @"orderCode":self.orderNum,
                                      };

                [self getNetWorkForWechat:dic];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        NSLog(@"%@",error);
    }];
}
#pragma mark 支付宝
- (void)getNetWorkForAliPay{
   
    NSString *partner = @"2088521143399809";
    NSString *seller = @"yituiyuncn@163.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALsMvttHSxq6WCSWAHzglxlMycM1AvjDUpmcIBcBSKgx5Qvzu05JxfzDKrUmFcWyPBdFGQppnomslgGWdkeqokmSrPtng7dl7cBwaYNMWVVWjUl1RZ/eDZ28n1Sywt5tFf+Fg0ZonReuBY7CPIIF6uMnOnCsz0zsKoqB4Vbj5sFdAgMBAAECgYB/+nB7R4QzfVvhbGBZELFRNiC11wd5fOp+/ztVgiNcMQct7k0xe3hjQIVv++bZpOFIapZ/cVRvjg30eCXlUvJFh8aH/zrdAuIUHKG3TGVQuaxOVDERxdvaW/E4gmwwvGdgdZymFnNZPm0ie4im8Pq9PWwG+IeKfd1J41YDzKOZYQJBAO/yu9iBg9bumNW/3ClROqVGnbtKx/WrDroBc7s3lWRyFsJYkP411RsJGSolJEXh4xoyMd+drEkyGfg21p3X4+MCQQDHkBfKL2TaaKqOtWoJVjjvIosFe0n16vvxVOmreIqGstETNAz0POB1FEu1KtrLfVc9nyAg7AD6EjNsTGsoSEm/AkBtoCK+ef24Fu5wyeVWYyw+EpNB3Jqa3PovdTZg1LZGW/GV/UzRN9sTLQb4QFvgKaHOeBxdI/Zwwpkm1DcdimMtAkEAlDYXBQk37OHpMf3YF8EanbfY6iRLpMF1hiGbPcdTkoCBuLJioI4J4cpGA/Ik9xZK0bA5q1m7y/3yhQ8oUo2FfwJBAIITW0PABGW6e93uWU7PiSbITd3DYIww/fHa3R1t9aXeu6gSIDO0HaMua4YwcamWPHxT47yCwTKFk15ADKFM0Bc=";
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    Order *order = [[Order alloc] init];
    order.partner = partner;//唯一标识号
    order.sellerID = seller;//支付账户
    order.outTradeNO = self.orderNum; //订单号（由商家自行制定）
    order.subject = @"易推云"; //商品标题
    order.body = @"易推云保险支付"; //商品描述
    order.totalFee = self.price; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@%@", kHost, @"notify_url.php"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"yituiyun";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //            NSLog(@"controller:%@",resultDic);
            if([resultDic[@"resultStatus"] integerValue] == 9000){ // 订单支付成功
                // 更新订单
                [self paySuccess];
            }else if ([resultDic[@"resultStatus"] integerValue] == 8000){ // 正在处理中
//                [self prayAliFailure];
            }else if ([resultDic[@"resultStatus"] integerValue] == 4000){ // 支付失败
//                [self prayAliFailure];
            }else if ([resultDic[@"resultStatus"] integerValue] == 6001){ // 用户中途取消
                [self showHint:@"取消支付"];
            }else if([resultDic[@"resultStatus"] integerValue] == 6002){// 网络连接错误
//                [self prayAliFailure];
            }
        }];
    }
}
#pragma mark - 微信支付
- (void)getNetWorkForWechat:(NSDictionary *)dictionary{
    //调用微信支付
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demoWithDict:dictionary];
    
    if(dict == nil){
        //错误提示
        //        NSString *debug = [req getDebugifo];
        //        NSLog(@"%@",debug);

    }else{
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }

}
//支付成功 上传截图更新状态
- (void)paySuccess{
    [MobClick event:@"buySafe"];

    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.updateInsurance"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderNo"] = self.orderNum;
    dic[@"payType"] = self.payWay;
    dic[@"payStatus"] = @"1";
    dic[@"startDate"] = self.startDateStr;
    dic[@"endDate"] = self.endDateStr;
    dic[@"price"] = self.price;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
            upVc.dataID = self.orderNum;
            upVc.price = self.price;
            upVc.type = self.type;
            upVc.startDateStr = self.startDateStr;
            upVc.endDateStr = self.endDateStr;
            upVc.payType = @"1";
            upVc.tipStr = @"请选择";
            upVc.title = @"上传截图";
            [self.navigationController pushViewController:upVc animated:YES];

        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}
- (void)payFailure{
//    [self showHint:@"请重新支付"];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
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
