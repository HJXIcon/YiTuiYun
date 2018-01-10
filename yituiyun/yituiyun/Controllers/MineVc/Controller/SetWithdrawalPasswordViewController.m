//
//  SetWithdrawalPasswordViewController.m
//  yituiyun
//
//  Created by 张强 on 2016/11/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "SetWithdrawalPasswordViewController.h"
#import "FXTakeMoneyController.h"

@interface SetWithdrawalPasswordViewController ()<UITextFieldDelegate>
@property(strong,nonatomic) UITextField *textField1;     //输登录密码
@property(strong,nonatomic) UITextField *textField2;     //输入密码
@property(strong,nonatomic) UITextField *textField3;     //再次输入密码
@property(assign,nonatomic) BOOL isShow;                    //密码是否显示
@property(assign,nonatomic) BOOL isShow1;                   //密码是否显示
@end

@implementation SetWithdrawalPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"设置密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView
{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    //手机号TextField
    self.textField1 = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, ZQ_Device_Width - 60, 30)];
    _textField1.placeholder = @"请输入APP登入密码";
    [_textField1 setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textField1.textAlignment = NSTextAlignmentLeft;
    _textField1.keyboardType = UIKeyboardTypeDefault;
    _textField1.font = [UIFont systemFontOfSize:15.f];
    _textField1.delegate = self;
    _textField1.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_textField1 setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textField1 setReturnKeyType:UIReturnKeyDone];
    _textField1.textColor = [UIColor blackColor];
    [self.view addSubview:_textField1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textField1.frame), ZQ_Device_Width - 40, 2)];
    lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView];
    
    //验证码TextField
    self.textField2 = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame) + 30, ZQ_Device_Width - 60, 30)];
    _textField2.placeholder = @"请输入6位数字密码";
    [_textField2 setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textField2.textAlignment = NSTextAlignmentLeft;
    _textField2.keyboardType = UIKeyboardTypeDefault;
    _textField2.font = [UIFont systemFontOfSize:15.f];
    _textField2.delegate = self;
    _textField2.secureTextEntry = YES;
    [_textField2 setKeyboardType:UIKeyboardTypeNumberPad];
    [_textField2 setReturnKeyType:UIReturnKeyDone];
    _textField2.textColor = [UIColor blackColor];
    [self.view addSubview:_textField2];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textField2.frame), ZQ_Device_Width - 40, 2)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView1];

    UIButton *eyeBtn = [[UIButton alloc]init];
    eyeBtn.frame = CGRectMake(ZQ_Device_Width - 60, CGRectGetMaxY(lineView1.frame) - 30, 25, 25);
  
    [eyeBtn setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeBtnClick1:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    self.textField3 = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView1.frame) + 30, ZQ_Device_Width - 70, 30)];
    _textField3.placeholder = @"请再次输入6位数字密码";
    [_textField3 setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textField3.textAlignment = NSTextAlignmentLeft;
    _textField3.keyboardType = UIKeyboardTypeDefault;
    _textField3.font = [UIFont systemFontOfSize:15.f];
    _textField3.delegate = self;
    _textField3.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_textField3 setKeyboardType:UIKeyboardTypeNumberPad];
    [_textField3 setReturnKeyType:UIReturnKeyDone];
    _textField3.textColor = [UIColor blackColor];
    [self.view addSubview:_textField3];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textField3.frame), ZQ_Device_Width - 40, 2)];
    lineView3.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView3];
    
    UIButton *eyeBtn1 = [[UIButton alloc]init];
    eyeBtn1.frame = CGRectMake(ZQ_Device_Width - 60, CGRectGetMaxY(lineView3.frame) - 30, 25, 25);
        [eyeBtn1 setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    [eyeBtn1 addTarget:self action:@selector(eyeBtnClick2:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn1];
    
    UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonCenter setFrame:CGRectMake(20, CGRectGetMaxY(lineView3.frame) + 30, ZQ_Device_Width - 40, 50)];
    [buttonCenter setTitle:@"确认" forState:UIControlStateNormal];
    [buttonCenter setTintColor:[UIColor whiteColor]];
    buttonCenter.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[buttonCenter layer] setCornerRadius:4];
    [[buttonCenter layer] setMasksToBounds:YES];
    buttonCenter.backgroundColor = kUIColorFromRGB(0xf16156);
    [buttonCenter addTarget:self action:@selector(buttonPressedClickStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCenter];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)eyeBtnClick1:(UIButton *)sender
{
    _textField2.secureTextEntry = _isShow;
    
    if (_isShow == NO) {
        _isShow = YES;
        
        [sender setImage:[UIImage imageNamed:@"sercert_yes"] forState:UIControlStateNormal];
    } else {
        NSString *text = _textField2.text;
        _textField2.text = @"";
        _textField2.text = text;
        [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
        _isShow = NO;
    }
}

- (void)eyeBtnClick2:(UIButton *)sender
{
    _textField3.secureTextEntry = _isShow1;
    
    if (_isShow1 == NO) {
        _isShow1 = YES;
        [sender setImage:[UIImage imageNamed:@"sercert_yes"] forState:UIControlStateNormal];
    } else {
        NSString *text = _textField3.text;
        _textField3.text = @"";
        _textField3.text = text;
                [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
        _isShow1 = NO;
    }
}

#pragma mark
#pragma mark UItextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    
    if(textField == self.textField1){
        if(proposedNewLength > 20){
            return NO;
        }
        return YES;
    }else if (textField == self.textField2){
        if(proposedNewLength > 6){
            return NO;
        }
        return YES;
    }else if (textField == self.textField3){
        if(proposedNewLength > 6){
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
}

- (void)buttonPressedClickStatus
{
    
    [self buttonPressedKeybordHidden];
    
    if ([ZQ_CommonTool isEmpty:self.textField1.text]) {
        [self showHint:@"请填写登入密码"];
        return ;
    }
    if ([ZQ_CommonTool isEmpty:self.textField2.text]) {
        [self showHint:@"请填写6位数字密码"];
        return ;
    }
    
    
    if (![self.textField2.text isEqualToString:self.textField3.text]) {
        [self showHint:@"两次密码不一致"];
        return;
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak SetWithdrawalPasswordViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = model.userID;
    params[@"password"] = _textField1.text;
    params[@"paypassword"] = _textField2.text;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.setPayPassword"];
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
