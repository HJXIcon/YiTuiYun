//
//  OrderPayVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/17.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "OrderPayVc.h"

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
#import "FXCompanyInfoController.h"
#import "FXTakeMoneyController.h"
#import "SetWithdrawalPasswordViewController.h"
#import "PopPasswordView.h"
#import "FXGetBackWalletPSDController.h"
#import "AccountRechargeViewController.h"
#import "AddOrderView.h"

@interface OrderPayVc ()<PopPasswordViewDelegate>
@property(nonatomic,assign) NSInteger payStyle;
@property(nonatomic,strong) NSString * payPassword;
@property(nonatomic,strong) NSString * isSetPayPwd;
@property(nonatomic,strong) UIView * backView;
@property(nonatomic,strong) PopPasswordView * passwordView;
@property(nonatomic,strong) NSString * odderNo;
@property(nonatomic,strong) NSString *totalMoney;

@property(nonatomic,strong) UIView * wallteBackView;
@property (weak, nonatomic) IBOutlet UIView *tempView;
@property (weak, nonatomic) IBOutlet UIButton *shangmianbtn;

@property(nonatomic,assign)BOOL  ischarge;
@property(nonatomic,strong) AddOrderView * addView;

@property(nonatomic,assign)CGFloat  walletMoney;



@property(nonatomic,strong) NSString * addoderMoney;
@property(nonatomic,strong) NSString * addorderNo;

@property(nonatomic,strong) NSString * beginnewPrice;
@property(nonatomic,strong) NSString * beginNewNumber;
@end

@implementation OrderPayVc
#pragma mark - <lazy load>
-(AddOrderView *)addView{
    if (_addView == nil) {
        MJWeakSelf
        _addView = [AddOrderView orderView];
        _addView.frame = CGRectMake(0, 0, ScreenWidth, 176);
        _addView.numberblock = ^(NSString *str) {
          //处理数据
            weakSelf.beginNewNumber = str;
            
            if (weakSelf.isModifyPrice) {
                
                CGFloat wallet = [weakSelf.walletLabel.text floatValue];
                NSInteger number = [str integerValue];
                
                NSString *tt;
                if ([ZQ_CommonTool isEmpty:weakSelf.beginnewPrice]) {
                    tt = weakSelf.addprice;
                }else{
                    tt = weakSelf.beginnewPrice;
                }
                
                CGFloat moneyTotal = [tt floatValue] * number;
                
                _addView.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",moneyTotal];
                [weakSelf panduqian:moneyTotal andWallet:weakSelf.walletMoney];
                
            }else{
                CGFloat wallet = [self.walletLabel.text floatValue];
                NSInteger number = [str integerValue];
                CGFloat moneyTotal = [self.addprice floatValue] * number;
                
                _addView.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",moneyTotal];
                [weakSelf panduqian:moneyTotal andWallet:weakSelf.walletMoney];
            }
            
           
            
            
        };
        
        _addView.priceblock = ^(NSString *str) {

            weakSelf.beginnewPrice = str;
            
            
           
                
                CGFloat wallet = [self.walletLabel.text floatValue];
            
            
            NSString *tt;
            if ([ZQ_CommonTool isEmpty:weakSelf.beginnewPrice]) {
                tt = weakSelf.addprice;
                
            }else{
                tt = weakSelf.beginnewPrice;
                
            }
            
            
            NSInteger price = [tt integerValue];

            
            CGFloat moneyTotal = [weakSelf.beginNewNumber floatValue] * price;
            
                
                _addView.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",moneyTotal];
                [weakSelf panduqian:moneyTotal andWallet:weakSelf.walletMoney];
                
          
            
            
            /***********/
            
            
        };
        
        
    }
    return _addView;
}



-(UIView *)wallteBackView{
    if (_wallteBackView == nil) {
        _wallteBackView= [[UIView alloc]init];
        _wallteBackView.backgroundColor= UIColorFromRGBString(@"0xf16156");
    }
    return _wallteBackView;
}




#pragma mark - <Cycle Life>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ischarge = NO;
    
    //判断单价
    
    if (self.isModifyPrice) {
        
        self.addView.priceTextField.hidden = NO;
        self.addView.orginPriceLabel.hidden = NO;
        self.addView.priceLabel.hidden = YES;
        
        self.addView.orginPriceLabel.text = [NSString stringWithFormat:@"原单价是:%@",self.addprice];
        
    }else{
        self.addView.priceTextField.hidden = YES;
        self.addView.orginPriceLabel.hidden = YES;
        self.addView.priceLabel.hidden = NO;
    }
    
    self.payStyle = 100;
    self.totalLabel.text = @"";
    
        [self getMoneyAndWallet];
    
    if (self.isAddOrder) {
        [self.view addSubview:self.addView];
        self.addorderConstant.constant = 80;
        self.addView.nameLabel.text = self.addProjectName;
        self.addView.priceLabel.text = self.addprice;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.tempView insertSubview:self.wallteBackView belowSubview:self.walletLabel];
    

    
    }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unionpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unionpayFailure" object:nil];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayWechatSuccess) name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayWeChatFailure) name:@"wechatPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayAliSuccess) name:@"aliPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayAliFailure) name:@"aliPayFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayUnionSuccess:) name:@"unionpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prayUnionFailure) name:@"unionpayFailure" object:nil];
    
    if (self.isAddOrder) {
        [self getMoneyAndWallet];
    }else{
        [self getMoneyAndWallet];
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - <Private Method>
-(void)panduqian:(CGFloat)mtotolFee andWallet:(CGFloat)wallet{
    
    if (mtotolFee>wallet) {
        //钱包不够
        
        if (self.payStyle == 4) {
            self.payStyle = 100;
        }
        
        self.qianbaoPanView.userInteractionEnabled = NO;
        
        self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"chongzhi_jiantou"];
        self.yuerbuzuDescLabel.hidden = NO;
        self.shangmianbtn.hidden = YES;
        self.ischarge = YES;
        self.qianbaoPanView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        self.yuerbuzuLabel.hidden = NO;
    }else{
        //钱包的钱足够
        
        self.ischarge = NO;
        self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
        self.yuerbuzuLabel.hidden = YES;
        self.shangmianbtn.hidden = NO;
        self.yuerbuzuDescLabel.hidden = YES;
        self.qianbaoPanView.backgroundColor = [UIColor clearColor];
        self.qianbaoPanView.userInteractionEnabled = YES;
        
    }
    
}


- (void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    CGRect keyBoardBounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self keyboardHeight:keyBoardBounds.size.height duration:duration curve:curve];
}

- (void)keyboardWasHidden:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self keyboardHeight:0 duration:duration curve:curve];
}

- (void)keyboardHeight:(CGFloat)height duration:(double)duration curve:(NSUInteger)curve
{
    self.passwordView.frame = ZQ_RECT_CREATE(0, ZQ_Device_Height - height - 200, ZQ_Device_Width, 200);
}




#pragma mark - 支付宝的成功或者失败的回调
-(void)prayAliSuccess{
    [self showHint:@"支付成功"];

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)prayAliFailure{
    [self showHint:@"支付失败"];

     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 银联的成功和失败的回调


-(void)prayUnionFailure{
    [self showHint:@"支付失败"];

     [self.navigationController popViewControllerAnimated:YES];

    
}

#pragma mark - 微信的成功或者失败的回调

-(void)prayWechatSuccess{
    [self showHint:@"支付成功"];
     [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)prayWeChatFailure{
    [self showHint:@"支付失败"];

     [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - 付款成功 - 银联
-(void)prayUnionSuccess:(NSNotification *)data
{    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *string = data.object;
    NSData *resutData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resutData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict[@"sign"] = resultDict[@"sign"];
    parmDict[@"data"] =resultDict[@"data"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [XKNetworkManager POSTToUrlString:UnionPaySign parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
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




//去充值
- (IBAction)chargeMoney:(UIButton *)sender {
    
    NSLog(@"----去充值---");
    MJWeakSelf;
    AccountRechargeViewController *vc = [[AccountRechargeViewController alloc] init];
    vc.callback = ^{
        NSLog(@"----回调");
    };
    pushToControllerWithAnimated(vc)

}


-(void)getMoneyAndWallet{
    MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    
    NSString *str  = nil;
    
    if (self.isZhaoPin) {
        str = CompanyJianZiPayJobMoney;
        parm[@"job_id"] = self.demanID;
    }else{
        str = ConpanyNeedGetWalletandPrice;
        parm[@"demand_id"] = self.demanID;
    }
    
    [XKNetworkManager POSTToUrlString:str parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
       
        NSDictionary *result = JSonDictionary;
        
        if ([result[@"errno"] isEqualToString:@"0"]) {
            
            
            
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"¥%@/元",result[@"rst"][@"price"]];
            weakSelf.walletLabel.text = [NSString stringWithFormat:@"可用余额:%@",result[@"rst"][@"user_amount"]];

            
            
            CGFloat mtotolFee =[result[@"rst"][@"price"] floatValue];
            CGFloat wallet =[result[@"rst"][@"user_amount"] floatValue];
            weakSelf.walletMoney = wallet;
            
            if (self.isAddOrder) {
                self.ischarge = NO;
                self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
                self.yuerbuzuLabel.hidden = YES;
                self.shangmianbtn.hidden = NO;
                self.yuerbuzuDescLabel.hidden = YES;
                self.qianbaoPanView.backgroundColor = [UIColor clearColor];
                self.qianbaoPanView.userInteractionEnabled = YES;
 
            }else{
                
                if (mtotolFee>wallet) {
                    //钱包不够
                    self.qianbaoPanView.userInteractionEnabled = NO;
                    //                self.qiyeqianbaoLabel.hidden = YES;
                    //                self.qiyeqianbaoLabel.mj_size = CGSizeMake(15, 15);
                    self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"chongzhi_jiantou"];
                    self.yuerbuzuDescLabel.hidden = NO;
                    self.shangmianbtn.hidden = YES;
                    self.ischarge = YES;
                    self.qianbaoPanView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
                    self.yuerbuzuLabel.hidden = NO;
                }else{
                    //钱包的钱足够
                    
                    self.ischarge = NO;
                    self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
                    self.yuerbuzuLabel.hidden = YES;
                    self.shangmianbtn.hidden = NO;
                    self.yuerbuzuDescLabel.hidden = YES;
                    self.qianbaoPanView.backgroundColor = [UIColor clearColor];
                    self.qianbaoPanView.userInteractionEnabled = YES;
                    
                }
 
                
            }
            
            
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)zhifubaoClick:(id)sender {
    self.payStyle = 2;
    self.zhifubaoLabel.image = [UIImage imageNamed:@"gouxuan-"];
    self.wechatLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.yinlianLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    if (self.ischarge == NO) {
        self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];

    }
}

- (IBAction)weichatClick:(id)sender {
    self.payStyle = 1;
    self.zhifubaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.wechatLabel.image = [UIImage imageNamed:@"gouxuan-"];
    self.yinlianLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    
    
    if (self.ischarge == NO) {
        self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
        
    }
}
- (IBAction)yilianClick:(id)sender {
    self.payStyle = 3;
    self.zhifubaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.wechatLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.yinlianLabel.image = [UIImage imageNamed:@"gouxuan-"];
    if (self.ischarge == NO) {
        self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
        
    }
}
- (IBAction)qiyeqianbaoBtnClick:(id)sender {
    self.payStyle = 4;
    self.zhifubaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.wechatLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.yinlianLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-"];

}
- (IBAction)qiyeqianbao2BtnClick:(id)sender {
    self.payStyle = 4;
    self.zhifubaoLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.wechatLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.yinlianLabel.image = [UIImage imageNamed:@"gouxuan-moran"];
    self.qiyeqianbaoLabel.image = [UIImage imageNamed:@"gouxuan-"];
}


#pragma mark -  popView的代理输入钱
-(void)useStoreCode:(NSString *)code
{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    if (self.isAddOrder) {
       [self qiyeQianBaoToPlay:model.userID andMoney:self.addoderMoney andOrder:self.addorderNo and:code];
    }else{
        [self qiyeQianBaoToPlay:model.userID andMoney:self.totalMoney andOrder:self.odderNo and:code];
    }

   
    
    [self.passwordView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.passwordView = nil;
    self.backView = nil;
}

-(void)disAction
{
    [self.passwordView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.passwordView = nil;
    self.backView = nil;
}

- (void)forgotPasswordClick
{
    [self.passwordView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.passwordView = nil;
    self.backView = nil;
    FXGetBackWalletPSDController *getVc = [[FXGetBackWalletPSDController alloc]init];
    [self.navigationController pushViewController:getVc animated:YES];
}


- (UIView *)setMoreBackView{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ZQ_Device_Height)];
    _backView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.4];
    
    self.passwordView = [[PopPasswordView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height, ZQ_Device_Width, 200)];
    self.passwordView.delegate = self;
    [_backView addSubview:self.passwordView];
    
    return _backView;
}


- (void)passwordFromWallet{
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.getAmount"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uModelid"] = userModel.identity;
    params[@"uid"] = userModel.userID;
    [weakSelf showHudInView:weakSelf.navigationController.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];

            self.isSetPayPwd = [NSString stringWithFormat:@"%@", tempDic[@"isSetPayPwd"]];
            
            if ([self.isSetPayPwd integerValue] == 0) {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"由于您是第一次使用此功能，需要设置密码"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1) {
                         SetWithdrawalPasswordViewController *vc = [[SetWithdrawalPasswordViewController alloc] init];
                         pushToControllerWithAnimated(vc)
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            }else{
                
         [[UIApplication sharedApplication].keyWindow addSubview:[self setMoreBackView]];
            
            }
            
            
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

#pragma mark - 确定支付

- (IBAction)makesurePay:(id)sender {
    
    if (self.isAddOrder) {
        
        [self makesureWithAddOrderNo];
        return ;
    }
    
    if ([self.totalLabel.text isEqualToString:@""]) {
        [self showHint:@"网络问题"];
        [self getMoneyAndWallet];
        return ;
    }
   
    if (self.payStyle == 100) {
        [self showHint:@"请选择支付方式"];
        return ;
    }
    
    [MobClick event:@"zhifuyequerenzhifu"];
  
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"uid"] = user.userID;
    
    
    NSString *interfaceApi = nil;
    if (self.isZhaoPin) {
      parm[@"job_id"] = self.demanID;
        interfaceApi = CompanyJianzhiBurseToPay;
    }else{
        parm[@"demandid"] = self.demanID;
        interfaceApi = CompanyNeedsGetOrder;
    }
    
    parm[@"t"] = @(self.payStyle);
    
    [XKNetworkManager POSTToUrlString:interfaceApi parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        UserInfoModel *user = [ZQ_AppCache userInfoVo];

        NSDictionary *result = JSonDictionary;
        NSString *money = result[@"rst"][@"money"];
        NSString *orderno = result[@"rst"][@"orderno"];
        weakSelf.odderNo = orderno;
        self.totalMoney = money;
        
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
       
        if ([code isEqualToString:@"0"]) {
           /**********************/
            if (weakSelf.payStyle == 2) {
                //支付宝
                
                [USERDEFALUTS setObject:@"ali" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];

                [weakSelf getNetWorkForAliPay:user.userID wihthMoney:money withOrderNO:orderno];
                
            }else if (weakSelf.payStyle == 1){
                //微信
                [USERDEFALUTS setObject:@"wechat" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];

                [weakSelf getNetWorkForWechat:user.userID wihthMoney:money withOrderNO:orderno];
                
            }else if (weakSelf.payStyle == 3){
                //银联
                [USERDEFALUTS setObject:@"unionpay" forKey:@"payStyle"];
                [USERDEFALUTS synchronize];

                [weakSelf getNetWorkForUnionPay:user.userID wihthMoney:money withOrderNO:orderno];
                
            }else if (weakSelf.payStyle == 4){
                
                [weakSelf passwordFromWallet];
            }

            /*******************/
        }else if ([code isEqualToString:@"1"]){
          
            [weakSelf showHint:@"订单存在异常，不能进行支付"];
            
        }else if ([code isEqualToString:@"-1"]){
             [weakSelf showHint:@"需求不存在"];
            
        }else if ([code isEqualToString:@"2"]){
             [weakSelf showHint:@"支付异常,请稍后再试"];
            
        }else if ([code isEqualToString:@"3"]){
            [weakSelf showHint:@"该订单已支付，不用再支付"];
            
        }else{
            [weakSelf showHint:@"服务器url错误"];
        }



      
        
        
    
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];

    }


#pragma MARK---增加了订单号

-(void)makesureWithAddOrderNo{
    
    
    if (![ZQ_CommonTool isEmpty:self.addView.priceTextField.text]) {
        if ([self.addView.priceTextField.text floatValue]<=0) {
            [self showHint:@"请填写正确的任务单价"];
            return ;
        }
    }
    
    if ([ZQ_CommonTool isEmpty:self.addView.numberTextField.text] || ([self.addView.numberTextField.text integerValue]<1)) {
        [self showHint:@"请填写正确的任务数量"];
        return ;
    }
    if (self.payStyle == 100) {
        [self showHint:@"请选择支付方式"];
        return ;
    }
    
    
    
    
    MJWeakSelf
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"uid"] = usermodel.userID;
    parm[@"demandid"] = self.demanID;
    parm[@"t"] = @(self.payStyle);
    parm[@"number"] = self.addView.numberTextField.text;
    
    if ([ZQ_CommonTool isEmpty:self.beginnewPrice]) {
        parm[@"price"] = self.addprice;
      
    }else{
        parm[@"price"] = self.beginnewPrice;
       
    }
    
    
    
//    NSLog(@"%@-------",parm);
//    
//    return ;
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    
[XKNetworkManager POSTToUrlString:AddOrderInterface parameters:parm progress:^(CGFloat progress) {
    
} success:^(id responseObject) {
    [SVProgressHUD dismiss];
    NSDictionary *resultDict = JSonDictionary;
    
    
    NSString *code = resultDict[@"errno"];
    
    if ([code isEqualToString:@"0"]) {
        NSString *orderno = [NSString stringWithFormat:@"%@",resultDict[@"rst"][@"orderno"]];
        NSString *money = [NSString stringWithFormat:@"%@",resultDict[@"rst"][@"money"]];
        
        weakSelf.addoderMoney = money;
        weakSelf.addorderNo = orderno;
        /************/
        
        /**********************/
        if (weakSelf.payStyle == 2) {
            //支付宝
            
            [USERDEFALUTS setObject:@"ali" forKey:@"payStyle"];
            [USERDEFALUTS synchronize];
            
            [weakSelf getNetWorkForAliPay:usermodel.userID wihthMoney:money withOrderNO:orderno];
            
        }else if (weakSelf.payStyle == 1){
            //微信
            [USERDEFALUTS setObject:@"wechat" forKey:@"payStyle"];
            [USERDEFALUTS synchronize];
            
            [weakSelf getNetWorkForWechat:usermodel.userID wihthMoney:money withOrderNO:orderno];
            
        }else if (weakSelf.payStyle == 3){
            //银联
            [USERDEFALUTS setObject:@"unionpay" forKey:@"payStyle"];
            [USERDEFALUTS synchronize];
            
            [weakSelf getNetWorkForUnionPay:usermodel.userID wihthMoney:money withOrderNO:orderno];
            
        }else if (weakSelf.payStyle == 4){
            
            [weakSelf passwordFromWallet];
        }
        
        /*******************/
       
    } else if ([code isEqualToString:@"1"]){
        [weakSelf showHint:@"订单存在异常，不能进行支付"];
        
    }else{
        [weakSelf showHint:@"服务器url错误"];
    }
 
 
 
} failure:^(NSError *error) {
    [SVProgressHUD dismiss];
}];
}

#pragma mark - 企业钱包付款

-(void)qiyeQianBaoToPlay:(NSString *)memberid andMoney:(NSString *)money andOrder:(NSString *)orderno and:(NSString *)password{
    
    MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = memberid;
    parm[@"money"] = money;
    parm[@"orderno"] = orderno;
    parm[@"paypassword"] = password;
    
    [SVProgressHUD showWithStatus:@"钱包支付中..."];
    [XKNetworkManager POSTToUrlString:CompanyNeedWalletToPay parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = JSonDictionary;
        
        if ([dict[@"errno"] isEqualToString:@"0"]) {
            [weakSelf showHint:@"支付成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf showHint:dict[@"errmsg"]];
        }
  
        

        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 支付宝
- (void)getNetWorkForAliPay:(NSString *)userID wihthMoney:(NSString *)money withOrderNO:(NSString *)orderno{
    
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"支付宝加载中..."];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userID;
    parm[@"money"] = money;
    parm[@"orderno"] = orderno;
    
    [XKNetworkManager POSTToUrlString:AliPayUserInterface parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resultDict = JSonDictionary;
        
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSString *aliStr = resultDict[@"rst"];
            
            [[AlipaySDK defaultService] payOrder:aliStr fromScheme:@"yituiyun" callback:^(NSDictionary *resultDic) {
                if([resultDic[@"resultStatus"] integerValue] == 9000){ // 订单支付成功
                }else if ([resultDic[@"resultStatus"] integerValue] == 8000){ // 正在处理中
                    
                }else if ([resultDic[@"resultStatus"] integerValue] == 4000){ // 支付失败
                }else if ([resultDic[@"resultStatus"] integerValue] == 6001){ // 用户中途取消
          
                }else if([resultDic[@"resultStatus"] integerValue] == 6002){// 网络连接错误
                    
                }
            }];
            
        }else{
            [weakSelf showHint:resultDict[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
    }
#pragma mark - 微信支付
- (void)getNetWorkForWechat:(NSString *)userID wihthMoney:(NSString *)money withOrderNO:(NSString *)orderno{
    
    MJWeakSelf
    /*********/
    
    [SVProgressHUD showWithStatus:@"微信加载中..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userID;
    parm[@"money"] = money;
    parm[@"orderno"] = orderno;
    
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
            [weakSelf showHint:resultDict[@"errmsg"]];
        }

        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
}

- (void)getNetWorkForUnionPay:(NSString *)userID wihthMoney:(NSString *)money withOrderNO:(NSString *)orderno
{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"银联加载中..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userID;
    parm[@"money"] = money;
    parm[@"orderno"] = orderno;
    
    
    [XKNetworkManager POSTToUrlString:Unionpay parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSString *aliStr = resultDict[@"rst"][@"tn"];
            [[UPPaymentControl defaultControl] startPay:aliStr fromScheme:@"yituiyun" mode:UipayCode viewController:self];
            
        }else{
            [weakSelf showHint:resultDict[@"errmsg"]];
        }

        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)qiyeqianbao:(id)sender {
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.wallteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.walletLabel.mas_centerX);
        make.centerY.mas_equalTo(self.walletLabel.mas_centerY);
        make.width.mas_equalTo(self.walletLabel.mas_width).offset(10);
//        make.height.mas_equalTo(self.walletLabel.mas_height).offset(4);
        make.bottom.mas_equalTo(self.tempView.mas_bottom).offset(-2);
    }];
}
@end
