//
//  ComplaintsViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ComplaintsViewController.h"
#import "ZHShareTextView.h"

@interface ComplaintsViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) ZHShareTextView *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, copy) NSString *labelString;
@end

@implementation ComplaintsViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.labelString = @"0/500";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setUpView];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"意见反馈";
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItem
{    [self buttonPressedKeybordHidden];

    
    if ([_textView.text isEqualToString:@""]) {
        [self showHint:@"请填写反馈意见"];
        return;
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    __weak ComplaintsViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = model.userID;
    params[@"contactWay"] = _textField.text;
    params[@"content"] = _textView.text;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.feedback"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:responseObject[@"errmsg"]
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试" yOffset:-200];
    }];

}

- (void)setUpView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextViewTextDidChangeNotification object:nil];
    
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 10, ZQ_Device_Width, 150)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.textView = [[ZHShareTextView alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 24, 150)];
    _textView.placeHolder = @"告诉易推云您的意见或建议（500字以内）";
    _textView.font = [UIFont systemFontOfSize:15.];
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentJustified;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textColor = kUIColorFromRGB(0x404040);
    _textView.text = _textString;
    [view addSubview:_textView];
    
    self.label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 80, 150 - 40, 68, 40)];
    _label.textAlignment = NSTextAlignmentRight;
    _label.text = [NSString stringWithFormat:@"%@", _labelString];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = kUIColorFromRGB(0x999999);
    [view addSubview:_label];
    
    UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(view.frame) + 10, ZQ_Device_Width, 45)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 120, 45)];
    label.text = @"联系方式";
    label.textColor = kUIColorFromRGB(0x404040);
    label.font = [UIFont systemFontOfSize:15];
    [view1 addSubview:label];
    
    self.textField = [[UITextField alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(label.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(label.frame) - 22, 45)];
    _textField.placeholder = @"手机号/邮箱";
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.delegate = self;
    _textField.textColor = kUIColorFromRGB(0x808080);
    [view1 addSubview:_textField];
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

- (void)infoAction
{
    
    UITextRange *selectedRange = [_textView markedTextRange];
    
   
    //获取高亮部分
    UITextPosition *position = [_textView positionFromPosition:selectedRange.start offset:0];
    
    
    if (!position) {
        if (_textView.text.length >= 500) {
            _label.text = @"500/500";
            _labelString = _label.text;
            _textView.text = self.textString;
        } else {
            _label.text = [NSString stringWithFormat:@"%zd/500", _textView.text.length];
            _labelString = _label.text;
            self.textString = _textView.text;
        }
    }
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
