//
//  FXTakeMoneyController.m
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXTakeMoneyController.h"
#import "FXTakeMoneyModel.h"
#import "FXTakeMoneyCell.h"
#import "FXAddBankController.h"
#import "PopPasswordView.h"
#import "FXAddWXController.h"
#import "FXAddAlipayController.h"
#import "FXGetBackWalletPSDController.h"
#import "CardListModel.h"

@interface FXTakeMoneyController ()<UITableViewDelegate,UITableViewDataSource,PopPasswordViewDelegate,FXTakeMoneyCellDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) PopPasswordView *passwordView;
@property (nonatomic, copy) NSString *numStr;
@property (nonatomic, copy) NSString *payPassword;
@property(nonatomic,strong) UILabel * shoulabel;
@property(nonatomic,strong) UILabel * shijianLabel;

@end

@implementation FXTakeMoneyController

- (instancetype)initWithNumStr:(NSString *)numStr WithPayPassword:(NSString *)payPassword{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray new];
        self.numStr = numStr;
        self.payPassword = payPassword;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}

//获取路径数据
- (void)getData{
    
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.paySetting"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = userModel.userID;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            [_dataArray removeAllObjects];
            

            
            NSArray *rstArray = responseObject[@"rst"];
            if (![ZQ_CommonTool isEmptyArray:rstArray]) {
                
                
                self.dataArray= [CardListModel objectArrayWithKeyValuesArray:rstArray];
                
                
            }
            [_tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
    if ([userInfo.identity integerValue] == 6) {
        self.title = @"余额提现";
    } else if ([userInfo.identity integerValue] == 5) {
        self.title = @"余额退款";
    }
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height - 64 - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = self.footView;
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
- (UIView *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomBtn.frame = CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50);
        _bottomBtn.backgroundColor = MainColor;
        UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
        if ([userInfo.identity integerValue] == 6) {
            [_bottomBtn setTitle:@"余额提现" forState:UIControlStateNormal];
        } else if ([userInfo.identity integerValue] == 5) {
            [_bottomBtn setTitle:@"余额退款" forState:UIControlStateNormal];
        }
        [_bottomBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(takeMoneyClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:_bottomBtn];
    }
    return _bottomBtn;
}
- (UIView *)headView{
    if (!_headView) {
        UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
        if ([userInfo.identity integerValue] == 6) {
            
            return [self personHeader];

        } else if ([userInfo.identity integerValue] == 5) {
    
            return [self compayHeader];
        }

        
        
        
        
}
    return _headView;
}

//个人

-(UIView *)personHeader{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 180)];
    _headView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-20, 170)];
    backView.backgroundColor = kUIColorFromRGB(0xffffff);
    [_headView addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 150, 20)];
    titleLabel.text = @"提现金额";

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
    _moneyField.placeholder = @"请输入金额,最低5元";
    _moneyField.font = [UIFont systemFontOfSize:20];
    _moneyField.textAlignment = NSTextAlignmentLeft;
//    _moneyField.delegate = self;
    [_moneyField setKeyboardType:UIKeyboardTypeNumberPad];
    [_moneyField setReturnKeyType:UIReturnKeyDone];
        [_moneyField addTarget:self action:@selector(moneyTextField:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:_moneyField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(rmbLabel.frame), self.view.frame.size.width-20-20, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(WRadio(300)*0.5, 12, 200, 20)];
    numLabel.text = [NSString stringWithFormat:@"剩余余额%@元", _numStr];
    numLabel.textColor = kUIColorFromRGB(0x6f6f6f);
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:numLabel];
    
    
    //加两个label  手续费  实际金额
    
    UILabel *shoulabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+5, 250, 20)];
    shoulabel.text = @"手续费:0元";
    shoulabel.font = [UIFont systemFontOfSize:13];
    shoulabel.textColor = UIColorFromRGBString(@"0x393939");
    [backView addSubview:shoulabel];
    self.shoulabel = shoulabel;
    UILabel *shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(shoulabel.frame)+2, 250, 20)];
    shijianLabel.text = @"到账金额:0元";
    shijianLabel.font = [UIFont systemFontOfSize:13];
     shijianLabel.textColor = UIColorFromRGBString(@"0xf16156");
    [backView addSubview:shijianLabel];
    self.shijianLabel = shijianLabel;
    return _headView;
}

-(void)moneyTextField:(UITextField *)textField{
   
    CGFloat  inputMoney = [textField.text integerValue];
    CGFloat   totalMoney = [self.numStr integerValue];
    if (inputMoney>totalMoney) {
    [SVProgressHUD showErrorWithStatus:@"超过余额"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
    
    if ([textField.text integerValue]<=2 && [textField.text integerValue]>0) {
        self.shoulabel.text = @"手续费：2元";
        self.shijianLabel.text = @"到账金额:0元";
    }
    else if ([textField.text integerValue] <  200 && [textField.text integerValue]>2) {
        self.shoulabel.text = @"手续费：2元";
        self.shijianLabel.text = [NSString stringWithFormat:@"到账金额:%ld元",[textField.text integerValue] - 2];

    }else if ([textField.text integerValue]>=200){
        
        
        self.shoulabel.text = [NSString stringWithFormat:@"手续费:0元"];
        self.shijianLabel.text = [NSString stringWithFormat:@"实际金额:%.2f元",[textField.text floatValue]];
    }else if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:@"0"]){
        self.shoulabel.text = @"手续费：0元";
        self.shijianLabel.text = @"到账金额:0元";
    }
}


-(UIView *)compayHeader{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 180)];
    _headView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-20, 170)];
    backView.backgroundColor = kUIColorFromRGB(0xffffff);
    [_headView addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, WRadio(80), 20)];
    
    titleLabel.text = @"退款金额";

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
    
    self.moneyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rmbLabel.frame), CGRectGetMaxY(titleLabel.frame) + 10, WRadio(300), 70)];
    _moneyField.placeholder = @"请输入金额,最低5元";
    _moneyField.font = [UIFont systemFontOfSize:FontRadio(25)];
    _moneyField.textAlignment = NSTextAlignmentLeft;

//    _moneyField.delegate = self;
            [_moneyField addTarget:self action:@selector(moneyTextField:) forControlEvents:UIControlEventEditingChanged];
    [_moneyField setKeyboardType:UIKeyboardTypeNumberPad];
    [_moneyField setReturnKeyType:UIReturnKeyDone];
    [backView addSubview:_moneyField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(rmbLabel.frame), self.view.frame.size.width-20-20, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView];
    
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(WRadio(300)*0.5, 12, 200, 20)];
    numLabel.text = [NSString stringWithFormat:@"剩余余额%@元", _numStr];
    numLabel.textColor = kUIColorFromRGB(0x6f6f6f);
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:numLabel];
    
    
    //加两个label  手续费  实际金额
    
    UILabel *shoulabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+5, 250, 20)];
    shoulabel.text = @"手续费:0元";
    shoulabel.font = [UIFont systemFontOfSize:13];
    shoulabel.textColor = UIColorFromRGBString(@"0x393939");
    [backView addSubview:shoulabel];
    self.shoulabel = shoulabel;
    UILabel *shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(shoulabel.frame)+2, 250, 20)];
    shijianLabel.text = @"到账金额:0元";
    shijianLabel.font = [UIFont systemFontOfSize:13];
    shijianLabel.textColor = UIColorFromRGBString(@"0xf16156");
    [backView addSubview:shijianLabel];
    self.shijianLabel = shijianLabel;
//13922327307
    
    
    return _headView;

}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
        _footView.backgroundColor = kUIColorFromRGB(0xffffff);
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake((self.view.frame.size.width - 200) / 2, 15, 200, 40);
        addBtn.backgroundColor = kUIColorFromRGB(0xffffff);

        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@"十 添加银行卡"];
        [attstr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBString(@"0xe1e1e1") range:NSMakeRange(0, 1)];
                [attstr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBString(@"0xf16156") range:NSMakeRange(2, 5)];
        
        [addBtn setAttributedTitle:attstr forState:UIControlStateNormal];
        
        [addBtn setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBankClick) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_footView addSubview:addBtn];
    }
    return _footView;
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
        titleView.backgroundColor = [UIColor clearColor];
        [backView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
        if ([userInfo.identity integerValue] == 6) {
            titleLabel.text = @"选择提现路径";
        } else if ([userInfo.identity integerValue] == 5) {
            titleLabel.text = @"选择退款路径";
        }
        titleLabel.textColor = kUIColorFromRGB(0x808080);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleView addSubview:titleLabel];
        
        return backView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    FXTakeMoneyCell *cell = [FXTakeMoneyCell takeMoneyCellWithTableView:tableView];
     cell.indexPath = indexPath;
    CardListModel *model = self.dataArray[indexPath.section];
    cell.takeMoneyModel = model;
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FXTakeMoneyModel *model = self.dataArray[indexPath.section];
    
//    if (indexPath.section == 0) {
//        FXTakeMoneyModel *model = self.dataArray[0];
//        if ([ZQ_CommonTool isEmpty:model.accountNum]) {
//            [WCAlertView showAlertWithTitle:@"提示"
//                                    message:@"您当前还没有添加微信账户，是否要添加新账户？"
//                         customizationBlock:^(WCAlertView *alertView) {
//                             
//                         } completionBlock:
//             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                 if (buttonIndex == 1) {
//                     //微信新增
//                     FXAddWXController *wxVc = [[FXAddWXController alloc]initWithNumStr:nil WithWhere:1];
//                     [self.navigationController pushViewController:wxVc animated:YES];
//                 }
//             } cancelButtonTitle:@"取消" otherButtonTitles:@"去添加", nil];
//        } else {
//            FXAddWXController *wxVc = [[FXAddWXController alloc]initWithNumStr:model WithWhere:2];
//            [self.navigationController pushViewController:wxVc animated:YES];
//        }
//    } else
    
        if (indexPath.section == 0) {
        CardListModel *model = self.dataArray[0];
        if ([ZQ_CommonTool isEmpty:model.alicode]) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"您当前还没有添加支付宝账户，是否要添加新账户？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     //支付宝新增
                     //                     [ZQ_UIAlertView showMessage:@"支付宝新增" cancelTitle:@"确定"];
                     FXAddAlipayController *aliVc = [[FXAddAlipayController alloc]initWithNumStr:nil WithWhere:1];
                     [self.navigationController pushViewController:aliVc animated:YES];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"去添加", nil];
        } else {
            FXAddAlipayController *aliVc = [[FXAddAlipayController alloc]initWithNumStr:model WithWhere:2];
            [self.navigationController pushViewController:aliVc animated:YES];
        }
    } else {
        FXAddBankController *vc = [[FXAddBankController alloc] initWithNumStr:model WithWhere:2];
        pushToControllerWithAnimated(vc)
    }
}

- (void)buttonClickWithIndexPath:(NSIndexPath *)indexPath
{
   MJWeakSelf
    
        if (indexPath.section == 0) {
        CardListModel *model = self.dataArray[0];
        if ([ZQ_CommonTool isEmpty:model.aliname]) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"您当前还没有添加支付宝账户，是否要添加新账户？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     FXAddAlipayController *aliVc = [[FXAddAlipayController alloc]initWithNumStr:nil WithWhere:1];
                     [weakSelf.navigationController pushViewController:aliVc animated:YES];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"去添加", nil];
            return;
        }
    }
    
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        CardListModel *model1 = self.dataArray[i];
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

#pragma mark - 添加银行卡

- (void)addBankClick{
    FXAddBankController *addVc = [[FXAddBankController alloc] initWithNumStr:nil WithWhere:1];
    
    [self.navigationController pushViewController:addVc animated:YES];
}

//提现
- (void)takeMoneyClick{
    
    
    
    [_moneyField resignFirstResponder];
    if ([ZQ_CommonTool isEmpty:_moneyField.text] || [_moneyField.text doubleValue] == 0.00) {
        [self showHint:@"请输入金额"];
        return;
    }
    if ([_moneyField.text doubleValue] > [_numStr doubleValue]) {
        [self showHint:@"超出额度"];
        return;
    }
    
    if ([_moneyField.text doubleValue] < 5.00) {
        [self showHint:@"提现金额至少5元"];
        return;
    }
    
    if (![ZQ_CommonTool isValidate:@"(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)" valueString:_moneyField.text]) {
        [self showHint:@"请输入正确金额"];
        return;
    }
    
    NSInteger i = 0;
    for (CardListModel *model in self.dataArray) {
        if ([model.isChose integerValue] == 1) {
            i = 1;
            break;
        }
    }
    if (i == 1) {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:[self setMoreBackView]];
    } else {
        [self showHint:@"请选择一种方式"];
    }
}

- (UIView *)setMoreBackView{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ZQ_Device_Height)];
    _backView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.4];
    
    self.passwordView = [[PopPasswordView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height, ZQ_Device_Width, 200)];
    self.passwordView.delegate = self;
    [_backView addSubview:self.passwordView];
    
    return _backView;
}

-(void)useStoreCode:(NSString *)code
{
    [self.passwordView removeFromSuperview];
    [self.backView removeFromSuperview];
    
    UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
    if ([userInfo.identity integerValue] == 6) {
        //申请提现
        [self drawmoney:code];
    } else if ([userInfo.identity integerValue] == 5) {
        //申请退款
        [self refundmoney:code];
    }
    
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//提现
- (void)drawmoney:(NSString *)paypassword
{
    NSInteger t;
    CardListModel *model;
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        CardListModel *model1 = self.dataArray[i];
        if ([model1.isChose integerValue] == 1) {
            if (i == 0) {
                t = 2; //支付宝
            } else  {
                t = 3;//银行卡
            }
            model = self.dataArray[i];
            break;
        }
    }
    
    
    
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.drawmoney"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"memberid"] = userModel.userID;
    dic[@"paypassword"] = paypassword;
    
    dic[@"money"] = self.moneyField.text;
    
    dic[@"t"] = @(t);
   
    if (t == 3) {
        dic[@"bank_card_id"] = model.cardid;
    }
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
     
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [MobClick event:@"getMoneyNums"];
            [WCAlertView showAlertWithTitle:@"申请提现成功"
                                    message:@"款项将于1~7个工作日内到达您所选择的账户，请注意查收"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
//            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
              [weakSelf showHint:responseObject[@"errmsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

//退款
- (void)refundmoney:(NSString *)paypassword
{
    NSInteger t;
    CardListModel *model;
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        CardListModel *model1 = self.dataArray[i];
        if ([model1.isChose integerValue] == 1) {
            if (i == 0) {
                t = 2; //支付宝
            } else  {
                t = 3;//银行卡
            }
            model = self.dataArray[i];
            break;
        }
    }
    
    
    
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.drawmoney"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"memberid"] = userModel.userID;
    dic[@"paypassword"] = paypassword;
    dic[@"money"] = _moneyField.text;
    dic[@"t"] = @(t);
    
    if (t == 3) {
        dic[@"bank_card_id"] = model.cardid;
    }
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
      
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [MobClick event:@"getMoneyNums"];
            [WCAlertView showAlertWithTitle:@"申请提现成功"
                                    message:@"款项将于1~7个工作日内到达您所选择的账户，请注意查收"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
            NSLog(@"----------ceshi------");
            [weakSelf showHint:responseObject[@"errmsg"]];
//            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}



@end
