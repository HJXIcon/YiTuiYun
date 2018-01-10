//
//  FXChangePhoneController.m
//  yituiyun
//
//  Created by fx on 16/10/31.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXChangePhoneController.h"
#import "FXChangeNewPhoneController.h"

@interface FXChangePhoneController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneField;   //手机号
@property (nonatomic, strong) UITextField *passwordField;//密码
@property (nonatomic, strong) UIButton *testBtn;//验证按钮
@property (nonatomic, strong) UIImageView *eyeView;
@property(assign,nonatomic) BOOL isShow;                    //密码是否显示

@end

@implementation FXChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更换手机号";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    [self setUpViews];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpViews{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    self.phoneField =  [[UITextField alloc] initWithFrame:CGRectMake(30, 30, ZQ_Device_Width - 60, 30)];
    _phoneField.placeholder = @"请输入目前绑定的手机号";
    [_phoneField setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _phoneField.textAlignment = NSTextAlignmentLeft;
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.font = [UIFont systemFontOfSize:15.f];
    _phoneField.delegate = self;
    _phoneField.textColor = [UIColor blackColor];
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneField.frame), ZQ_Device_Width - 40, 2)];
    lineView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [self.view addSubview:lineView];
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame) + 30, ZQ_Device_Width - 70, 30)];
    _passwordField.placeholder = @"请输入登录密码";
    [_passwordField setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _passwordField.textAlignment = NSTextAlignmentLeft;
    _passwordField.keyboardType = UIKeyboardTypeDefault;
    _passwordField.font = [UIFont systemFontOfSize:15.f];
    _passwordField.delegate = self;
    _passwordField.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_passwordField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    _passwordField.textColor = [UIColor blackColor];
    [self.view addSubview:_passwordField];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_passwordField.frame), ZQ_Device_Width - 40, 2)];
    lineView1.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [self.view addSubview:lineView1];
    
    UIButton *eyeBtn = [[UIButton alloc]init];
    eyeBtn.frame = CGRectMake(ZQ_Device_Width - 60, CGRectGetMaxY(lineView1.frame) - 30, 25, 25);
    [eyeBtn setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    
    [eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    self.testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _testBtn.frame = CGRectMake(20, CGRectGetMaxY(lineView1.frame) + 30, self.view.frame.size.width - 40, 50);
    [_testBtn setTintColor:kUIColorFromRGB(0xffffff)];
    _testBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[_testBtn layer] setCornerRadius:4];
    [[_testBtn layer] setMasksToBounds:YES];
    _testBtn.backgroundColor = kUIColorFromRGB(0xf16156);
    [_testBtn setTitle:@"验证" forState:UIControlStateNormal];
    [_testBtn addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testBtn];
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [_phoneField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

#pragma mark UItextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    
    if(textField == self.phoneField){
        if(proposedNewLength > 11){
            return NO;
        }
        return YES;
    }else if (textField == self.passwordField){
        if(proposedNewLength > 20){
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
- (void)eyeBtnClick:(UIButton *)sender{
    _passwordField.secureTextEntry = _isShow;
    
    if (_isShow == NO) {
        _isShow = YES;
                [sender setImage:[UIImage imageNamed:@"sercert_yes"] forState:UIControlStateNormal];
    } else {
        NSString *text = _passwordField.text;
        _passwordField.text = @"";
        _passwordField.text = text;
        [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
        _isShow = NO;
    }
}
- (void)testBtnClick{
    [self buttonPressedKeybordHidden];
    
    //手机位判断
    if (_phoneField.text.length < 11 || [ZQ_CommonTool isEmpty:_phoneField.text]) {
        [ZQ_UIAlertView showMessage:@"请输入11位手机号" cancelTitle:@"确定"];
        return;
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView1:self.view hint:@"验证中..."];
    __weak FXChangePhoneController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _phoneField.text;
    params[@"password"] = _passwordField.text;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *subDic = responseObject[@"rst"];
            if ([subDic[@"uid"] integerValue] == [model.userID integerValue]) {
                FXChangeNewPhoneController *newVc = [[FXChangeNewPhoneController alloc] init];
                [weakSelf.navigationController pushViewController:newVc animated:YES];
            } else {
                [ZQ_UIAlertView showMessage:@"验证失败，请输入正确的手机号" cancelTitle:@"确定"];
            }
        } else {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"验证失败，请问是否重新验证"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [self testBtnClick];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"重新验证", nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"验证失败，请问是否重新验证"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [self testBtnClick];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重新验证", nil];
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
