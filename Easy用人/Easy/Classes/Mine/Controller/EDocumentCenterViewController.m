//
//  EDocumentCenterViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EDocumentCenterViewController.h"
#import "EDocumentCenterTextCell.h"
#import "EDocumentCenterImageCell.h"
#import "EDocumentCenterTwoImageCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "EDocumentCenterModel.h"
#import "EMineViewModel.h"

typedef NS_ENUM(NSInteger,EDocumentCenterImageType) {
    EDocumentCenterImageIDCardFace = 1,/// 身份证正面
    EDocumentCenterImageIDCardBack,    /// 身份证反面
    EDocumentCenterImageHealth         /// 健康证
};

@interface EDocumentCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSArray *_leftTextArray;
    NSArray *_rightPlaceholderArray;
    
    UIImage *_IDCardFaceImage;
    UIImage *_IDCardBackImage;
    UIImage *_healthImage;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, assign) EDocumentCenterImageType imageType;


@end

@implementation EDocumentCenterViewController

#pragma mark - lazy load
- (EDocumentCenterModel *)model{
    if (_model == nil) {
        _model = [[EDocumentCenterModel alloc]init];
    }
    return _model;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"确认" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(sureAction)];
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, kScreenW, E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        [_sureBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _sureBtn;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = EBackgroundColor;
    }
    return _tableView;
}


- (instancetype)init{
    self = [super init];
    self.status = EDocumentCenterStatusNone;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"证件中心";
    [self setupUI];
    _leftTextArray = @[@[@"姓       名:",@"身份证号:"],@[@"健康证号:"]];
    _rightPlaceholderArray = @[@[@"请填写你真实的姓名",@"请填写你身份证号"],@[@"请填写你的健康证号"]];
}


#pragma mark - *** Private Method
- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(E_RealHeight(50));
    }];
    
    if (self.status == EDocumentCenterStatusUnderReView || self.status == EDocumentCenterStatusReViewSuceess) {
        self.sureBtn.hidden = YES;
    }else{
        self.sureBtn.hidden = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, E_RealHeight(50), 0);
    }
    
}


#pragma mark - *** Actions
- (void)sureAction{
    
    
    if (self.status == EDocumentCenterStatusUnderReView) {
        return [self showHint:@"审核中不需要再次提交"];
    }
    if (self.status == EDocumentCenterStatusReViewSuceess) {
        return [self showHint:@"审核通过不能修改"];
    }
    
    if (kStringIsEmpty(self.model.realName)) {
        return [self showHint:@"请输入姓名"];;
    }
    if (kStringIsEmpty(self.model.idcardNo)) {
        return [self showHint:@"请输入身份证号"];;
    }
    if (![JXCheckTool isIdentity:self.model.idcardNo]) {
        return [self showHint:@"身份证不合法"];
    }
    
    if (self.model.idcardImage == nil) {
        return [self showHint:@"请上传身份证照正面"];
    }
    
    if (self.model.idcardBackImage == nil) {
        return [self showHint:@"请上传身份证照反面"];
    }
    
    if (kStringIsEmpty(self.model.healthCertificateNo)) {
        return [self showHint:@"请输入健康证号"];;
    }
    
    if (self.model.healthImage == nil) {
        return [self showHint:@"请上传健康证照"];
    }
    
    [EMineViewModel applyAuthenticationWithModel:self.model completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - *** 照相或者打开相册
- (void)showImagePickerSheet{
    if (self.status == EDocumentCenterStatusUnderReView) {
        return;
    }
    
    if (self.status == EDocumentCenterStatusReViewSuceess) {
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoAndScanImage:YES sourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoAndScanImage:YES sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - *** 打开相册
- (void)openPhotoAndScanImage:(BOOL)allowsEditing sourceType:(UIImagePickerControllerSourceType)sourceType{
    
    if (![self photoCheckUp]) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置隐私中开启本程序照片权限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    
    [self presentViewController:picker animated:YES completion:nil];
}


//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSAssert([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0, @"只支持ios8.0之后系统");
    
    switch (self.imageType) {
        case EDocumentCenterImageIDCardFace:
            {
                _IDCardFaceImage = image;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                self.model.idcardImage = _IDCardFaceImage;
            }
            break;
            
        case EDocumentCenterImageIDCardBack:
        {
            _IDCardBackImage = image;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            self.model.idcardBackImage = _IDCardBackImage;
        }
            break;
            
        case EDocumentCenterImageHealth:
        {
            _healthImage = image;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            self.model.healthImage = _healthImage;
        }
            break;
            
        default:
            break;
    }
    
    
}


- (BOOL)photoCheckUp
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if ( author == ALAuthorizationStatusDenied ) {
            
            return NO;
        }
        return YES;
    }
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        
        return NO;
    }
    return YES;
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 文本cell
    if ((indexPath.section == 0 && indexPath.row < 2) || (indexPath.section == 1 && indexPath.row == 0)) {
        EDocumentCenterTextCell *cell = [EDocumentCenterTextCell cellForTableView:tableView];
        NSInteger maxLength = 0;
        if (indexPath.section == 0 && indexPath.row == 0) {
            maxLength = 20;
        }
        cell.maxLength = maxLength;
        [self configureCenterTextCell:cell indexPath:indexPath];
        return cell;
    }
    
    /// 两张图片cell
    if (indexPath.section == 0 && indexPath.row == 2) {
        EDocumentCenterTwoImageCell *cell = [EDocumentCenterTwoImageCell cellForTableView:tableView];
        [self configureCenterTwoImageCell:cell indexPath:indexPath];
        return cell;
    }
    
    /// 一张图片cell
    EDocumentCenterImageCell *cell = [EDocumentCenterImageCell cellForTableView:tableView];
    [self configureCenterImageCell:cell indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        return E_RealHeight(244);
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        return E_RealHeight(218);
    }
    
    return E_RealHeight(44);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? E_RealHeight(10) : 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

/// 初始化CenterTextCell
- (void)configureCenterTextCell:(EDocumentCenterTextCell *)cell indexPath: (NSIndexPath *)indexPath{
    JXWeak(self);
    
    cell.rightTextF.placeholder = _rightPlaceholderArray[indexPath.section][indexPath.row];
    cell.leftLabel.text = _leftTextArray[indexPath.section][indexPath.row];
    
    if (self.status == EDocumentCenterStatusUnderReView || self.status == EDocumentCenterStatusReViewSuceess) {
        cell.rightTextF.userInteractionEnabled = NO;
    }else{
         cell.rightTextF.userInteractionEnabled = YES;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { /// 姓名
            cell.rightTextF.text = self.model.realName;
        }
        else if (indexPath.row == 1){ /// 身份证号
            cell.rightTextF.text = self.model.idcardNo;
        }
    }
    
    /// 健康证号
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.rightTextF.text = self.model.healthCertificateNo;
    }
    
    /// 文本改变
    cell.rightTextDidChangeBlock = ^(NSString *text) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) { /// 姓名
                weakself.model.realName = text;
            }
            else if (indexPath.row == 1){ /// 身份证号
                weakself.model.idcardNo = text;
            }
        }
        
        /// 健康证号
        if (indexPath.section == 1 && indexPath.row == 0) {
            weakself.model.healthCertificateNo = text;
        }
        
    };
    
}

/// 初始化图片cell
- (void)configureCenterImageCell:(EDocumentCenterImageCell *)cell indexPath: (NSIndexPath *)indexPath{
    JXWeak(self);
    cell.label.text = @"点击上传健康证";
    
    /// 如果有网络路径
    if (!kStringIsEmpty(self.model.healthCertificate)) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath(self.model.healthCertificate)]];
        JXLog(@"健康证 -- %@",E_FullImagePath(self.model.healthCertificate));
    }
    
    if (_healthImage) {
        cell.imgView.image = _healthImage;
    }
    
    cell.clickImageBlock = ^{
        JXLog(@"上传健康证");
        [weakself showImagePickerSheet];
        weakself.imageType = EDocumentCenterImageHealth;
    };
}


/// 初始化两张图片cell
- (void)configureCenterTwoImageCell:(EDocumentCenterTwoImageCell *)cell indexPath: (NSIndexPath *)indexPath{
    
    JXWeak(self);
    cell.leftLabel.text = @"上传身份证正面\n(带有国徽)";
    cell.rightLabel.text = @"上传身份证反面";
    
    /// 如果有网络路径
    if (!kStringIsEmpty(self.model.idcardPositive)) {
        [cell.leftImgView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath(self.model.idcardPositive)]];
    }
    
    if (!kStringIsEmpty(self.model.idcardBack)) {
        [cell.rightImgView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath(self.model.idcardBack)]];
    }
    
    if (_IDCardFaceImage) {
        cell.leftImgView.image = _IDCardFaceImage;
    }
    if (_IDCardBackImage) {
        cell.rightImgView.image = _IDCardBackImage;
    }
    
    
    cell.clickLeftImgBlock = ^{
        JXLog(@"上传身份证正面");
        [weakself showImagePickerSheet];
        weakself.imageType = EDocumentCenterImageIDCardFace;
    };
    cell.clickRightImgBlock = ^{
        JXLog(@"上传身份证反面");
        [weakself showImagePickerSheet];
        weakself.imageType = EDocumentCenterImageIDCardBack;
    };
    
}
@end
