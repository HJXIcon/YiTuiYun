//
//  FXAddAlipayController.m
//  yituiyun
//
//  Created by fx on 16/11/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXAddAlipayController.h"
#import "CardListModel.h"

@interface FXAddAlipayController ()<UITextFieldDelegate>

@property (nonatomic, strong) CardListModel *takeMoneyModel;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, assign) NSInteger where;


@property(nonatomic,strong) UIView * coverView;

@property(nonatomic,strong) UIButton * coverBtn;

@end



@implementation FXAddAlipayController
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
    // Do any additional setup after loading the view.
    
     [self setUpViews];
    
    
    if (_where == 2) {
        self.title = @"支付宝已绑定";
       
        UserInfoModel *usermode = [ZQ_AppCache userInfoVo];
        if ([usermode.identity isEqualToString:@"6"]) {
            [self.view addSubview:self.coverView];
            [self.view addSubview:self.coverBtn];
        }
        
        
    } else {
        self.title = @"绑定支付宝";
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
//    if (_where == 2) {
//        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//        self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
//    }
   
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)rightBarButtonItem
//{
//    UserInfoModel *model = [ZQ_AppCache userInfoVo];
//    [self showHudInView1:self.view hint:@"加载中..."];
//    __weak FXAddAlipayController *weakSelf = self;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"uid"] = model.userID;
//    params[@"cardid"] = _takeMoneyModel.dataId;
//    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.delBankCard"];
//    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        [weakSelf hideHud];
//        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
//            [WCAlertView showAlertWithTitle:@"提示"
//                                    message:responseObject[@"errmsg"]
//                         customizationBlock:^(WCAlertView *alertView) {
//                             
//                         } completionBlock:
//             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                 if (buttonIndex == 0) {
//                     [weakSelf.navigationController popViewControllerAnimated:YES];
//                 }
//             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        } else {
//            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [weakSelf hideHud];
//        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
//    }];
//}

-(UIView *)coverView{
    if (_coverView==nil) {
        
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _coverView.backgroundColor = [UIColor clearColor];
        
    }
    return _coverView;
}

-(UIButton *)coverBtn{
    if (_coverBtn == nil) {
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(12, CGRectGetMaxY(self.coverView.frame)+60, ZQ_Device_Width - 24, 40);
        
        [saveBtn setTitle:@"修改" forState:UIControlStateNormal];
        
        [saveBtn setTintColor:kUIColorFromRGB(0xffffff)];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [[saveBtn layer] setCornerRadius:4];
        [[saveBtn layer] setMasksToBounds:YES];
        saveBtn.backgroundColor = kUIColorFromRGB(0xf16156);
        [saveBtn addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _coverBtn = saveBtn;
    }
    return _coverBtn;
}


-(void)coverBtnClick:(UIButton *)btn{
    [self.numField becomeFirstResponder];
    [self.coverView removeFromSuperview];
    [btn removeFromSuperview];
    
}
- (void)setUpViews{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.view.frame.size.width - 24, 40)];
    tipsLabel.text = @"请绑定您的支付宝账号";
    tipsLabel.textColor = kUIColorFromRGB(0xababab);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:tipsLabel];
    
       UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    CGFloat height = 0.0;
    
    if ([userModel.identity isEqualToString:@"6"]) {
        height = 150;
    }else{
        height = 100;
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    backView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backView];
    
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 80, 49)];
    personLabel.text = @"真实姓名";
    personLabel.textColor = kUIColorFromRGB(0x808080);
    personLabel.textAlignment = NSTextAlignmentLeft;
    personLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:personLabel];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(personLabel.frame), 0, ZQ_Device_Width - CGRectGetMaxX(personLabel.frame) - 12, 49)];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.font = [UIFont systemFontOfSize:15.f];
    _nameField.delegate = self;
    _nameField.placeholder = @"请输入真实姓名";
 
    
    if ([userModel.identity isEqualToString:@"5"]) {
        _nameField.userInteractionEnabled = YES;
        _nameField.text = _takeMoneyModel.aliname;

    }else{
        _nameField.userInteractionEnabled = NO;
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterName];
        _nameField.text = name;
    }
    _nameField.textColor = kUIColorFromRGB(0x404040);
    [_nameField setReturnKeyType:UIReturnKeyDone];
    [backView addSubview:_nameField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(personLabel.frame), ZQ_Device_Width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView.frame), 80, 49)];
    numLabel.text = @"支付宝账号";
    numLabel.textColor = kUIColorFromRGB(0x808080);
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:numLabel];
    
    self.numField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), CGRectGetMaxY(lineView.frame), ZQ_Device_Width - CGRectGetMaxX(numLabel.frame) - 12, 49)];
    _numField.borderStyle = UITextBorderStyleNone;
    [_numField setReturnKeyType:UIReturnKeyDone];
    _numField.font = [UIFont systemFontOfSize:15.f];
    _numField.delegate = self;
    _numField.text = _takeMoneyModel.alicode;
    _numField.placeholder = @"请输入支付宝账号";
    _numField.textColor = kUIColorFromRGB(0x404040);
    [backView addSubview:_numField];
   
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLabel.frame), ZQ_Device_Width, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView1];

    
    
    //身份证号码
    
    if ([userModel.identity isEqualToString:@"6"]){
        UILabel *shenLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView1.frame), 80, 49)];
        shenLabel.text = @"身份证号码";
        shenLabel.textColor = kUIColorFromRGB(0x808080);
        shenLabel.textAlignment = NSTextAlignmentLeft;
        shenLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:shenLabel];
        
        UITextField *shenfield = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shenLabel.frame), CGRectGetMaxY(lineView1.frame), ZQ_Device_Width - CGRectGetMaxX(shenLabel.frame) - 12, 49)];
        shenfield.borderStyle = UITextBorderStyleNone;
        [shenfield setReturnKeyType:UIReturnKeyDone];
        shenfield.font = [UIFont systemFontOfSize:15.f];
 NSString *shenid = [[NSUserDefaults standardUserDefaults] objectForKey:PersonCenterCarId];
        shenfield.text = shenid;
        
        shenfield.textColor = kUIColorFromRGB(0x404040);
        [backView addSubview:shenfield];
        
        
        //添加位置标注
        UILabel *shuominglabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(shenLabel.frame), ScreenWidth-20, 50)];
        shuominglabel.text = @"注:支付宝账号为手机号或者邮箱，请输入有效的支付宝账号，否则将会影响您的提现流程";
        shuominglabel.font = [UIFont systemFontOfSize:14];
        shuominglabel.textColor = [UIColor lightGrayColor];
        shuominglabel.numberOfLines = 2;
        [self.view addSubview:shuominglabel];

    }
    
    
    
    
    
    
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if ([userModel.identity isEqualToString:@"6"]) {
       saveBtn.frame = CGRectMake(12, CGRectGetMaxY(backView.frame) + 60, ZQ_Device_Width - 24, 40);
    }else{
       saveBtn.frame = CGRectMake(12, CGRectGetMaxY(backView.frame) + 30, ZQ_Device_Width - 24, 40);
    }
    
    if (_where == 2) {
        [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
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

-(void)buttonPressedKeybordHidden
{
    [_nameField resignFirstResponder];
    [_numField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buttonPressedKeybordHidden];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"请输入真实姓名"] || [textField.text isEqualToString:@"请输入支付宝账号"]) {
        textField.text = @"";
    }
    return YES;
}

- (void)saveBtnClick{
    [self buttonPressedKeybordHidden];
    
    if ([ZQ_CommonTool isEmpty:_nameField.text] || [ZQ_CommonTool isEmpty:_numField.text]|| [_nameField.text isEqualToString:@"请输入真实姓名"] || [_numField.text isEqualToString:@"请输入支付宝账号"]) {
        [self showHint:@"请完善信息"];
        return;
    }
    
//    if (![ZQ_CommonTool isValidate:KPredicateMoney valueString:_numField.text]) {
//        [self showHint:@"请输入正确的银行卡号"];
//        return;
//    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak FXAddAlipayController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"aliname"] = _nameField.text;
    params[@"alicode"] = _numField.text;
//    if (_where == 2) {
//        params[@"cardid"] = _takeMoneyModel.dataId;
//    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.setPaySetting"];
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
