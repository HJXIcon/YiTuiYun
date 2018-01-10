//
//  FXAddWXController.m
//  yituiyun
//
//  Created by fx on 16/11/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXAddWXController.h"
#import "FXTakeMoneyModel.h"

@interface FXAddWXController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) FXTakeMoneyModel *takeMoneyModel;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, copy) NSString *codeImg;
@end

@implementation FXAddWXController
- (instancetype)initWithNumStr:(FXTakeMoneyModel *)takeMoneyModel WithWhere:(NSInteger)where
{
    if (self = [super init]) {
        self.takeMoneyModel = takeMoneyModel;
        self.codeImg = [NSString stringWithFormat:@"%@", takeMoneyModel.wxCodeImg];
        self.where = where;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_where == 2) {
        self.title = @"更改微信";
    } else {
        self.title = @"绑定微信";
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
//    if (_where == 2) {
//        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//        self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
//    }
    [self setUpViews];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)rightBarButtonItem
//{
//    UserInfoModel *model = [ZQ_AppCache userInfoVo];
//    [self showHudInView1:self.view hint:@"加载中..."];
//    __weak FXAddWXController *weakSelf = self;
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
- (void)setUpViews{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.view.frame.size.width - 24, 40)];
    tipsLabel.text = @"请绑定您的微信账号";
    tipsLabel.textColor = kUIColorFromRGB(0xababab);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tipsLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipsLabel.frame), self.view.frame.size.width, 100)];
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
    _nameField.text = _takeMoneyModel.cardholder;
    _nameField.placeholder = @"请输入真实姓名";
    _nameField.textColor = kUIColorFromRGB(0x404040);
    [_nameField setReturnKeyType:UIReturnKeyDone];
    [backView addSubview:_nameField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(personLabel.frame), ZQ_Device_Width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView.frame), 80, 49)];
    numLabel.text = @"微信号";
    numLabel.textColor = kUIColorFromRGB(0x808080);
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:numLabel];
    
    self.numField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), CGRectGetMaxY(lineView.frame), ZQ_Device_Width - CGRectGetMaxX(numLabel.frame) - 12, 49)];
    _numField.borderStyle = UITextBorderStyleNone;
    [_numField setReturnKeyType:UIReturnKeyDone];
    _numField.font = [UIFont systemFontOfSize:15.f];
    _numField.delegate = self;
    _numField.text = _takeMoneyModel.accountNum;
    _numField.placeholder = @"请输入微信号";
    _numField.textColor = kUIColorFromRGB(0x404040);
    [backView addSubview:_numField];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLabel.frame), ZQ_Device_Width, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backView addSubview:lineView1];
    
    UILabel *imgTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(backView.frame), self.view.frame.size.width - 24, 40)];
    imgTipLabel.text = @"请上传微信收款二维码图片";
    imgTipLabel.textColor = kUIColorFromRGB(0xababab);
    imgTipLabel.textAlignment = NSTextAlignmentLeft;
    imgTipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:imgTipLabel];
    
    UIView *imgBackView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgTipLabel.frame), self.view.frame.size.width, 90)];
    imgBackView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:imgBackView];
    
    self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 80, 80)];
    _codeImgView.clipsToBounds = YES;
    _codeImgView.backgroundColor = kUIColorFromRGB(0xffffff);
    _codeImgView.userInteractionEnabled = YES;
    [_codeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _takeMoneyModel.wxCodeImg]] placeholderImage:[UIImage imageNamed:@"addImage.png"]];
    [_codeImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeViewAction)]];
    [imgBackView addSubview:_codeImgView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(12, CGRectGetMaxY(imgBackView.frame) + 30, ZQ_Device_Width - 24, 40);
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
    if ([textField.text isEqualToString:@"请输入真实姓名"] || [textField.text isEqualToString:@"请输入微信号"]) {
        textField.text = @"";
    }
    return YES;
}
- (void)codeViewAction{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {  // 拍照模式
        [self cameraClick];
    }else if (buttonIndex == 1){  // 手机相册
        [self albumClick];
    }
}
- (void)albumClick{//选择相册
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)cameraClick{//打开相机
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        self.codeImgView.image = resultImage;
    }
    [self upLoadIcon:resultImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 上传
- (void)upLoadIcon:(UIImage *)image{
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        _codeImg = string;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self upLoadIcon:image];//失败的时候重试
    }];
}
- (void)saveBtnClick{
    [self buttonPressedKeybordHidden];
    
    if ([ZQ_CommonTool isEmpty:_nameField.text] || [ZQ_CommonTool isEmpty:_numField.text] || [_nameField.text isEqualToString:@"请输入真实姓名"] || [_numField.text isEqualToString:@"请输入微信号"] || [ZQ_CommonTool isEmpty:_codeImg]) {
        [self showHint:@"请完善信息"];
        return;
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak FXAddWXController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"wxname"] = _nameField.text;
    params[@"wxcode"] = _numField.text;
    params[@"wximg"] = _codeImg;
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
