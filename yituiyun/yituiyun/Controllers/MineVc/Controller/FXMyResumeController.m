//
//  FXMyResumeController.m
//  yituiyun
//
//  Created by fx on 16/10/14.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXMyResumeController.h"
#import "HFPickerView.h"
#import "FXInPutViewController.h"
#import "FXUserInfoModel.h"
#import "InputTextViewController.h"
#import "ShowImageViewController.h"
@interface FXMyResumeController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,HFPickerViewDelegate,FXInPutViewControllerDelegate,InputTextViewControllerDelegate,ShowImageViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) FXUserInfoModel *resumeModel;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSString *iconUrlStr;//上传头像返回的图片url

@property (nonatomic, strong) UIButton *submitButton; //提交保存

@end

@implementation FXMyResumeController{
    NSString *_selectRow;//记录选择行
}
- (instancetype)init{
    if (self = [super init]) {
        self.resumeModel = [[FXUserInfoModel alloc]init];
        
    }
    return self;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        self.titleArray = [NSMutableArray arrayWithObjects:@[@""],@[],@[@"毕业院校",@"学历",@"工作年限",@"个人简介",@"兴趣爱好"],@[@"出生年月",@"身高",@"通讯地址",@"邮箱",@"户口所地"], nil];
        //@[@"电话",@"通讯地址",@"微信",@""]
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的简历";

    [self.view addSubview:self.tableView];
    
    [self getResumeData];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        [footer addSubview:self.submitButton];
        _tableView.tableFooterView = footer;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}
- (UIButton*)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(10, 40, self.view.frame.size.width -20, 40);
        _submitButton.layer.cornerRadius = 5;
        _submitButton.backgroundColor = MainColor;
        [_submitButton setTitle:@"提交简历" forState:UIControlStateNormal];
        [_submitButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _submitButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSMutableArray *subArray = self.titleArray[0];
     
        return subArray.count;
    }else if(section == 1){
        NSMutableArray *subArray = self.titleArray[1];
        return subArray.count;
    }else if (section == 2){
        NSMutableArray *subArray = self.titleArray[2];
        return subArray.count;
    }else if (section == 3){
        NSMutableArray *subArray = self.titleArray[3];
        
        if ([ZQ_CommonTool isEmpty:_resumeModel.ascription]) {
            return subArray.count-1;
        }
        return subArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }else{
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 0.001;
        }
    }
    return HRadio(44);
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        
//    }else if (section == 1){
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//        backView.backgroundColor = kUIColorFromRGB(0xededed);
//        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 14, 14)];
//        imgView.image = [UIImage imageNamed:@"jianliBaseinfo.png"];
//        [backView addSubview:imgView];
//        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, 10, 100, 20)];
//        titleLabel.text = @"基本信息";
//        titleLabel.textColor = kUIColorFromRGB(0x404040);
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.font = [UIFont systemFontOfSize:15];
//        [backView addSubview:titleLabel];
//        
//        
//        return backView;
//    }else if (section == 2){
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//        backView.backgroundColor = kUIColorFromRGB(0xededed);
//        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 14, 14)];
//        imgView.image = [UIImage imageNamed:@"jianliJobinfo.png"];
//        [backView addSubview:imgView];
//        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, 10, 100, 20)];
//        titleLabel.text = @"职业信息";
//        titleLabel.textColor = kUIColorFromRGB(0x404040);
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.font = [UIFont systemFontOfSize:15];
//        [backView addSubview:titleLabel];
//        
//        return backView;
//
//    }else if (section == 3){
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//        backView.backgroundColor = kUIColorFromRGB(0xededed);
//        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 14, 14)];
//        imgView.image = [UIImage imageNamed:@"jianliTel.png"];
//        [backView addSubview:imgView];
//        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, 10, 100, 20)];
//        titleLabel.text = @"联系方式";
//        titleLabel.textColor = kUIColorFromRGB(0x404040);
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.font = [UIFont systemFontOfSize:15];
//        [backView addSubview:titleLabel];
//        
//        return backView;
//
//    }
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"myResumeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.textColor = kUIColorFromRGB(0x808080);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = kUIColorFromRGB(0x808080);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, HRadio(43), ScreenWidth, 1)];
        lineView.backgroundColor = UIColorFromRGBString(@"0xededed");
        [cell addSubview:lineView];
        

    } else {
        for (UIView* tempView in cell.contentView.subviews) {
            [tempView removeFromSuperview];
        }
        cell.detailTextLabel.text = @"";
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 60 - 20, 15, 60, 60)];
            _iconView.layer.cornerRadius = 30;
            _iconView.clipsToBounds = YES;
            _iconView.userInteractionEnabled = YES;
            [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _resumeModel.personIcon]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
            [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewIBAction)]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"iconView" object:_iconView userInfo:nil];
            
//            [cell.contentView addSubview:_iconView];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if ([_resumeModel.nickName isEqualToString:@""] || !_resumeModel.nickName) {
                cell.detailTextLabel.text = @"请输入真实姓名";
            }else{
                cell.detailTextLabel.text = _resumeModel.nickName;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 1) {
            if ([_resumeModel.sex isEqualToString:@""]) {
                cell.detailTextLabel.text = @"请选择性别";
            }else{
                cell.detailTextLabel.text = _resumeModel.sex;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 2) {
            if ([_resumeModel.birthday isEqualToString:@""] || !_resumeModel.birthday || [_resumeModel.birthday isEqualToString:@"0000-00-00"]) {
                cell.detailTextLabel.text = @"请输入出身年月";
            }else{
                cell.detailTextLabel.text = _resumeModel.birthday;
               
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 3) {
            if ([_resumeModel.idCard isEqualToString:@""] || !_resumeModel.idCard) {
                cell.detailTextLabel.text = @"请输入身份证号";
            }else{
                cell.detailTextLabel.text = _resumeModel.idCard;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if ([_resumeModel.school isEqualToString:@""] || !_resumeModel.school) {
                cell.detailTextLabel.text = @"请输入您的毕业院校";
            }else{
                cell.detailTextLabel.text = _resumeModel.school;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 1) {
            if ([_resumeModel.education isEqualToString:@""] || !_resumeModel.education || [_resumeModel.education isEqualToString:@"未知"]) {
                cell.detailTextLabel.text = @"请输入您的学历";
            }else{
                cell.detailTextLabel.text = _resumeModel.education;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 2) {
            if ([_resumeModel.workYears isEqualToString:@""] || !_resumeModel.workYears || [_resumeModel.workYears isEqualToString:@"请选择"]) {
                cell.detailTextLabel.text = @"请选择工作年限";
            }else{
               
                cell.detailTextLabel.text = _resumeModel.workYears;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
//        if (indexPath.row == 3) {
//            if ([_resumeModel.jobType isEqualToString:@""] || !_resumeModel.jobType || [_resumeModel.jobType isEqualToString:@"请选择"]) {
//                cell.detailTextLabel.text = @"请选择求职类型";
//            }else{
//                cell.detailTextLabel.text = _resumeModel.jobType;
//                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
//            }
//        }
        if (indexPath.row == 3) {
            if ([_resumeModel.introduce isEqualToString:@""] || !_resumeModel.introduce) {
                cell.detailTextLabel.text = @"请填写个人简介";
            }else{
                cell.detailTextLabel.text = _resumeModel.introduce;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        
        if (indexPath.row == 4) {
            if ([_resumeModel.hobby isEqualToString:@""] || !_resumeModel.hobby) {
                cell.detailTextLabel.text = @"请填兴趣爱好";
            }else{
                cell.detailTextLabel.text = _resumeModel.hobby;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }

    }
    
    //修改的地方
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
           
            if ([_resumeModel.birthday isEqualToString:@""] || !_resumeModel.birthday || [_resumeModel.birthday isEqualToString:@"0000-00-00"]) {
                cell.detailTextLabel.text = @"请输入出身年月";
            }else{
                cell.detailTextLabel.text = _resumeModel.birthday;
               
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 1) {
            if ([_resumeModel.height isEqualToString:@""] || !_resumeModel.height || [_resumeModel.height integerValue] == 0) {
                cell.detailTextLabel.text = @"请输入身高 cm";
                
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ cm",_resumeModel.height];
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 2) {
            if ([_resumeModel.address isEqualToString:@""] || !_resumeModel.address) {
                cell.detailTextLabel.text = @"请输入地址";
            }else{
                cell.detailTextLabel.text = _resumeModel.address;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        
        if (indexPath.row == 3) {
            if ([_resumeModel.email isEqualToString:@""] || !_resumeModel.email) {
                cell.detailTextLabel.text = @"请输入邮箱";
            }else{
                cell.detailTextLabel.text = _resumeModel.email;
                cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        if (indexPath.row == 4) {
         cell.detailTextLabel.text = _resumeModel.ascription;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            NSArray *array = [NSArray arrayWithObject:_resumeModel.personIcon];
//            ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
//            vc.delegate = self;
//            [vc showMoreButton];
//            pushToControllerWithAnimated(vc)
        }
    }else if (indexPath.section == 1){//
        if (indexPath.row == 0) {//姓名
//            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
//            inputVc.title = @"请输入姓名";
//            inputVc.delegate = self;
//            _selectRow = @"10";
//            [self.navigationController pushViewController:inputVc animated:YES];
        }else if (indexPath.row == 1){//选择性别
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女",@"保密", nil];
//            actionSheet.tag = 20;
//            [actionSheet showInView:self.view];
        }else if (indexPath.row == 2){//选择生日
//            HFPickerView *timePickView = [[HFPickerView alloc]initWithPickerMode:UIDatePickerModeDate];
//            timePickView.delegate = self;
//            [timePickView showSelf];
        }else if (indexPath.row == 3){//身份证号
//            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
//            inputVc.title = @"身份证号码";
//            inputVc.textStr = _resumeModel.idCard;
//            inputVc.delegate = self;
//            _selectRow = @"13";
//            [self.navigationController pushViewController:inputVc animated:YES];
        }
    }else if (indexPath.section == 2){//
        if (indexPath.row == 0) {
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"毕业院校";
            inputVc.delegate = self;
            inputVc.textStr = _resumeModel.school;
            _selectRow = @"20";
            [self.navigationController pushViewController:inputVc animated:YES];
        }else if (indexPath.row == 1){
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"学历";
            inputVc.delegate = self;
            
            if ([_resumeModel.education isEqualToString:@"未知"]) {
                _resumeModel.education = @"";
            }
            inputVc.textStr = _resumeModel.education;
            _selectRow = @"21";
            [self.navigationController pushViewController:inputVc animated:YES];
        }else if (indexPath.row == 2){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一年", @"两年",@"三年",@"三年以上", nil];
            actionSheet.tag = 30;
            [actionSheet showInView:self.view];
        }
//        else if (indexPath.row == 3){
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全职", @"兼职",@"校园兼职", nil];
//            actionSheet.tag = 40;
//            [actionSheet showInView:self.view];
//        }
        else if (indexPath.row == 3){
            InputTextViewController *inputVc = [[InputTextViewController alloc]initWithTitle:@"个人简介" WithDesc:_resumeModel.introduce];
            inputVc.delegate = self;
            inputVc.index = indexPath;
            [self.navigationController pushViewController:inputVc animated:YES];
        }else if (indexPath.row == 4){
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"兴趣爱好";
            inputVc.delegate = self;
            inputVc.textStr = _resumeModel.hobby;
            _selectRow = @"35"; //
             [self.navigationController pushViewController:inputVc animated:YES];
        }
        
        
        
        //修改的地方
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {// 出生年月日
                        HFPickerView *timePickView = [[HFPickerView alloc]initWithPickerMode:UIDatePickerModeDate];
            
                        timePickView.delegate = self;
                        [timePickView showSelf];
       
        }else if (indexPath.row == 1){
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"身高";
            inputVc.delegate = self;
            inputVc.textStr = _resumeModel.height;
            _selectRow = @"31";
            [self.navigationController pushViewController:inputVc animated:YES];
        }else if (indexPath.row == 2){
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"通讯地址";
            inputVc.delegate = self;
            inputVc.textStr = _resumeModel.address;
            _selectRow = @"32";
            [self.navigationController pushViewController:inputVc animated:YES];
        }else if (indexPath.row == 3){
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"邮箱";
            inputVc.delegate = self;
            inputVc.textStr = _resumeModel.email;
            _selectRow = @"33";
            [self.navigationController pushViewController:inputVc animated:YES];
        }
    }
}

- (void)iconViewIBAction{
    NSArray *array = [NSArray arrayWithObject:_resumeModel.personIcon];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
    vc.delegate = self;
    [vc showMoreButton];
    pushToControllerWithAnimated(vc)
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.tag = 10;
//    
//    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 10) {
        if (buttonIndex == 0) {  // 拍照模式
            [self cameraClick];
        }else if (buttonIndex == 1){  // 手机相册
            [self albumClick];
        }
    }else if (actionSheet.tag == 20){
        if (buttonIndex == 0) {
            _resumeModel.sex = @"男";
        }else if (buttonIndex == 1){
            _resumeModel.sex = @"女";
        }else if (buttonIndex == 2){
            _resumeModel.sex = @"保密";
        }
        [self.tableView reloadData];
    }else if (actionSheet.tag == 30){
        if (buttonIndex == 0) {
            _resumeModel.workYears = @"一年";
           
        }else if (buttonIndex == 1){
            _resumeModel.workYears = @"二年";
           
        }else if (buttonIndex == 2){
            _resumeModel.workYears = @"三年";
           
        }else if (buttonIndex == 3){
            _resumeModel.workYears = @"三年以上";
           
        }
        [self.tableView reloadData];
    }else if (actionSheet.tag == 40){
        if (buttonIndex == 0) {
            _resumeModel.jobType = @"全职";
        }else if (buttonIndex == 1){
            _resumeModel.jobType = @"兼职";
        }else if (buttonIndex == 2){
            _resumeModel.jobType = @"校园兼职";
        }
        [self.tableView reloadData];
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
    //从系统相册拿到一张图片
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        self.iconView.image = resultImage;
    }
    [self upLoadIcon:resultImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 头像上传
- (void)upLoadIcon:(UIImage *)image{
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] integerValue] == 0) {
            _resumeModel.personIcon = responseObject[@"url"];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self showHint:@"请检查您的网络,重新选择头像"];
    }];
}

- (void)refreshImageUrl:(NSString *)imageUrl
{
    _resumeModel.personIcon = imageUrl;
    [self.tableView reloadData];
}

#pragma mark 生日时间选择后对时间格式处理
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withDate:(NSDate*)date{
    
    if ([date isLaterThanDate:[NSDate date]]) {
        [self showHint:@"出生日期不能晚于当前日期"];
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    _resumeModel.birthday = confromTimespStr;
    
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *confromTimespStr = [formatter stringFromDate:date];
    //    self.dataArray[0][3] = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    [self.tableView reloadData];
//    [self savePersonInfo];
    
}
#pragma mark 每行选择填写
- (void)saveTextWith:(NSString *)text{
    if ([_selectRow isEqualToString:@"10"]) {
        _resumeModel.nickName = text;
    }else if ([_selectRow isEqualToString:@"13"]){
        _resumeModel.idCard = text;
    }else if ([_selectRow isEqualToString:@"20"]){
        _resumeModel.school = text;
    }else if ([_selectRow isEqualToString:@"21"]){
        _resumeModel.education = text;
    }else if ([_selectRow isEqualToString:@"24"]){
        _resumeModel.introduce = text;
    }else if ([_selectRow isEqualToString:@"30"]){
        _resumeModel.birthday = text;
    }else if ([_selectRow isEqualToString:@"31"]){
        _resumeModel.height = text;
    }else if ([_selectRow isEqualToString:@"32"]){
        _resumeModel.address = text;
    }else if ([_selectRow isEqualToString:@"33"]){
        _resumeModel.email = text;
    }else if ([_selectRow isEqualToString:@"35"]){
        _resumeModel.hobby = text;
    }

    [self.tableView reloadData];
}

- (void)inputTextViewString:(NSString *)string WithIndex:(NSInteger)index
{
    _resumeModel.introduce = string;
    [self.tableView reloadData];
}

//提交简历
- (void)submitClick{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.saveResume"];
    NSString *sexStr;
    if ([_resumeModel.sex isEqualToString:@"男"]) {
        sexStr = @"1";
    }else if ([_resumeModel.sex isEqualToString:@"女"]){
        sexStr = @"2";
    }else{
        sexStr = @"0";
    }
    NSString *jobTypeStr;
    if ([_resumeModel.jobType isEqualToString:@"全职"]) {
        jobTypeStr = @"1";
    }else if ([_resumeModel.jobType isEqualToString:@"兼职"]){
        jobTypeStr = @"2";
    }else if ([_resumeModel.jobType isEqualToString:@"校园兼职"]){
        jobTypeStr = @"3";
    }else{
        jobTypeStr = @"0";
    }
    NSString *workYearStr;
    if ([_resumeModel.workYears isEqualToString:@"一年"]) {
        workYearStr = @"1";
    }else if ([_resumeModel.workYears isEqualToString:@"二年"]){
        workYearStr = @"2";
    }else if ([_resumeModel.workYears isEqualToString:@"三年"]){
        workYearStr = @"3";
    }else if ([_resumeModel.workYears isEqualToString:@"三年以上"]){
        workYearStr = @"4";
    }else{
        workYearStr = @"0";
    }
    
    
    NSString *educationStr;
    if ([_resumeModel.education isEqualToString:@"博士"]) {
        educationStr = @"1";
    }else if ([_resumeModel.education isEqualToString:@"研究生"]){
        educationStr = @"2";
    }else if ([_resumeModel.education isEqualToString:@"本科"]){
        educationStr = @"3";
    }else if ([_resumeModel.education isEqualToString:@"专科"]){
        educationStr = @"4";
    }else if ([_resumeModel.education isEqualToString:@"高中"]){
        educationStr = @"5";
    }else if ([_resumeModel.education isEqualToString:@"中专"]){
        educationStr = @"6";
    }else if ([_resumeModel.education isEqualToString:@"初中"]){
        educationStr = @"7";
    }else if ([_resumeModel.education isEqualToString:@"小学"]){
        educationStr = @"8";
    }else{
        educationStr = @"0";
    }
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    
   
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = userModel.userID;
    dic[@"sex"] = sexStr;
    dic[@"birthday"] =_resumeModel.birthday;
    dic[@"mobile"] = _resumeModel.telPhone;
    dic[@"address"] = _resumeModel.address;
    dic[@"jobType"] = jobTypeStr;
    dic[@"identityCard"] = _resumeModel.idCard;
    dic[@"workYears"] = workYearStr;
    dic[@"education"] =educationStr;
    dic[@"intro"] =_resumeModel.introduce;
    dic[@"height"] = _resumeModel.height;
    dic[@"address"] =_resumeModel.address;
    dic[@"email"] =_resumeModel.email;
    dic[@"school"] = _resumeModel.school;
    dic[@"hobbies"] = _resumeModel.hobby;
  
    [weakSelf showHudInView:weakSelf.view hint:@"提交中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [self showHint:@"保存成功"];
            [_tableView reloadData];
        }else{
           
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

//获取简历数据
- (void)getResumeData{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.resumeInfo"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"uid":userModel.userID
                          };
    [weakSelf showHudInView:weakSelf.view hint:@"简历加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            
            
            _resumeModel.personIcon = tempDic[@"avatar"];
            _resumeModel.nickName = tempDic[@"realName"];
            _resumeModel.sex = tempDic[@"sex_str"];
            _resumeModel.telPhone = tempDic[@"mobile"];
            
            _resumeModel.industry = tempDic[@"industry"];
            _resumeModel.industryStr = tempDic[@"industry_str"];
            _resumeModel.workYears = tempDic[@"workYears_str"];
       
            _resumeModel.jobType = tempDic[@"jobType_str"];
            _resumeModel.introduce = tempDic[@"intro"];
            _resumeModel.weichat = tempDic[@"wxcode"];
            _resumeModel.education = tempDic[@"education_str"];
            _resumeModel.school = tempDic[@"school"];
           _resumeModel.idCard = tempDic[@"identityCard"];
            
             _resumeModel.birthday = tempDic[@"birthday"];
            _resumeModel.height = tempDic[@"height"];
            _resumeModel.address = tempDic[@"address"];
            _resumeModel.email = tempDic[@"email"];
            _resumeModel.hobby = tempDic[@"hobbies"];
            
            NSString *ascriptionStr = [NSString stringWithFormat:@"%@",tempDic[@"ascription"]];
            _resumeModel.ascription = ascriptionStr;
            
            
        }else if ([responseObject[@"errno"] isEqualToString:@"1"]){//简历没有数据，请求个人信息接口
            [weakSelf getPersonInfoData];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
    }];
}
//先拿个人资料的数据
- (void)getPersonInfoData{
    __weak FXMyResumeController *weakSelf = self;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    params[@"uModelid"] = userModel.identity;
    params[@"uid"] = userModel.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.basicInfo"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            _resumeModel.personIcon = tempDic[@"avatar"];
            _resumeModel.nickName = tempDic[@"nickname"];
            _resumeModel.sex = tempDic[@"sex_str"];
            _resumeModel.telPhone = tempDic[@"mobile"];
            _resumeModel.address = tempDic[@"address"];
            _resumeModel.industry = tempDic[@"industry"];
            _resumeModel.industryStr = tempDic[@"industry_str"];
            _resumeModel.workYears = tempDic[@"workYears_str"];
            _resumeModel.jobType = tempDic[@"jobType_str"];
            _resumeModel.introduce = tempDic[@"intro"];
            _resumeModel.birthday = tempDic[@"birthday"];
            _resumeModel.school = @"";
            _resumeModel.idCard = @"";
            _resumeModel.weichat = @"";
            if ([tempDic[@"education"] isEqualToString:@"1"]) {
                _resumeModel.education = @"";
            }else if ([tempDic[@"education"] isEqualToString:@"2"]){
                _resumeModel.education = @"研究生";
            }else if ([tempDic[@"education"] isEqualToString:@"3"]){
                _resumeModel.education = @"本科";
            }else if ([tempDic[@"education"] isEqualToString:@"4"]){
                _resumeModel.education = @"专科";
            }else if ([tempDic[@"education"] isEqualToString:@"5"]){
                _resumeModel.education = @"高中";
            }else if ([tempDic[@"education"] isEqualToString:@"6"]){
                _resumeModel.education = @"中专";
            }else if ([tempDic[@"education"] isEqualToString:@"7"]){
                _resumeModel.education = @"初中";
            }else if ([tempDic[@"education"] isEqualToString:@"8"]){
                _resumeModel.education = @"小学";
            }
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        
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
