//
//  FXAddBankController.m
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXAddBankController.h"
#import "CardListModel.h"
#import "BankNameListVC.h"
#import "NSString+LHKExtension.h"

@interface FXAddBankController ()<UITextFieldDelegate>
@property (nonatomic, strong) CardListModel *takeMoneyModel;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UIButton *bankNameField;
@property (nonatomic, strong) UITextField *branchField;
@property (nonatomic, assign) NSInteger where;
@property(nonatomic,strong) UITextField * telField;
@property(nonatomic,strong) UITextField * shengFied;
@property(nonatomic,strong) NSString * callbackblankname;
@property(nonatomic,strong) NSString * callbackblankid;

@end

@implementation FXAddBankController
- (instancetype)initWithNumStr:(CardListModel *)takeMoneyModel WithWhere:(NSInteger)where
{
    if (self = [super init]) {
        self.takeMoneyModel = takeMoneyModel;
        self.where = where;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.callbackblankname = @"";
    if (_where == 2) {
        self.title = @"修改银行卡";
    } else {
        self.title = @"添加银行卡";
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    if (_where == 2) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    }
    [self setUpViews];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItem
{
    [WCAlertView showAlertWithTitle:@"提示"
                            message:@"确认删除此银行卡信息？"
                 customizationBlock:^(WCAlertView *alertView) {
                     
                 } completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             [self delBankCard];
         }
     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)delBankCard
{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak FXAddBankController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"cardid"] = _takeMoneyModel.cardid;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.delBankCard"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:responseObject[@"errmsg"]
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

- (void)setUpViews{
    //点击键盘消失
    
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.view.frame.size.width - 24, 40)];
    tipsLabel.text = @"为了资金安全,只能绑定认证用户本人的银行卡";
    tipsLabel.textColor = kUIColorFromRGB(0x5e5e5e);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tipsLabel];
    
    UIView *backView = nil;
    
    if ([userModel.identity isEqualToString:@"6"]) { //个人
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipsLabel.frame), self.view.frame.size.width, 222)];
    }else{
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipsLabel.frame), self.view.frame.size.width, 266)];   //企业
    }
    backView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backView];
    
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 80, 44)];
    personLabel.text = @"持卡人:";
    personLabel.textColor = kUIColorFromRGB(0x5e5e5e);
    personLabel.textAlignment = NSTextAlignmentLeft;
    personLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:personLabel];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(personLabel.frame), 0, ZQ_Device_Width - CGRectGetMaxX(personLabel.frame) - 12, 44)];
    if ([userModel.identity isEqualToString:@"6"]) { //个人
        self.nameField.enabled = NO;
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterName];
        self.nameField.text = name;
        }else {
        self.nameField.enabled = YES;
        self.nameField.placeholder = @"请输入真实的姓名";
       _nameField.text = _takeMoneyModel.uname;

    }
    
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.font = [UIFont systemFontOfSize:15.f];
    _nameField.delegate = self;
    _nameField.textColor = kUIColorFromRGB(0x404040);
    [_nameField setReturnKeyType:UIReturnKeyDone];
    [backView addSubview:_nameField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(personLabel.frame), ZQ_Device_Width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView.frame), 80, 44)];
    numLabel.text = @"卡号:";
    numLabel.textColor = kUIColorFromRGB(0x5e5e5e);
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:numLabel];
    
    self.numField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), CGRectGetMaxY(lineView.frame), ZQ_Device_Width - CGRectGetMaxX(numLabel.frame) - 12, 44)];
    _numField.keyboardType = UIKeyboardTypeNumberPad;
    _numField.borderStyle = UITextBorderStyleNone;
    [_numField setReturnKeyType:UIReturnKeyDone];
    _numField.font = [UIFont systemFontOfSize:15.f];
    _numField.delegate = self;
    _numField.text = _takeMoneyModel.cardcode;
    _numField.placeholder = @"请输入银行卡号:";
    _numField.textColor = kUIColorFromRGB(0x5e5e5e);
    [backView addSubview:_numField];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLabel.frame), ZQ_Device_Width, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView1];
    
    UILabel *bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView1.frame), 80, 44)];
    bankNameLabel.text = @"银行名称:";
    bankNameLabel.textColor = kUIColorFromRGB(0x5e5e5e);
    bankNameLabel.textAlignment = NSTextAlignmentLeft;
    bankNameLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:bankNameLabel];
    
    self.bankNameField = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bankNameLabel.frame), CGRectGetMaxY(lineView1.frame), ZQ_Device_Width - CGRectGetMaxX(bankNameLabel.frame) - 12, 44)];
    self.bankNameField.titleLabel.font = [UIFont systemFontOfSize:15.0f];
 
    if ([ZQ_CommonTool isEmpty:_takeMoneyModel.bankName]) {
        [self.bankNameField setTitle:@"请选择银行卡名称" forState:UIControlStateNormal];
        [self.bankNameField setTitleColor :UIColorFromRGBString(@"0xbdbdbd") forState:UIControlStateNormal];
    }else{
    
        [self.bankNameField setTitle:_takeMoneyModel.bankName forState:UIControlStateNormal];
        self.callbackblankname = _takeMoneyModel.bankName;
        self.callbackblankid = _takeMoneyModel.bank_code;
        
        [self.bankNameField setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
    }
    
  
     self.bankNameField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.bankNameField.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.bankNameField addTarget:self action:@selector(selectBankName) forControlEvents:UIControlEventTouchUpInside];
  
    [backView addSubview:self.bankNameField];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bankNameLabel.frame), ZQ_Device_Width, 1)];
    lineView2.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView2];
    
    UILabel *branchLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView2.frame), 80, 44)];
    branchLabel.text = @"支行名:";
    branchLabel.textColor = kUIColorFromRGB(0x5e5e5e);
    branchLabel.textAlignment = NSTextAlignmentLeft;
    branchLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:branchLabel];
    
    self.branchField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(branchLabel.frame), CGRectGetMaxY(lineView2.frame), ZQ_Device_Width - CGRectGetMaxX(branchLabel.frame) - 12, 44)];
    _branchField.borderStyle = UITextBorderStyleNone;
    _branchField.font = [UIFont systemFontOfSize:15.f];
    _branchField.delegate = self;
    [_branchField setReturnKeyType:UIReturnKeyDone];
    _branchField.text = _takeMoneyModel.detailBranch;
    _branchField.placeholder = @"请输入开户行";
    _branchField.textColor = kUIColorFromRGB(0x404040);
    [backView addSubview:_branchField];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(branchLabel.frame), ZQ_Device_Width, 1)];
    lineView3.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView3];

    
    //手机号码
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView3.frame), 80, 44)];
    telLabel.text = @"手机号:";
    telLabel.textColor = kUIColorFromRGB(0x5e5e5e);
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:telLabel];
    
    self.telField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(telLabel.frame), CGRectGetMaxY(lineView3.frame), ZQ_Device_Width - CGRectGetMaxX(telLabel.frame) - 12, 44)];
    self.telField.borderStyle = UITextBorderStyleNone;
    self.telField.font = [UIFont systemFontOfSize:15.f];
    self.telField.delegate = self;
    [self.telField setReturnKeyType:UIReturnKeyDone];
    self.telField.keyboardType = UIKeyboardTypeNumberPad;
    self.telField.text = _takeMoneyModel.card_phone;
    self.telField.placeholder = @"银行预留手机号码";
    self.telField.textColor = kUIColorFromRGB(0x404040);
    [backView addSubview:self.telField];
    


    
    //身份证
    
    if ([userModel.identity isEqualToString:@"6"]) { //个人
        
    }else{
        
        UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(telLabel.frame), ZQ_Device_Width, 1)];
        lineView4.backgroundColor = kUIColorFromRGB(0xdddddd);
        [backView addSubview:lineView4];
        
        
        
        UILabel *shenLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView4.frame), 80, 44)];
        shenLabel.text = @"身份证:";
        shenLabel.textColor = kUIColorFromRGB(0x5e5e5e);
        shenLabel.textAlignment = NSTextAlignmentLeft;
        shenLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:shenLabel];
        
        self.shengFied = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shenLabel.frame), CGRectGetMaxY(lineView4.frame), ZQ_Device_Width - CGRectGetMaxX(shenLabel.frame) - 12, 44)];
        self.shengFied.borderStyle = UITextBorderStyleNone;
        self.shengFied.font = [UIFont systemFontOfSize:15.f];
        self.shengFied.delegate = self;
        [self.shengFied setReturnKeyType:UIReturnKeyDone];
        self.shengFied.text = self.takeMoneyModel.cert_id;
        self.shengFied.placeholder = @"请输入身份证号码";
        self.shengFied.textColor = kUIColorFromRGB(0x404040);
        
    
        [backView addSubview:self.shengFied];

        
    }
    
    

    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(12, CGRectGetMaxY(backView.frame) + 30, ZQ_Device_Width - 24, 40);
    if (_where == 2) {
        [saveBtn setTitle:@"修改" forState:UIControlStateNormal];
    } else {
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    [saveBtn setTintColor:kUIColorFromRGB(0xffffff)];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[saveBtn layer] setCornerRadius:4];
    [[saveBtn layer] setMasksToBounds:YES];
    saveBtn.backgroundColor = kUIColorFromRGB(0xf16156);
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:saveBtn];
    
}
#pragma mark - 银行开名称选择
-(void)selectBankName{
    BankNameListVC *listVc = [[BankNameListVC alloc]init];
  MJWeakSelf
    //银行卡的回调
    listVc.blanknameblock = ^(NSString *bankname, NSString *bankid)
    {
        [weakSelf.bankNameField setTitle:bankname forState:UIControlStateNormal];
        [weakSelf.bankNameField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        weakSelf.callbackblankname = bankname;
        weakSelf.callbackblankid = bankid;
    };
    
    [self presentViewController:listVc animated:YES completion:nil];
}
-(void)buttonPressedKeybordHidden
{
    [_nameField resignFirstResponder];
    [_numField resignFirstResponder];
    [_bankNameField resignFirstResponder];
    [_branchField resignFirstResponder];
    [_shengFied resignFirstResponder];
    [_telField resignFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buttonPressedKeybordHidden];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"请输入持卡人姓名"] || [textField.text isEqualToString:@"请输入银行卡号"] || [textField.text isEqualToString:@"请输入银行名称"] || [textField.text isEqualToString:@"请输入支行信息"]) {
        textField.text = @"";
    }
    return YES;
}

- (void)saveBtnClick{
    [self.view endEditing:YES];

    [self buttonPressedKeybordHidden];
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];


    if ([self.numField.text isEqualToString:@""]) {
        [self showHint:@"请输入卡号"];
        return ;
    }
    if ([self.callbackblankname isEqualToString:@""]) {
        [self showHint:@"请选择银行名称"];
        return ;
    }
    if ([self.branchField.text isEqualToString:@""]) {
        [self showHint:@"请输入开户行"];
        return ;
    }
    if ([NSString valiMobile:self.telField.text]  == NO) {
        [self showHint:@"请输入正确的手机号"];
        return ;
    }
    
    
    if ([model.identity isEqualToString:@"5"]) {
        
        
        
        if ([NSString judgeIdentityStringValid:self.shengFied.text] == NO) {
            [self showHint:@"请输正确的身份证号"];
            return ;
        }
        if ([self.nameField.text isEqualToString:@""]) {
            [self showHint:@"请输入姓名"];
        }
        
    }else{
        
    }

    
    
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak FXAddBankController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = model.userID;
    params[@"bankName"] = self.callbackblankname;
    params[@"cardcode"] = self.numField.text;
    params[@"detailBranch"] = self.branchField.text;
    params[@"card_phone"] = self.telField.text;
    params[@"bankCode"] = self.callbackblankid;
    if ([model.identity isEqualToString:@"5"]) {
        params[@"cert_id"]=self.shengFied.text;
        params[@"uname"] = self.nameField.text;

    }else{
        NSString *cer_id = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterCarId];
        params[@"cert_id"]=cer_id;
        params[@"uname"] = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterName];

    }
    
    
    if (_where == 2) {
        params[@"cardid"] = _takeMoneyModel.cardid;
    }else{
        params[@"cardid"] = @(0);
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.addBankCard"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSString *myerrno = [NSString stringWithFormat:@"%@",responseObject[@"errno"] ];
        if ([myerrno isEqualToString:@"0"]) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:responseObject[@"errmsg"]
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}



@end
