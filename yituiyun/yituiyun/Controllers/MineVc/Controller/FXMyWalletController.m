//
//  FXMyWalletController.m
//  yituiyun
//
//  Created by fx on 16/10/17.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXMyWalletController.h"
#import "FXMoneyListController.h"
#import "FXTakeMoneyController.h"
#import "SetWithdrawalPasswordViewController.h"
//#import "FXPersonInfoController.h"
#import "JXPersonInfoViewController.h"
#import "FXCompanyInfoController.h"
#import "AccountRechargeViewController.h"
#import "MoneyDetailVc.h"
#import "RealNameVc.h"
#import "JXRepeatButton.h"
#import "MyWalletTishi.h"
#import "JXShowAgreementViewController.h"

@interface FXMyWalletController ()

@property (nonatomic, strong) UILabel *moneyNumLabel;
@property (nonatomic, copy) NSString *numStr;
@property (nonatomic, copy) NSString *payPassword;
@property (nonatomic, copy) NSString *isSetPayPwd; //是否设置提现密码
@property (nonatomic, assign) NSInteger where;
@property(nonatomic,strong) UIImageView *titleImageView;

@property(nonatomic,strong) UILabel * totalNumberLabel;
@property(nonatomic,strong) UILabel  *baozhengjinNumberLabel;
@property(nonatomic,strong) UILabel * finishedBaozhengjinLabel;
@end

@implementation FXMyWalletController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];

    [self getMoneyNum];
}

- (instancetype)initWithWhere:(NSInteger)where
{
    self = [super init];
    if (self) {
        self.where = where;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    
    UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
    if ([userInfo.identity integerValue] == 6) {
        self.title = @"我的工资";
        [self setUpViews];
    } else if ([userInfo.identity integerValue] == 5) {
        self.title = @"企业钱包";
        [self setUpViews1];
    }
    [self.view addSubview:self.titleImageView];
}

- (void)leftBarButtonItem{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//个人端
- (void)setUpViews{
    
    UIImageView *backView = nil;
    
    if (ScreenWidth<375) {
        backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    }else{
        backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    }
   
    backView.backgroundColor = UIColorFromRGBString(@"0xf16156");
//    backView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backView];
    
    
    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 20)];
    textLabel.text = @"余额（元）";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = kUIColorFromRGB(0xffffff);
    textLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:textLabel];
    
    self.moneyNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textLabel.frame) + 40, self.view.frame.size.width, 70)];
    self.moneyNumLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyNumLabel.textColor = kUIColorFromRGB(0xffffff);
    self.moneyNumLabel.font = [UIFont systemFontOfSize:FontRadio(50)];
    [backView addSubview:self.moneyNumLabel];
    
    JXRepeatButton *bringButton = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
   
    
    if (ScreenWidth<375) {
        bringButton.frame = CGRectMake(50, 200, self.view.frame.size.width - 100, 44);
    }else{
         bringButton.frame = CGRectMake(50, 270, self.view.frame.size.width - 100, 44);
    }
    bringButton.layer.cornerRadius = 5;
    bringButton.backgroundColor = MainColor;
    [bringButton setTitle:@"余额提现" forState:UIControlStateNormal];
    [bringButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bringButton addTarget:self action:@selector(bringClick) forControlEvents:UIControlEventTouchUpInside];
    bringButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bringButton];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bringButton.frame)+HRadio(15), ScreenWidth-20, HRadio(199))];
    titleImageView.image = [UIImage imageNamed:@"titleMySalary"];
//    [self.view addSubview:titleImageView];
    
    MJWeakSelf;
    MyWalletTishi *wallet = [[MyWalletTishi alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bringButton.frame)+HRadio(5), ScreenWidth-20, HRadio(199+44))];
    
    wallet.block = ^{
        
        JXShowAgreementViewController *vc = [[JXShowAgreementViewController alloc]init];
        vc.style = JXShowAgreementFullDay;
        vc.title = @"非全日制用工劳动合同书";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    [self.view addSubview:wallet];

}

- (void)setUpViews1{//企业端
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
//    backView.image = [UIImage imageNamed:@"walletback.png"]; //
    backView.backgroundColor = UIColorFromRGBString(@"0xf16156");
//    backView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backView];
    
    
    //总额
    UILabel *totalLabelDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    totalLabelDesc.text = @"总额(元)";
    totalLabelDesc.textAlignment = NSTextAlignmentCenter;
    totalLabelDesc.textColor = kUIColorFromRGB(0xffffff);
    totalLabelDesc.font = [UIFont systemFontOfSize:22];
    [backView addSubview:totalLabelDesc];
    
    self.totalNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(totalLabelDesc.frame)-8 , self.view.frame.size.width, 50)];
    self.totalNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.totalNumberLabel.textColor = kUIColorFromRGB(0xffffff);
    self.totalNumberLabel.font = [UIFont systemFontOfSize:FontRadio(35)];
//    self.totalNumberLabel.text = @"1224234231434";
    [backView addSubview:self.totalNumberLabel];

    //可提现余额
    
    UILabel *tixiantextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.totalNumberLabel.frame)+15, self.view.frame.size.width*0.333, 40)];
    tixiantextLabel.text = @"可提现(元)";
    tixiantextLabel.textAlignment = NSTextAlignmentCenter;
    tixiantextLabel.textColor = kUIColorFromRGB(0xffffff);
    tixiantextLabel.font = [UIFont systemFontOfSize:FontRadio(16)];
    [backView addSubview:tixiantextLabel];
    
    self.moneyNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tixiantextLabel.frame)+5 , self.view.frame.size.width*0.333, 22)];
    self.moneyNumLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyNumLabel.textColor = kUIColorFromRGB(0xffffff);
    self.moneyNumLabel.font = [UIFont systemFontOfSize:FontRadio(24)];
    [backView addSubview:self.moneyNumLabel];
    
    
    //总保证金
    UILabel *baozhengjinLabelDesc = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, CGRectGetMaxY(self.totalNumberLabel.frame)+15, self.view.frame.size.width*0.32, 40)];
    baozhengjinLabelDesc.text = @"总保证金(元)";
    baozhengjinLabelDesc.textAlignment = NSTextAlignmentCenter;
    baozhengjinLabelDesc.textColor = kUIColorFromRGB(0xffffff);
    baozhengjinLabelDesc.font = [UIFont systemFontOfSize:FontRadio(16)];
    [backView addSubview:baozhengjinLabelDesc];
    
    self.baozhengjinNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, CGRectGetMaxY(baozhengjinLabelDesc.frame)+5, self.view.frame.size.width*0.32, 22)];
    self.baozhengjinNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.baozhengjinNumberLabel.textColor = kUIColorFromRGB(0xffffff);
    self.baozhengjinNumberLabel.font = [UIFont systemFontOfSize:FontRadio(24)];

    [backView addSubview:self.baozhengjinNumberLabel];
    
    //可结算保证金(元)
    
    UILabel *finshbaozhengjinLabelDesc = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.62, CGRectGetMaxY(self.totalNumberLabel.frame)+15, self.view.frame.size.width*0.333, 40)];
    finshbaozhengjinLabelDesc.text = @"已结算保证金(元)";
    finshbaozhengjinLabelDesc.textAlignment = NSTextAlignmentCenter;
    finshbaozhengjinLabelDesc.textColor = kUIColorFromRGB(0xffffff);
    finshbaozhengjinLabelDesc.font = [UIFont systemFontOfSize:FontRadio(16)];
    [backView addSubview:finshbaozhengjinLabelDesc];
    
    self.finishedBaozhengjinLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.62, CGRectGetMaxY(finshbaozhengjinLabelDesc.frame)+5, self.view.frame.size.width*0.333, 22)];
    self.finishedBaozhengjinLabel.textAlignment = NSTextAlignmentCenter;
    self.finishedBaozhengjinLabel.textColor = kUIColorFromRGB(0xffd0cc);
    self.finishedBaozhengjinLabel.font = [UIFont systemFontOfSize:FontRadio(24)];
   
    [backView addSubview:self.finishedBaozhengjinLabel];
    
    
    
    
    
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = CGRectMake(10, CGRectGetMaxY(backView.frame) + 30, self.view.frame.size.width - 20, 40);
    rechargeButton.layer.cornerRadius = 5;
    rechargeButton.backgroundColor = MainColor;
    [rechargeButton setTitle:@"账户充值" forState:UIControlStateNormal];
    [rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rechargeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:rechargeButton];
    
    UIButton *bringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bringButton.frame = CGRectMake(10, CGRectGetMaxY(rechargeButton.frame) + 20, self.view.frame.size.width - 20, 40);
    bringButton.layer.cornerRadius = 5;
    bringButton.backgroundColor = MainColor;
    [bringButton setTitle:@"账户退款" forState:UIControlStateNormal];
    [bringButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bringButton addTarget:self action:@selector(bringClick) forControlEvents:UIControlEventTouchUpInside];
    bringButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bringButton];
    
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bringButton.frame)+HRadio(15), ScreenWidth-20, HRadio(75))];
    
    titleImageView.image = [UIImage imageNamed:@"copany_tuikuan"];
    
    [self.view addSubview:titleImageView];

    
}

//明细
- (void)detailBtnClick
{
//    FXMoneyListController *listVc = [[FXMoneyListController alloc] init];
    MoneyDetailVc *listVc = [[MoneyDetailVc alloc]init];
    listVc.navigationItem.title= @"明细";
    [self.navigationController pushViewController:listVc animated:YES];
}

//充值
- (void)rechargeButtonClick
{
    AccountRechargeViewController *vc = [[AccountRechargeViewController alloc] init];
    pushToControllerWithAnimated(vc)
}

//提现/退款
- (void)bringClick
{

    
    
    if ([self.numStr floatValue] > 0.00) {

        UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];

        if ([usermodel.identity isEqualToString:@"5"]) {
            [self udgeInfoStatus];
        }else{
            [self panDuanRealName];
        }
        
    } else {
        [ZQ_UIAlertView showMessage:@"余额大于0.00元才可以进行此操作" cancelTitle:@"确定"];
    }

    
}

-(void)panDuanRealName{
    
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parmDict[@"memberid"] = model.userID;
    [XKNetworkManager POSTToUrlString:RealNameCerfiStatus parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resutDic=JSonDictionary;
        
        
        NSString *errnoString = [NSString stringWithFormat:@"%@",resutDic[@"errno"] ];
        
        if ([errnoString isEqualToString:@"0"]) {
            //0 未认证 //1 审核中  //2 已认证 //3 认证失败
            NSInteger status = [resutDic[@"rst"][@"is_authentication"] integerValue];
            
            NSLog(@"-----%ld",status);
            
            if (status == 2) {
                NSString *name_zh=resutDic[@"rst"][@"real_name"];
                
                
                //身份证
                NSString *shenfenNo=resutDic[@"rst"][@"idcard_no"];
                
                [[NSUserDefaults standardUserDefaults] setObject:name_zh forKey:PersonCenterName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:shenfenNo forKey:PersonCenterCarId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                
                
                /*****************/
                
                
                if ([self.isSetPayPwd integerValue] == 1) {
                    FXTakeMoneyController *takeVc = [[FXTakeMoneyController alloc] initWithNumStr:self.numStr WithPayPassword:self.payPassword];
                    [self.navigationController pushViewController:takeVc animated:YES];
                } else {
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
                }
            }else{
                
                //跳转
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PersonCenterName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PersonCenterCarId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                
                
                LHKAlterView *alterView = [LHKAlterView alterViewWithTitle:@"需要实名认证" andDesc:@"前往实名认证" WithCancelBlock:^(LHKAlterView *alterView) {
                    
                    [alterView removeFromSuperview];
                    
                } WithMakeSure:^(LHKAlterView *alterView) {
                    RealNameVc *relVc = [[RealNameVc alloc]init];
                    relVc.navigationItem.title = @"实名认证";
                    [weakSelf.navigationController pushViewController:relVc animated:YES];
                    
                    [alterView removeFromSuperview];
                    
                }];
                
                [[UIApplication sharedApplication].keyWindow addSubview:alterView];

            }
            //名字
            
        
        
        
        
        }else{
            
            [self showHint:@"数据异常"];
            
        }
        

        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];

    
}

- (void)udgeInfoStatus
{
    
    
    
        __weak FXMyWalletController *weakSelf = self;
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
                    [WCAlertView showAlertWithTitle:@"提示"
                                            message:@"您的信息不完善，完善信息后即可体验更多功能"
                                 customizationBlock:^(WCAlertView *alertView) {
    
                                 } completionBlock:
                     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 0) {
                             if ([model.identity integerValue] == 6) {
//                                 FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
                                 JXPersonInfoViewController *personVc = [[JXPersonInfoViewController alloc]init];
                                 personVc.hidesBottomBarWhenPushed = YES;
                                 [self.navigationController pushViewController:personVc animated:YES];
                             } else {
                                 FXCompanyInfoController *infoVc = [[FXCompanyInfoController alloc]init];
                                 infoVc.hidesBottomBarWhenPushed = YES;
                                 [self.navigationController pushViewController:infoVc animated:YES];
                             }
                         }
                     } cancelButtonTitle:@"去完善" otherButtonTitles:nil, nil];
                } else {
                    
                    //判断一下实明认证
                    /******************/
                    
                    
                    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
                    NSString *name_zh = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterName];
                    NSString *shengNo = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterCarId];
                    
                    if (name_zh.length == 0 && shengNo.length == 0 && [usermodel.identity isEqualToString:@"6"]) {
                        
                        LHKAlterView *alterView = [LHKAlterView alterViewWithTitle:@"需要实名认证" andDesc:@"前往实名认证" WithCancelBlock:^(LHKAlterView *alterView) {
                            
                            [alterView removeFromSuperview];
                            
                        } WithMakeSure:^(LHKAlterView *alterView) {
                            RealNameVc *relVc = [[RealNameVc alloc]init];
                            relVc.navigationItem.title = @"实名认证";
                            [weakSelf.navigationController pushViewController:relVc animated:YES];
                            
                            [alterView removeFromSuperview];
                            
                        }];
                        
                        [[UIApplication sharedApplication].keyWindow addSubview:alterView];
                        
                        return ;
                    }
                    
                    
                    
                    
                    
                    /*****************/
                    
                    
                    if ([self.isSetPayPwd integerValue] == 1) {
                        FXTakeMoneyController *takeVc = [[FXTakeMoneyController alloc] initWithNumStr:self.numStr WithPayPassword:self.payPassword];
                        [self.navigationController pushViewController:takeVc animated:YES];
                    } else {
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

- (void)getMoneyNum{
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
            self.numStr = [NSString stringWithFormat:@"%@",tempDic[@"amount"]];
            if ([ZQ_CommonTool isEmpty:self.numStr]) {
                self.numStr = @"0.00";
            }
           
            if (self.numStr.length>10) {
               self.moneyNumLabel.font = [UIFont systemFontOfSize:FontRadio(44)];
            }
            self.moneyNumLabel.text = self.numStr;
            
        
            if ([userModel.identity isEqualToString:@"5"]) {
                //保证金
                self.baozhengjinNumberLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"rst"][@"margin_amount"]];
                //总额
                self.totalNumberLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"rst"][@"total_amount"]];
                
                //可结算的保证金out_money
                self.finishedBaozhengjinLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"rst"][@"out_money"]];;
            }
            
            

            self.isSetPayPwd = [NSString stringWithFormat:@"%@", tempDic[@"isSetPayPwd"]];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}


@end
