//
//  FXInPutViewController.m
//  yituiyun
//
//  Created by fx on 16/10/17.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXInPutViewController.h"

@interface FXInPutViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FXInPutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    
    self.view.backgroundColor = kUIColorFromRGB(0xededed);
    [self setUpView];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 70)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 70)];
    _nameField.text = self.textStr;
    _nameField.placeholder = [NSString stringWithFormat:@"请输入%@",self.navigationItem.title];
    _nameField.delegate = self;
    if ([self.title isEqualToString:@"电话"] || [self.title isEqualToString:@"请输入项目预算经费"] || [self.title isEqualToString:@"身高"]) {
        if ([ZQ_CommonTool isEmpty:self.textStr] || [self.textStr integerValue] == 0) {
            _nameField.placeholder = @"请输入身高";
            _nameField.text = @"";
        }
        self.nameField.keyboardType = UIKeyboardTypeNumberPad;

    }
    [backView addSubview:_nameField];
    
    if ([self.title isEqualToString:@"学历"]) {
        UIView *tipbackView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(backView.frame) + 20, self.view.frame.size.width - 20, 80)];
        tipbackView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [self.view addSubview:tipbackView];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, tipbackView.frame.size.width, 20)];
        tipLabel.text = @"提示";
        tipLabel.textColor = kUIColorFromRGB(0x808080);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:12];
        [tipbackView addSubview:tipLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tipLabel.frame), tipbackView.frame.size.width - 10, 40)];
        _nameLabel.text = @"学历请选择输入研究生、本科、专科、高中、中专、初中或小学";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nameLabel.textColor = kUIColorFromRGB(0x808080);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [tipbackView addSubview:_nameLabel];
    }
    
}

- (void)saveBtnClick{
    [self.nameField endEditing:YES];
    if ([_nameField.text isEqualToString:@""]) {
        [self showHint:@"请输入"];
        return;
    }
    if ([self.title isEqualToString:@"学历"]) {
        if ([_nameField.text isEqualToString:@"研究生"] || [_nameField.text isEqualToString:@"本科"] || [_nameField.text isEqualToString:@"专科"] || [_nameField.text isEqualToString:@"高中"] || [_nameField.text isEqualToString:@"中专"] || [_nameField.text isEqualToString:@"初中"] || [_nameField.text isEqualToString:@"小学"]) {
            
        }else{
            [self showHint:@"根据提示填写正确的学历"];
            return;
        }
    }
    if ([self.title isEqualToString:@"联系电话"]) {
        NSString *phoneStr = self.nameField.text;
        NSString* number = @"^(\\d{10})(\\d)$";
        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
        BOOL isCorrect = [numberPre evaluateWithObject:phoneStr];
        if (!isCorrect) {
            [self showHint:@"请输入正确的手机号"];
            return;
        }
    }
    if ([self.title isEqualToString:@"身份证号码"]) {
        NSString *idStr = self.nameField.text;
        NSString* rule = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *number = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
        BOOL isId = [number evaluateWithObject:idStr];
        if (!isId) {
            [self showHint:@"请输入正确的身份证号"];
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveTextWith:)]) {
        [self.delegate saveTextWith:self.nameField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameField resignFirstResponder];
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    _lineView.backgroundColor = MainColor;
//    _nameLabel.textColor = MainColor;
//    
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    _lineView.backgroundColor = kUIColorFromRGB(0xe4e4e4);
//    _nameLabel.textColor = kUIColorFromRGB(0x666666);
//    
//}

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
