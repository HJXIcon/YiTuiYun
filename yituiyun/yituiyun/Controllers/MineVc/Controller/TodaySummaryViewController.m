//
//  TodaySummaryViewController.m
//  yituiyun
//
//  Created by 张强 on 2016/11/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "TodaySummaryViewController.h"
#import "ZHShareTextView.h"
#import "InformationModel.h"
#import "ZQImageAndLabelButton.h"

@interface TodaySummaryViewController ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) ZHShareTextView *textView;
@property (nonatomic, strong) NSArray *nameArray;
@property (strong, nonatomic) UIView *pickerView;
@property (nonatomic, strong) UIPickerView *pickerView1;
@property (nonatomic, strong) ZQImageAndLabelButton *hoursButton;
@property (nonatomic, copy) NSString *hoursStr;
@property (nonatomic, strong) ZQImageAndLabelButton *attendanceButton;
@property (nonatomic, copy) NSString *attendanceStr;
@property (nonatomic, strong) InformationModel *informationModel;
@property (nonatomic, assign) NSInteger where;

@property (nonatomic, assign) NSInteger seleClick;

@end

@implementation TodaySummaryViewController
- (instancetype)initWithInformationModel:(InformationModel *)model WithWhere:(NSInteger)where
{
    if (self = [super init]) {
        self.informationModel = model;
        self.where = where;
        self.nameArray = [NSArray arrayWithObjects:@"0.5小时", @"1小时", @"1.5小时", @"2小时", @"2.5小时", @"3小时", @"3.5小时", @"4小时", @"4.5小时", @"5小时", @"5.5小时", @"6小时", @"6.5小时", @"7小时", @"7.5小时", @"8小时", @"8.5小时", @"9小时", @"9.5小时", @"10小时", @"10.5小时", @"11小时", @"11.5小时", @"12小时", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setUpView];
    [self set];
}

- (void)setupNav{
    self.title = @"今日总结";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBtnDidClick)];
}

- (void)leftBtnDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpView
{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    NSString *labelStr;
    if (_where == 1 || _where == 3) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        labelStr = [NSString stringWithFormat:@"工作日志%@", currentTime];
    } else if (_where == 2 || _where == 4) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_informationModel.time integerValue]];
        NSString *currentTime = [formatter stringFromDate:confromTimesp];
        labelStr = [NSString stringWithFormat:@"工作日志%@", currentTime];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ZQ_Device_Width - 20, 50)];
    label.text = labelStr;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    self.textField = [[UITextField alloc] initWithFrame:ZQ_RECT_CREATE(10, CGRectGetMaxY(label.frame), ZQ_Device_Width - 20, 50)];
    _textField.placeholder = @"请输入标题";
    [_textField setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.delegate = self;
    _textField.textColor = kUIColorFromRGB(0x404040);
    if (_where == 2 || _where == 4) {
        _textField.userInteractionEnabled = NO;
        _textField.text = _informationModel.title;
    }
    [self.view addSubview:_textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(_textField.frame), ZQ_Device_Width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [self.view addSubview:lineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, 90, 25)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor whiteColor];
    label1.text = @"今日完成工作";
    CGSize label1Size = [label1.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 25)];
    label1.frame = ZQ_RECT_CREATE(10, CGRectGetMaxY(lineView.frame) + 10, label1Size.width, 25);
    [[label1 layer] setCornerRadius:4];
    [[label1 layer] setMasksToBounds:YES];
    label1.backgroundColor = kUIColorFromRGB(0xf9b0aa);
    [self.view addSubview:label1];
    
    UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(label1.frame), ZQ_Device_Width, ZQ_Device_Height - 64 - 55 - 55 - CGRectGetMaxY(label1.frame))];
    view1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view1];
    
    self.textView = [[ZHShareTextView alloc] initWithFrame:CGRectMake(5, 10, ZQ_Device_Width - 10, CGRectGetHeight(view1.frame) - 20)];
    _textView.placeHolder = @"请输入内容";
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:15.];
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentJustified;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textColor = kUIColorFromRGB(0x404040);
    if (_where == 2 || _where == 4) {
        _textView.userInteractionEnabled = NO;
        _textView.text = _informationModel.desc;
    }
    [view1 addSubview:_textView];
    
    self.hoursButton = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(10, ZQ_Device_Height - 64 - 55, 125, 30)];
    _hoursButton.layer.cornerRadius = 4;
    _hoursButton.layer.borderWidth = 1;
    _hoursButton.layer.borderColor = kUIColorFromRGB(0xf16156).CGColor;
    _hoursButton.imageV.frame = ZQ_RECT_CREATE(5, 6, 18, 18);
    _hoursButton.imageV.image = [UIImage imageNamed:@"workTime"];
    _hoursButton.label.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_hoursButton.imageV.frame), 0, CGRectGetWidth(_hoursButton.frame) - CGRectGetMaxX(_hoursButton.imageV.frame), 30);
    _hoursButton.label.font = [UIFont systemFontOfSize:14];
    _hoursButton.label.textAlignment = NSTextAlignmentCenter;
    _hoursButton.label.textColor = kUIColorFromRGB(0xf16156);
    _hoursButton.tag = 999;
    if (_where == 1 || _where == 3) {
        _hoursButton.label.text = @"选择工作时间";
        [_hoursButton addTarget:self action:@selector(hoursButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _hoursButton.frame = ZQ_RECT_CREATE(10, ZQ_Device_Height - 64 - 55 - 55, 125, 30);
    } else if (_where == 2 || _where == 4) {
        _hoursButton.label.text = _informationModel.jobDuration;
    }
    [self.view addSubview:_hoursButton];
    
    if (_where == 3 || _where == 4) {
        self.attendanceButton = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 10 - 125, ZQ_Device_Height - 64 - 55, 125, 30)];
        _attendanceButton.layer.cornerRadius = 4;
        _attendanceButton.layer.borderWidth = 1;
        _attendanceButton.layer.borderColor = kUIColorFromRGB(0xf16156).CGColor;
        _attendanceButton.imageV.frame = ZQ_RECT_CREATE(5, 6, 18, 18);
        _attendanceButton.imageV.image = [UIImage imageNamed:@"attendanceTypes"];
        _attendanceButton.label.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_attendanceButton.imageV.frame), 0, CGRectGetWidth(_attendanceButton.frame) - CGRectGetMaxX(_attendanceButton.imageV.frame), 30);
        _attendanceButton.label.font = [UIFont systemFontOfSize:14];
        _attendanceButton.label.textAlignment = NSTextAlignmentCenter;
        _attendanceButton.label.textColor = kUIColorFromRGB(0xf16156);
        _attendanceButton.tag = 1000;
        if (_where == 3) {
            _attendanceButton.label.text = @"选择出勤类型";
            [_attendanceButton addTarget:self action:@selector(hoursButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _attendanceButton.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 10 - 125, ZQ_Device_Height - 64 - 55 - 55, 125, 30);
        } else if (_where == 4) {
            if ([_informationModel.field integerValue] == 1) {
                _attendanceButton.label.text = @"内勤";
            } else if ([_informationModel.field integerValue] == 2) {
                _attendanceButton.label.text = @"外勤";
            }
        }
        [self.contentView addSubview:_attendanceButton];
    }
    
    if (_where == 1 || _where == 3) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, ZQ_Device_Height - 64 - 55, ZQ_Device_Width - 20, 45);
        [button setTitle:@"提交总结" forState:UIControlStateNormal];
        [button setTintColor:kUIColorFromRGB(0xffffff)];
        button.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [[button layer] setCornerRadius:4];
        [[button layer] setMasksToBounds:YES];
        button.backgroundColor = kUIColorFromRGB(0xf16156);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)set{
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, ZQ_Device_Height, ZQ_Device_Width, ZQ_Device_Height/3)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    self.pickerView1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ZQ_Device_Width, CGRectGetHeight(_pickerView.frame) - 40)];
    _pickerView1.backgroundColor = [UIColor clearColor];
    _pickerView1.delegate = self;
    _pickerView1.dataSource = self;
    [_pickerView addSubview:_pickerView1];
    [_pickerView1 reloadAllComponents];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, 10, 50, 20);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView addSubview:cancelButton];
    
    UIButton* determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(ZQ_Device_Width - 10 - 50, 10, 50, 20);
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    [determineButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView addSubview:determineButton];
}

#pragma mark - pickerview function
//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_seleClick == 1) {
        return [_nameArray count];
    }
    return 2;
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}
//返回指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  ZQ_Device_Width;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_seleClick == 1) {
        NSString *str = [_nameArray objectAtIndex:row];
        return str;
    }
    NSArray *array = @[@"内勤",@"外勤"];
    NSString *str = [array objectAtIndex:row];
    return str;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_seleClick == 1) {
        self.hoursStr = [_nameArray objectAtIndex:row];
    } else if (_seleClick == 2) {
        NSArray *array = @[@"内勤",@"外勤"];
        self.attendanceStr = [array objectAtIndex:row];
    }
}

- (void)cancelButtonClick
{
    [self ViewAnimation:self.pickerView willHidden:YES];
}

- (void)determineButtonClick
{
    [self buttonPressedKeybordHidden];
    [self ViewAnimation:self.pickerView willHidden:YES];
    if (_seleClick == 1) {
        if ([ZQ_CommonTool isEmpty:_hoursStr]) {
            _hoursStr = @"0.5小时";
        }
        self.hoursButton.label.text = _hoursStr;
    } else if (_seleClick == 2) {
        if ([ZQ_CommonTool isEmpty:_attendanceStr]) {
            _attendanceStr = @"内勤";
        }
        self.attendanceButton.label.text = _attendanceStr;
    }
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [_textField resignFirstResponder];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self ViewAnimation:self.pickerView willHidden:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self ViewAnimation:self.pickerView willHidden:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = textField.text.length - range.length + string.length;
    
    if(textField == self.textField){
        if(length > 25){
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

- (void)hoursButtonClick:(ZQImageAndLabelButton *)button
{
    if (button.tag == 999) {
        _seleClick = 1;
    } else if (button.tag == 1000) {
        _seleClick = 2;
    }
    
    [self.pickerView1 reloadAllComponents];
    [self ViewAnimation:self.pickerView willHidden:NO];
}

- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, self.view.frame.size.height, ZQ_Device_Width, ZQ_Device_Height/3);
        } else {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, self.view.frame.size.height - ZQ_Device_Height/3, ZQ_Device_Width, ZQ_Device_Height/3);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

- (void)buttonClick:(UIButton *)button{
    [self buttonPressedKeybordHidden];
    
    if ([ZQ_CommonTool isEmpty:_textField.text]) {
        [self showHint:@"标题不能为空"];
        return;
    }
    
    if ([ZQ_CommonTool isEmpty:_textView.text]) {
        [self showHint:@"内容不能为空"];
        return;
    }
    
    if ([ZQ_CommonTool isEmpty:_hoursButton.label.text] || [_hoursButton.label.text isEqualToString:@"选择工作时间"]) {
        [self showHint:@"请选择工作时间"];
        return;
    }
    
    if (_where == 3) {
        if ([ZQ_CommonTool isEmpty:_attendanceButton.label.text] || [_attendanceButton.label.text isEqualToString:@"选择出勤类型"]) {
            [self showHint:@"请选择出勤类型"];
            return;
        }
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    __weak TodaySummaryViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = model.userID;
    params[@"title"] = _textField.text;
    params[@"content"] = _textView.text;
    params[@"jobDuration"] = _hoursButton.label.text;
    if (_where == 3) {
        params[@"type"] = @"2";
        if ([_attendanceButton.label.text isEqualToString:@"内勤"]) {
            params[@"turnup"] = @"1";
        } else if ([_attendanceButton.label.text isEqualToString:@"外勤"]) {
            params[@"turnup"] = @"2";
        }
    } else if (_where == 1) {
        params[@"type"] = @"1";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.summarize"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:responseObject[@"errmsg"]
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     if(_delegate && [_delegate respondsToSelector:@selector(refreshData)])
                     {
                         [_delegate refreshData];
                     }
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
