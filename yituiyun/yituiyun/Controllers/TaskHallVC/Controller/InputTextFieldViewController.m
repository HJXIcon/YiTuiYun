//
//  InputTextFieldViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "InputTextFieldViewController.h"

@interface InputTextFieldViewController ()<UITextFieldDelegate>
@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation InputTextFieldViewController
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.viewTitle = title;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setUpView];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"文字描述";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItem
{
    [self buttonPressedKeybordHidden];
    if (_delegate && _index && [_delegate respondsToSelector:@selector(inputTextFieldString:WithIndex:)]){
        
        [_delegate inputTextFieldString:_textField.text WithIndex:_index];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUpView
{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    CGSize titleSize = [_viewTitle sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ZQ_Device_Width - 24, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, ZQ_Device_Width - 24, titleSize.height + 10)];
    label.text = _viewTitle;
    label.textColor = kUIColorFromRGB(0x808080);
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(label.frame), ZQ_Device_Width, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.textField = [[UITextField alloc] initWithFrame:ZQ_RECT_CREATE(12, 0, ZQ_Device_Width - 24, 70)];
    _textField.placeholder = @"请输入";
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.delegate = self;
    _textField.textColor = kUIColorFromRGB(0x404040);
    [view addSubview:_textField];
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
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
