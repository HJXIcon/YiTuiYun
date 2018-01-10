//
//  InputTextViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "InputTextViewController.h"
#import "ZHShareTextView.h"

@interface InputTextViewController ()<UITextViewDelegate>
@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, strong) ZHShareTextView *textView;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, copy) NSString *labelString;
@end

@implementation InputTextViewController
- (instancetype)initWithTitle:(NSString *)title WithDesc:(NSString *)desc
{
    self = [super init];
    if (self) {
        self.viewTitle = title;
        self.textString = desc;
        self.labelString = [NSString stringWithFormat:@"%zd/100",  desc.length];
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
    self.title = _viewTitle;
    
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
    if (_delegate && _index && [_delegate respondsToSelector:@selector(inputTextViewString:WithIndex:)]){
        
        [_delegate inputTextViewString:_textView.text WithIndex:_index];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUpView
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextViewTextDidChangeNotification object:nil];
    
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 10, ZQ_Device_Width, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.textView = [[ZHShareTextView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 200)];
    _textView.placeHolder = [NSString stringWithFormat:@"请输入%@", _viewTitle];
    _textView.font = [UIFont systemFontOfSize:15.];
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentJustified;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textColor = kUIColorFromRGB(0x404040);
    _textView.text = _textString;
    [view addSubview:_textView];
    
    self.label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 80, 200 - 40, 68, 40)];
    _label.textAlignment = NSTextAlignmentRight;
    _label.text = [NSString stringWithFormat:@"%@", _labelString];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = kUIColorFromRGB(0x999999);
//    [view addSubview:_label];
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [_textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)infoAction
{
    
    UITextRange *selectedRange = [_textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [_textView positionFromPosition:selectedRange.start offset:0];
    
    if (!position) {
        if (_textView.text.length > 100) {
            _label.text = @"100/100";
            _labelString = _label.text;
            _textView.text = self.textString;
        } else {
            _label.text = [NSString stringWithFormat:@"%zd/100", _textView.text.length];
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
