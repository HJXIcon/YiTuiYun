//
//  EPerfectInfoViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/16.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPerfectInfoViewController.h"
#import "EPerfectInfoSexCell.h"
#import "EPerfectInfoCell.h"
#import "ELoginViewModel.h"
#import "EUserModel.h"
#import "JXDatePickerView.h"
#import <JXQRCheckUp.h>

@interface EPerfectInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;
@property (nonatomic, strong) UIImageView *iconImageV;

@property (nonatomic, strong) NSArray <NSString *>*leftTitles;
@property (nonatomic, strong) UIButton *enterHomeBtn;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userBirthday;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) UIImage *userImage;
@end

@implementation EPerfectInfoViewController

#pragma mark - lazy load
- (NSArray<NSString *> *)leftTitles{
    if (_leftTitles == nil) {
        _leftTitles = @[@"姓名:",@"生日:",@"手机号码:"];
    }
    return _leftTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"完善资料";
    self.userSex = kStringIsEmpty([EUserInfoManager getUserInfo].sex) ? @"1" : [EUserInfoManager getUserInfo].sex;// 默认男
    [self setupUI];
    
}

- (void)setupUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = EBackgroundColor;

    self.enterHomeBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:18] normalColor:[UIColor whiteColor] selectColor:nil title:@"确定" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(sureAction)];
    [self.tableView addSubview:self.enterHomeBtn];
    UIImage *nornamlImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    [self.enterHomeBtn setBackgroundImage:nornamlImage forState:UIControlStateNormal];
    [self.enterHomeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    self.enterHomeBtn.cornerRadius = E_RealHeight(25);
    [self.enterHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(E_StatusBarAndNavigationBarHeight + E_RealHeight(45) * 3 + E_RealHeight(10 + 45) + [EPerfectInfoSexCell cellHeight]);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
    }];
}


#pragma mark - *** Actions

- (void)sureAction{
    
    /// 上传图片
    if (self.userImage) {
        [ELoginViewModel uploadImage:@[self.userImage] completion:^(BOOL isSuccess, NSString *errmsg,NSString *imagePath) {
            [self showHint:errmsg];
            [self editMemberInfoWithImagePath:imagePath];
        }];
    }
    else{
        
        [self editMemberInfoWithImagePath:nil];
    }
    
}


/**
 编辑资料

 @param imagePath 图片路径，不需要修改可不传
 */
- (void)editMemberInfoWithImagePath:(NSString *)imagePath{
    
    EUserModel *userModel = [EUserInfoManager getUserInfo];
    /// 判断需不需要修改图片
    if (!kStringIsEmpty(imagePath)) {
        userModel.avatar = imagePath;
    }
    
    if (!kStringIsEmpty(self.userBirthday)) {
        userModel.birthday = self.userBirthday;
    }
    if (!kStringIsEmpty(self.userName)) {
        userModel.name = self.userName;
    }
    userModel.sex = self.userSex;
    
    [ELoginViewModel editMember:userModel completion:^(BOOL isSuccess, NSString *errmsg) {
        
        if (isSuccess) {
            [EUserInfoManager updateUserInfo:^{
                
            }];
            
            if (self.status == EPerfectInfoAfterResisterStatus) {
                [EControllerManger turnToMainController];
            }else{
                [self showHint:errmsg];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JXWeak(self);
    if (indexPath.section == 0) {
        EPerfectInfoSexCell *cell = [EPerfectInfoSexCell cellForTableView:tableView];
        cell.sex = self.userSex;
        cell.sexBlock = ^(NSString *sex) {
            weakself.userSex = sex;
        };
        
        cell.iconTapBlock = ^{
            [weakself showImagePickerSheet];
        };
        
        if (!kStringIsEmpty([EUserInfoManager getUserInfo].avatar)) {
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath([EUserInfoManager getUserInfo].avatar)] placeholderImage:E_PlaceholderImage];
        }
        
        if (self.userImage) {
            cell.iconImageView.image = self.userImage;
        }
        
        return cell;
    }
    
    
    EPerfectInfoCell *cell = [EPerfectInfoCell cellForTableView:tableView];
    cell.leftLabel.text = self.leftTitles[indexPath.row];
    
    switch (indexPath.row) {
        case 0: /// 姓名
        {
            cell.rightLablel.hidden = YES;
            cell.rightTextF.hidden = NO;
            cell.arrowImageView.hidden = YES;
            if (kStringIsEmpty([EUserInfoManager getUserInfo].name)) {
                cell.rightTextF.placeholder = @"请输入你的真实姓名";
            }else{
                cell.rightTextF.text = [EUserInfoManager getUserInfo].name;
            }
            cell.rightTextFeildBlock = ^(NSString *text) {
                weakself.userName = text;
            };
        }
            break;
            
        case 1: /// 生日
        {
            cell.rightLablel.hidden = NO;
            cell.arrowImageView.hidden = NO;
            cell.rightTextF.hidden = YES;
            if (kStringIsEmpty([EUserInfoManager getUserInfo].birthday)) {
                cell.rightLablel.text = @"请选择你的生日";
            }else{
                
                cell.rightLablel.text = [[EUserInfoManager getUserInfo].birthday timeIntervalWithFormat:@"yyyy-MM-dd"];
            }
            cell.rightLablel.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
        }
            break;
            
            
        case 2: /// 手机号
        {
            cell.rightLablel.hidden = NO;
            cell.rightTextF.hidden = YES;
            cell.arrowImageView.hidden = YES;
            
            
            cell.rightLablel.text = [EUserInfoManager getUserInfo].mobile;;
            cell.rightLablel.textColor = [UIColor colorWithHexString:@"#2b2b2b"];
        }
            break;
            
            
        default:
            break;
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [EPerfectInfoSexCell cellHeight];
    }
    return E_RealHeight(45);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JXWeak(self);
    if (indexPath.section == 1 && indexPath.row == 1) {
        EPerfectInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        JXWeak(cell);
       JXDatePickerView *pickerView = [[JXDatePickerView alloc]initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *date) {
           
           weakcell.rightLablel.text = [date stringWithFormat:@"yyyy-MM-dd"];
            weakself.userBirthday = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        }];
        
        [pickerView show];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 10 : 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


#pragma mark - *** 打开相册或者拍照
- (void)showImagePickerSheet{
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

- (void)openPhotoAndScanImage:(BOOL)allowsEditing sourceType:(UIImagePickerControllerSourceType)sourceType{
    
    if (![JXQRCheckUp photoCheckUp]) {
        
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
    self.userImage = image;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


@end
