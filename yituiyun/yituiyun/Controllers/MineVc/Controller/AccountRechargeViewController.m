//
//  AccountRechargeViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/2/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "AccountRechargeViewController.h"
#import "FXTakeMoneyTwoCell.h"
#import "FXTakeMoneyModel.h"

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

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"
@interface AccountRechargeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FXTakeMoneyTwoCellDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) UIView *backView;
/** 订单号  */
@property (nonatomic, copy) NSString *orderNum;
//@property (nonatomic, copy) NSString *wechat;//微信
//@property (nonatomic, copy) NSString *alipay;//支付宝
//@property (nonatomic, copy) NSString *unionpay;//银联
/**userid */
@property(nonatomic,strong) NSString * userid;
@end

@implementation AccountRechargeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayWechatSuccess) name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayWeChatFailure) name:@"wechatPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayAliSuccess) name:@"aliPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayAliFailure) name:@"aliPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayUnionSuccess:) name:@"unionpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayUnionFailure) name:@"unionpayFailure" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unionpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unionpayFailure" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FXTakeMoneyModel *model = [[FXTakeMoneyModel alloc] init];
    model.dataId = @"1";
    model.iconImg = @"wechatpay";
    model.title = @"微信支付";
    model.isChose = @"0";
    
    FXTakeMoneyModel *model1 = [[FXTakeMoneyModel alloc] init];
    model1.dataId = @"2";
    model1.iconImg = @"alipay";
    model1.title = @"支付宝支付";
    model1.isChose = @"0";
    
    FXTakeMoneyModel *model2 = [[FXTakeMoneyModel alloc] init];
    model2.dataId = @"3";
    model2.iconImg = @"unionpay";
    model2.title = @"银联支付";
    model2.isChose = @"0";
    
    self.dataArray = [NSMutableArray arrayWithObjects:model,model1,model2, nil];
    
    self.title = @"账户充值";
    
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem
{
    if (self.callback) {
        self.callback();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}

- (UIView *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomBtn.frame = CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50);
        _bottomBtn.backgroundColor = MainColor;
        [_bottomBtn setTitle:@"账户充值" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(takeMoneyClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:_bottomBtn];
    }
    return _bottomBtn;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        _headView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 150)];
        backView.backgroundColor = kUIColorFromRGB(0xffffff);
        [_headView addSubview:backView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        titleLabel.text = @"充值金额";
        titleLabel.textColor = kUIColorFromRGB(0x808080);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [backView addSubview:titleLabel];
        
        UILabel *rmbLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, 30, 70)];
        rmbLabel.text = @"¥";
        rmbLabel.textColor = kUIColorFromRGB(0x404040);
        rmbLabel.textAlignment = NSTextAlignmentCenter;
        rmbLabel.font = [UIFont systemFontOfSize:17];
        [backView addSubview:rmbLabel];
        
        self.moneyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rmbLabel.frame), CGRectGetMaxY(titleLabel.frame) + 10, 200, 70)];
        _moneyField.font = [UIFont systemFontOfSize:25];
        _moneyField.textAlignment = NSTextAlignmentLeft;
        _moneyField.delegate = self;
        [_moneyField setKeyboardType:UIKeyboardTypeNumberPad];
        [_moneyField setReturnKeyType:UIReturnKeyDone];
        [backView addSubview:_moneyField];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rmbLabel.frame), self.view.frame.size.width, 1)];
        lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
        [backView addSubview:lineView];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, 200, 20)];
        numLabel.text = @"请在上面输入充值金额";
        numLabel.textColor = kUIColorFromRGB(0xababab);
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.font = [UIFont systemFontOfSize:13];
        [backView addSubview:numLabel];
    }
    return _headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        backView.backgroundColor = [UIColor clearColor];
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
        titleView.backgroundColor = kUIColorFromRGB(0xffffff);
        [backView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        titleLabel.text = @"选择充值路径";
        titleLabel.textColor = kUIColorFromRGB(0x808080);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleView addSubview:titleLabel];
        
        return backView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXTakeMoneyTwoCell *cell = [FXTakeMoneyTwoCell takeMoneyCellWithTableView:tableView];
    FXTakeMoneyModel *model = self.dataArray[indexPath.section];
    cell.takeMoneyModel = model;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        FXTakeMoneyModel *model1 = self.dataArray[i];
        if (indexPath.section == i) {
            if ([model1.isChose integerValue] == 1) {
                model1.isChose = @"0";
            } else {
                model1.isChose = @"1";
            }
        } else {
            model1.isChose = @"0";
        }
    }
    [_tableView reloadData];
    
}

- (void)buttonClickWithIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        FXTakeMoneyModel *model1 = self.dataArray[i];
        if (indexPath.section == i) {
            if ([model1.isChose integerValue] == 1) {
                model1.isChose = @"0";
            } else {
                model1.isChose = @"1";
            }
        } else {
            model1.isChose = @"0";
        }
    }
    [_tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 充值
- (void)takeMoneyClick
{
    [_moneyField resignFirstResponder];
    
    
    if (_moneyField.text.length>=9) {
        [self showHint:@"超过最大金额"];
        return ;
    }
    if ([ZQ_CommonTool isEmpty:_moneyField.text] || [_moneyField.text doubleValue] == 0.00) {
        [self showHint:@"请输入金额"];
        return;
    }
    
//    if ([_moneyField.text doubleValue] < 1.00) {
//        [self showHint:@"金额必须大于1元"];
//        return;
//    }
    
    if (![ZQ_CommonTool isValidate:@"(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)" valueString:_moneyField.text]) {
        [self showHint:@"请输入正确金额"];
        return;
    }
    
    NSInteger t = 0;
    FXTakeMoneyModel *model;
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        FXTakeMoneyModel *model1 = self.dataArray[i];
        if ([model1.isChose integerValue] == 1) {
            model = model1;
            t = 1;
            break;
        }
    }
    
    if (t == 0) {
        [self showHint:@"请选择一种方式"];
        return;
    }
    
    [self wechatAndAlipay:model];
}

#pragma mark - 订单号的生成

- (void)wechatAndAlipay:(FXTakeMoneyModel *)model
{
    __block typeof(self) weakSelf = self;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"memberid"] = userModel.userID;
    dic[@"money"] = _moneyField.text;
    dic[@"t"] = model.dataId;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=burse.toPay"];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            weakSelf.orderNum = [NSString stringWithFormat:@"%@", tempDic[@"orderno"]];
            weakSelf.userid = userModel.userID;
           

            if ([model.dataId integerValue] == 2) {
                [USERDEFALUTS setObject:@"ali" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];
              
                //发起支付宝支付
                [weakSelf getNetWorkForAliPay];

            } else if ([model.dataId integerValue] == 1) {
                [USERDEFALUTS setObject:@"wechat" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];
               
               //发起微信支付的方法
               [weakSelf getNetWorkForWechat:nil];
                
                
                
                
            } else if ([model.dataId integerValue] == 3) {
                [USERDEFALUTS setObject:@"unionpay" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];
                
               //发起银联支付
                [weakSelf getNetWorkForUnionPay];


            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

#pragma mark 支付宝
- (void)getNetWorkForAliPay{
    
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = self.userid;
    parm[@"money"] = _moneyField.text;
    parm[@"orderno"] = self.orderNum;
    
    [XKNetworkManager POSTToUrlString:AliPayUserInterface parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resultDict = JSonDictionary;
        
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSString *aliStr = resultDict[@"rst"];
            
            [[AlipaySDK defaultService] payOrder:aliStr fromScheme:@"yituiyun" callback:^(NSDictionary *resultDic) {
                if([resultDic[@"resultStatus"] integerValue] == 9000){ // 订单支付成功
                    [weakSelf prayAliSuccess];
                }else if ([resultDic[@"resultStatus"] integerValue] == 8000){ // 正在处理中
//                    [weakSelf prayAliSuccess];

                }else if ([resultDic[@"resultStatus"] integerValue] == 4000){ // 支付失败
                    [weakSelf prayAliFailure];
                }else if ([resultDic[@"resultStatus"] integerValue] == 6001){ // 用户中途取消
                    [weakSelf prayAliFailure];

                }else if([resultDic[@"resultStatus"] integerValue] == 6002){// 网络连接错误
                    [weakSelf prayAliFailure];
                }
            }];
            
        }else{
             [weakSelf showHint:resultDict[@"errno"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];

}
#pragma mark - 微信支付
- (void)getNetWorkForWechat:(NSDictionary *)dictionary{
    
    MJWeakSelf
    /*********/
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = self.userid;
    parm[@"money"] = _moneyField.text;
    parm[@"orderno"] = self.orderNum;
    
    [XKNetworkManager POSTToUrlString:WeChatUserInterface parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resultDict = JSonDictionary;
        
       
       
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *rdict = resultDict[@"rst"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [rdict objectForKey:@"appid"];
            req.partnerId           = [rdict objectForKey:@"mch_id"];
            req.prepayId            = [rdict objectForKey:@"prepay_id"];
            req.nonceStr            = [rdict objectForKey:@"nonce_str"];
            req.timeStamp           = [rdict[@"timestamp"] integerValue];                    req.package         = rdict[@"package"];
            req.sign                = [rdict objectForKey:@"sign"];
            
            [WXApi sendReq:req];
            
        }else{
            [weakSelf showHint:resultDict[@"errno"]];

        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    /*******/

    
    
    
    
}

- (void)getNetWorkForUnionPay
{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = self.userid;
    parm[@"money"] = _moneyField.text;
    parm[@"orderno"] = self.orderNum;
    
    
    [XKNetworkManager POSTToUrlString:Unionpay parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSString *aliStr = resultDict[@"rst"][@"tn"];
            [[UPPaymentControl defaultControl] startPay:aliStr fromScheme:@"yituiyun" mode:UipayCode viewController:self];
            
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
    
    
}

#pragma mark - 付款成功 - 银联
-(void)prayUnionSuccess:(NSNotification *)data
{
            NSString *string = data.object;
        NSData *resutData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resutData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        parmDict[@"sign"] = resultDict[@"sign"];
        parmDict[@"data"] =resultDict[@"data"];
      MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [XKNetworkManager POSTToUrlString:UnionPaySign parameters:parmDict progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            [SVProgressHUD dismiss];
          NSDictionary *resultDict = JSonDictionary;
            NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
           
            if ([code isEqualToString:@"0"]) {
                [weakSelf showHint:@"支付成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
               
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf showHint:resultDict[@"errmsg"]];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf showHint:error.localizedDescription];
        }];
    
}
#pragma mark - 付款失败 -- 银联
-(void)prayUnionFailure
{    [self showHint:@"支付失败"];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 付款成功 - 支付宝
- (void)prayAliSuccess
{    [self showHint:@"支付成功"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prayAliFailure
{[self showHint:@"支付失败"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 付款成功 - 微信
- (void)prayWechatSuccess
{
    [self showHint:@"支付成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)prayWeChatFailure {
    [self showHint:@"支付失败"];

    [self.navigationController popViewControllerAnimated:YES];
}






@end
