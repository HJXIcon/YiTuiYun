//
//  FXPersonInfoController.m
//  yituiyun
//
//  Created by fx on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXPersonInfoController.h"
#import "FXInPutViewController.h"
#import "HFPickerView.h"
#import "FXPersonInfoCell.h"
#import "UploadImageModel.h"
#import "ShowImageViewController.h"
#import "ZYQAssetPickerController.h"
#import "KNPickerController.h"
#import "FXUserInfoModel.h"
#import "FXListModel.h"
#import "FXUpLoadImageCell.h"
#import "FXChangePhoneController.h"

#import <ShareSDK/ShareSDK.h>
#import "ThirdPartyChooseController.h"
#import "IdentityChooseViewController.h"
#import "InputTextViewController.h"


@interface FXPersonInfoController ()<UITableViewDelegate,UITableViewDataSource,FXInPutViewControllerDelegate,HFPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ShowImageViewControllerDelegate,FXUpLoadImageCellDelegate,ZYQAssetPickerControllerDelegate,UIAlertViewDelegate,InputTextViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) FXUserInfoModel *userModel;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSString *iconUrlStr;//上传头像返回的图片url

@property (nonatomic, strong) NSMutableArray *idImageArray;//身份证图片数组
@property (nonatomic, strong) FXUpLoadImageCell *chooseImageCell;
@property (nonatomic, strong) NSIndexPath *seledIndexPath;

@property (nonatomic, strong) NSMutableArray *typeArray;//行业数据
@property (nonatomic, strong) UILabel *tipLabel;//
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) UIImageView *triangleView;

@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *nickname;

@end

@implementation FXPersonInfoController{
    NSString *_selectRow;//记录选择行
    NSString *_imgSelect;//记录图片选择(区别头像和身份证) 头像10 身份证20 30
    BOOL _isFold;//x下拉选项是否收起
    NSInteger _idImgNum;
}
- (instancetype)init{
    if (self = [super init]) {
        self.userModel = [[FXUserInfoModel alloc]init];
        
    }
    return self;
}
- (NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray new];
    }
    return _typeArray;
}

- (NSMutableArray *)idImageArray{
    if (!_idImageArray) {
        _idImageArray = [NSMutableArray new];
    }
    return _idImageArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@[@""],@[@"名称",@"电话"],@[@"昵称",@"性别",@"出生年月",@"电话",@"通讯地址",@"学历",@"行业",@"工作年限",@"求职类型",@"微信绑定",@""],@[@"兴趣爱好",@"身高",@"个人简介"], nil];
        
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tipLabel.text = @"请选择感兴趣的行业";
    self.title = @"个人信息";
    [self.view addSubview:self.tableView];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self getPersonData];
    [self getIndustryList];
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
        _tableView.tag = 10;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 10) {
        return 4;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        if (section == 0) {
            NSMutableArray *subArray = self.titleArray[0];
            return subArray.count;
        }else if(section == 1){
            if ([ZQ_CommonTool isEmptyDictionary:_userModel.refersDic]) {
                return 0;
            }else{
                NSMutableArray *subArray = self.titleArray[1];
                return subArray.count;
                
            }

            
        }else if (section == 2){
            NSMutableArray *subArray = self.titleArray[2];
            return subArray.count;
            
        }else if (section == 3){
            NSMutableArray *subArray = self.titleArray[3];
            return subArray.count;
        }
    }else{
        return self.typeArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        
        if (section == 0) {
            
            return 10;
        }else if(section == 1){
        if ([ZQ_CommonTool isEmptyDictionary:_userModel.refersDic]) {
                    return 0.0001;
            }
            return 50;
        }else{
            return 50;
        }
    }else{
        return 0.000001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView.tag == 10) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 90;
            }
        }else if (indexPath.section == 1){
            return 44;
        }
        else if (indexPath.section == 2){
            if (indexPath.row == 10) { // 实名认证
                return 0.001;
            }
        }
        return 40;
    }else{
        return 40;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        if (section == 0) {
            
        }else if (section == 1){
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            backView.backgroundColor = [UIColor clearColor];
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            titleView.backgroundColor = kUIColorFromRGB(0xffffff);
            [backView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLabel.text = @"推荐人的信息";
            
            if ([ZQ_CommonTool isEmptyDictionary:self.userModel.refersDic]) {
                titleLabel.text = @"基本信息";
            }else{
                titleLabel.text = @"推荐人信息";
            }
            titleLabel.textColor = kUIColorFromRGB(0x404040);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [titleView addSubview:titleLabel];
            
            return backView;
        }
        
        
        else if (section == 2){
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            backView.backgroundColor = [UIColor clearColor];
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            titleView.backgroundColor = kUIColorFromRGB(0xffffff);
            [backView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLabel.text = @"基本信息(必填)";
            titleLabel.textColor = kUIColorFromRGB(0x404040);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [titleView addSubview:titleLabel];
            
            return backView;
        }else if (section == 3){
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 50)];
            backView.backgroundColor = [UIColor clearColor];
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            titleView.backgroundColor = kUIColorFromRGB(0xffffff);
            [backView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLabel.text = @"常用信息(选填)";
            titleLabel.textColor = kUIColorFromRGB(0x404040);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [titleView addSubview:titleLabel];
            
            return backView;
            
        }

    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        FXPersonInfoCell *cell = [[FXPersonInfoCell alloc]init];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 20)];
                nameLabel.text = @"上传头像";
                nameLabel.textColor = kUIColorFromRGB(0x404040);
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:nameLabel];
                
                self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 60 - 20, 15, 60, 60)];
                _iconView.layer.cornerRadius = 30;
                _iconView.clipsToBounds = YES;
                _iconView.userInteractionEnabled = YES;
                [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _userModel.personIcon]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
                [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewIBAction)]];
                [cell.contentView addSubview:_iconView];
            }
        }
        
        
        if (indexPath.section == 1) {
            
            cell.detailLabel.hidden = NO;
            
            cell.telNumLabel.hidden = YES;
            cell.changeTelBtn.hidden = YES;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            
            if ([ZQ_CommonTool isEmptyDictionary:_userModel.refersDic]) {
                
            }else{
                if (indexPath.row == 0) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",_userModel.refersDic[@"nickname"]];
                    
                }else{
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",_userModel.refersDic[@"mobile"]];
                }
            }    }

        
        if (indexPath.section == 2){
            cell.detailLabel.hidden = NO;
            cell.telNumLabel.hidden = YES;
            cell.changeTelBtn.hidden = YES;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            
            /// 昵称
            if (indexPath.row == 0) {
                if ([_userModel.nickName isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入昵称";
                }else{
                    cell.detailLabel.text = _userModel.nickName;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 性别
            if (indexPath.row == 1) {
                if ([_userModel.sex isEqualToString:@""] || [_userModel.sex isEqualToString:@"0"] || [_userModel.sex isEqualToString:@"保密"]) {
                    cell.detailLabel.text = @"请选择性别";
                }else{
                    cell.detailLabel.text = _userModel.sex;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 出身年月
            if (indexPath.row == 2) {
                if ([_userModel.birthday isEqualToString:@""] || [_userModel.birthday isEqualToString:@"0000-00-00"]) {
                    cell.detailLabel.text = @"请选择出身年月";
                }else{
                    cell.detailLabel.text = _userModel.birthday;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 电话
            if (indexPath.row == 3) {
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = NO;
                cell.changeTelBtn.hidden = NO;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                cell.telNumLabel.text = _userModel.telPhone;
                [cell.changeTelBtn addTarget:self action:@selector(changeTelPhone) forControlEvents:UIControlEventTouchUpInside];
            }
            
            /// 通讯地址
            if (indexPath.row == 4) {
                if ([_userModel.address isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入常驻地址";
                }else{
                    cell.detailLabel.text = _userModel.address;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 学历
            if (indexPath.row == 5) {
                if ([_userModel.education isEqualToString:@"0"]) {
                    cell.detailLabel.text = @"学历";
                }
//                else if ([_userModel.education isEqualToString:@"1"]){
//                    cell.detailLabel.text = @"博士";
//                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
//                }
                else if ([_userModel.education isEqualToString:@"2"]){
                    cell.detailLabel.text = @"研究生";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }else if ([_userModel.education isEqualToString:@"3"]){
                    cell.detailLabel.text = @"本科";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }else if ([_userModel.education isEqualToString:@"4"]){
                    cell.detailLabel.text = @"专科";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }else if ([_userModel.education isEqualToString:@"5"]){
                    cell.detailLabel.text = @"高中";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }else if ([_userModel.education isEqualToString:@"6"]){
                    cell.detailLabel.text = @"中专";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }else if ([_userModel.education isEqualToString:@"7"]){
                    cell.detailLabel.text = @"初中";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }else if ([_userModel.education isEqualToString:@"8"]){
                    cell.detailLabel.text = @"小学";
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 行业
            if (indexPath.row == 6){
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                UIButton *choseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                choseButton.frame = CGRectMake(self.view.frame.size.width - 200, 3, 190, 34);
                choseButton.layer.cornerRadius = 2;
                choseButton.layer.borderWidth = 1;
                choseButton.layer.borderColor = kUIColorFromRGB(0xe1e1e1).CGColor;
                choseButton.backgroundColor =[UIColor whiteColor];
                [choseButton setTitle:@"" forState:UIControlStateNormal];
                [choseButton setTitleColor:MainColor forState:UIControlStateNormal];
                [choseButton addTarget:self action:@selector(choseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                _isFold = YES;
                [cell.contentView addSubview:choseButton];
                
                self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 34)];
                if ([ZQ_CommonTool isEmpty:_userModel.industry] || [_userModel.industry isEqualToString:@"0"]) {
                    _tipLabel.text = @"请选择感兴趣的行业";
                    _tipLabel.textColor = kUIColorFromRGB(0x808080);
                }else{
                    _tipLabel.text = _userModel.industryStr;
                    _tipLabel.textColor = kUIColorFromRGB(0x404040);
                }
                _tipLabel.textAlignment = NSTextAlignmentCenter;
                _tipLabel.font = [UIFont systemFontOfSize:14];
                [choseButton addSubview:_tipLabel];

                self.triangleView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 11, 10, 14, 14)];
                _triangleView.image = [UIImage imageNamed:@"jianangel.png"];
                [choseButton addSubview:_triangleView];

            }
            /// 工作年限
            if (indexPath.row == 7) {
                if ([_userModel.workYears isEqualToString:@""] || [_userModel.workYears isEqualToString:@"请选择"]) {
                    cell.detailLabel.text = @"请选择自己的工作年限";
                }else{
                    cell.detailLabel.text = _userModel.workYears;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 求职类型
            if (indexPath.row == 8) {
                if ([_userModel.jobType isEqualToString:@""] || [_userModel.jobType isEqualToString:@"请选择"]) {
                    cell.detailLabel.text = @"请选择求职类型";
                }else{
                    cell.detailLabel.text = _userModel.jobType;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 微信绑定
            if (indexPath.row == 9) {
                if ([_userModel.weichat isEqualToString:@""] || !_userModel.weichat) {
                    cell.detailLabel.text = @"去绑定";
                }else{
                    cell.detailLabel.text = @"去修改";
                }
                
            }
            /// 实名认证
            if (indexPath.row == 10){
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 20)];
                tipLabel.text = @"实名认证(上传身份证正反面照片)";
                tipLabel.textColor = kUIColorFromRGB(0x666666);
                tipLabel.textAlignment = NSTextAlignmentLeft;
                tipLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:tipLabel];
                
                FXUpLoadImageCell *idCell = [FXUpLoadImageCell cellWithTableView:tableView];
//                _chooseImageCell = idCell;
//                idCell.indexPath = indexPath;
//                idCell.delegate = self;
////                UploadImageModel *imageModel = self.idImageArray[indexPath.row];
//                idCell.nameLabel.text = @"实名认证(上传身份证正反面照片)";
//                idCell.maxNum = 1;
//                [idCell.imageArray removeAllObjects];
//                [idCell.imageArray addObjectsFromArray:self.idImageArray];
//                [idCell makeView];
//                idCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                idCell.accessoryType = UITableViewCellAccessoryNone;
                return idCell;
                
            }
             
             
            
        }if (indexPath.section == 3) {
            cell.detailLabel.hidden = NO;
            cell.telNumLabel.hidden = YES;
            cell.changeTelBtn.hidden = YES;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            
            /// 兴趣爱好
            if (indexPath.row == 0) {
                if ([_userModel.hobby isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入您的兴趣爱好";
                }else{
                    cell.detailLabel.text = _userModel.hobby;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 身高
            if (indexPath.row == 1) {
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = NO;
                cell.cmLabel.hidden = NO;
                if ([_userModel.height isEqualToString:@""] || [_userModel.height isEqualToString:@"0"]) {
                    cell.heightLabel.text = @"请填写身高";
                }else{
                    cell.heightLabel.text = _userModel.height;
                    cell.heightLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            /// 个人简历
            if (indexPath.row == 2) {
                if ([_userModel.introduce isEqualToString:@""]) {
                    cell.detailLabel.text = @"请填写个人简介";
                }else{
                    cell.detailLabel.text = _userModel.introduce;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            
            
             
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"jobTypeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jobTypeCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = kUIColorFromRGB(0x404040);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        FXListModel *model = _typeArray[indexPath.row];
        cell.textLabel.text = model.title;
        cell.backgroundColor = kUIColorFromRGB(0xededed);
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 10) {
        _isFold = YES;
        [self untransform];
//        _tipLabel.text = _typeArray[indexPath.row];
        [_typeTableView removeFromSuperview];

        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                NSArray *array = [NSArray arrayWithObject:_userModel.personIcon];
                ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
                vc.delegate = self;
                [vc showMoreButton];
                pushToControllerWithAnimated(vc)
            }
        }else if (indexPath.section == 1){
            
        }
        
        else if (indexPath.section == 2){//
            
            if (indexPath.row == 0) {//姓名
//                if ([_userModel.nickName isEqualToString:@""]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重要信息，请慎重填写" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去填写", nil];
                    alertView.tag = 10;
                    [alertView show];
//                }
            }else if (indexPath.row == 1){//选择性别
//                if ([_userModel.sex isEqualToString:@""] || [_userModel.sex isEqualToString:@"0"] || [_userModel.sex isEqualToString:@"保密"]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重要信息，请慎重选择" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去填写", nil];
                    alertView.tag = 11;
                    [alertView show];
//                }
            }else if (indexPath.row == 2){//出生年月
//                if ([_userModel.birthday isEqualToString:@""] || [_userModel.birthday isEqualToString:@"0000-00-00"]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重要信息，请慎重选择" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去填写", nil];
                    alertView.tag = 12;
                    [alertView show];
//                }
             }else if (indexPath.row == 3){//电话
                
            }else if (indexPath.row == 4){//通讯地址
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"常住地址";
                inputVc.delegate = self;
                inputVc.textStr = _userModel.address;
                _selectRow = @"14";
                [self.navigationController pushViewController:inputVc animated:YES];
            }else if (indexPath.row == 5){
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"学历";
                inputVc.delegate = self;
                if ([_userModel.education isEqualToString:@"0"]) {
                    
                }
//                else if ([_userModel.education isEqualToString:@"1"]){
//                    inputVc.textStr = @"博士";
//                }
                else if ([_userModel.education isEqualToString:@"2"]){
                    inputVc.textStr = @"研究生";
                }else if ([_userModel.education isEqualToString:@"3"]){
                    inputVc.textStr = @"本科";
                }else if ([_userModel.education isEqualToString:@"4"]){
                    inputVc.textStr = @"专科";
                }else if ([_userModel.education isEqualToString:@"5"]){
                    inputVc.textStr = @"高中";
                }else if ([_userModel.education isEqualToString:@"6"]){
                    inputVc.textStr = @"中专";
                }else if ([_userModel.education isEqualToString:@"7"]){
                    inputVc.textStr = @"初中";
                }else if ([_userModel.education isEqualToString:@"8"]){
                    inputVc.textStr = @"小学";
                }
                _selectRow = @"15";
                [self.navigationController pushViewController:inputVc animated:YES];
            }else if (indexPath.row == 6){//选择行业
                
            }else if (indexPath.row == 7){//年限
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一年", @"两年",@"三年",@"三年以上", nil];
                actionSheet.tag = 30;
                [actionSheet showInView:self.view];
            }else if (indexPath.row == 8){
                UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
                if ([userInfo.isChange integerValue] == 1) {
                    [ZQ_UIAlertView showMessage:@"您正在申请全职，暂时不可以更换别的求职类型" cancelTitle:@"确定"];
                } else {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全职", @"兼职",@"校园兼职", nil];
                    actionSheet.tag = 40;
                    [actionSheet showInView:self.view];
                }
            } else if (indexPath.row == 9){//绑定微信
                [self thirdPartyButtonClick];
            } else if (indexPath.row == 10){
                
            }
            
            
        }else if (indexPath.section == 3){//
            if (indexPath.row == 0) {
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"兴趣爱好";
                inputVc.delegate = self;
                inputVc.textStr = _userModel.hobby;
                _selectRow = @"20";
                [self.navigationController pushViewController:inputVc animated:YES];
            }else if (indexPath.row == 1){
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"身高";
                inputVc.delegate = self;
                inputVc.textStr = _userModel.height;
                _selectRow = @"21";
                [self.navigationController pushViewController:inputVc animated:YES];
            }else if (indexPath.row == 2){
                InputTextViewController *inputVc = [[InputTextViewController alloc]initWithTitle:@"个人简介" WithDesc:_userModel.introduce];
                inputVc.delegate = self;
                inputVc.index = indexPath;
                [self.navigationController pushViewController:inputVc animated:YES];
            }
        }

    }else{
        _isFold = YES;
        [self untransform];
        FXListModel *model = _typeArray[indexPath.row];
        _tipLabel.text = model.title;
        _userModel.industryStr = model.title;
        _userModel.industry = model.linkID;
        [_typeTableView removeFromSuperview];
        [self savePersonInfo];
    }
}
#pragma mark 更改电话
- (void)changeTelPhone{
    FXChangePhoneController *changeVc = [[FXChangePhoneController alloc]init];
    [self.navigationController pushViewController:changeVc animated:YES];
}
#pragma mark 下拉选项
//选择行业
- (void)choseButtonClick:(UIButton *)button{
    if (_isFold) {
        _isFold = NO;
        [self transform];
        CGRect rect = [button.superview convertRect:CGRectMake(button.x, button.y, button.width, button.height) toView:_tableView];
        
        self.typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 34, rect.size.width, rect.size.height * 6) style:UITableViewStyleGrouped];
        [_typeTableView setDelegate:(id<UITableViewDelegate>) self];
        [_typeTableView setDataSource:(id<UITableViewDataSource>) self];
        [_typeTableView setShowsVerticalScrollIndicator:NO];
        _typeTableView.tag = 20;
        _typeTableView.backgroundColor = kUIColorFromRGB(0xededed);
        
        [self.tableView addSubview:_typeTableView];

    }else{
        _isFold = YES;
        [self untransform];
        [_typeTableView removeFromSuperview];
    }
}
- (void)transform{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation( 180 / 180.0 * M_PI);
        [self.triangleView setTransform:transform];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)untransform{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation( 0 / 180.0 * M_PI);
        [self.triangleView setTransform:transform];
    }completion:^(BOOL finished) {
        
    }];
}

#pragma mark 微信绑定
- (void)thirdPartyButtonClick
{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    __weak FXPersonInfoController *weakSelf = self;
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess) {
             weakSelf.openId = [NSString stringWithFormat:@"%@", user.uid];
//             weakSelf.headimgurl = [NSString stringWithFormat:@"%@", user.icon];
//             weakSelf.nickname = [NSString stringWithFormat:@"%@", user.nickname];
//             weakSelf.loginType = @"1";
             [weakSelf savePersonInfo];
         } else {
             [weakSelf showHint:@"获取微信信息失败"];
         }
     }];
}
#pragma mark - 身份证照
//预览
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:_idImageArray];
    vc.delegate = self;
    vc.indexPath = indexPath;
    [vc seleImageLocation:tag];
//    [vc showDeleteButton];
    pushToControllerWithAnimated(vc)
}
//预览时删除
- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath
{
//    [self.idImageArray removeObjectAtIndex:tag];
//    [_tableView reloadData];
}
//添加身份证照
- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath{
    _seledIndexPath = nil;
    _seledIndexPath = indexPath;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证照上传之后不可修改，请慎重上传照片" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去上传", nil];
    alertView.tag = 20;
    [alertView show];
    
}
//头像的选择
- (void)iconViewIBAction{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.tag = 10;
//    _imgSelect = @"10";
//    [actionSheet showInView:self.view];
    NSArray *array = [NSArray arrayWithObject:_userModel.personIcon];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
    vc.delegate = self;
    [vc showMoreButton];
    pushToControllerWithAnimated(vc)
}
#pragma mark 提示仅可修改一次
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 10) {
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"姓名";
            inputVc.delegate = self;
            _selectRow = @"10";
            [self.navigationController pushViewController:inputVc animated:YES];
        }
        if (alertView.tag == 11) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
            actionSheet.tag = 20;
            [actionSheet showInView:self.view];
        }
        if (alertView.tag == 12) {
            HFPickerView *timePickView = [[HFPickerView alloc] initWithPickerMode:UIDatePickerModeDate];
            timePickView.delegate = self;
            [self.view addSubview:timePickView];

            [UIView animateWithDuration:0.4 animations:^{
                timePickView.backView.frame = CGRectMake(0, self.view.frame.size.height / 3 * 2, self.view.frame.size.width, self.view.frame.size.height / 3);
            }];
        }
        if (alertView.tag == 20) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
            actionSheet.tag = 50;
            _imgSelect = @"20";
            [actionSheet showInView:self.view];
        }
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 10) {
//        if (buttonIndex == 0) {  // 拍照模式
//            [self cameraClick];
//        }else if (buttonIndex == 1){  // 手机相册
//            [self albumClick];
//        }
    }else if (actionSheet.tag == 20){
        if (buttonIndex == 0) {
            _userModel.sex = @"男";
            [self.tableView reloadData];
            [self savePersonInfo];
        }else if (buttonIndex == 1){
            _userModel.sex = @"女";
            [self.tableView reloadData];
            [self savePersonInfo];
        }
    }else if (actionSheet.tag == 30){
        if (buttonIndex == 0) {
            _userModel.workYears = @"一年";
            [self.tableView reloadData];
            [self savePersonInfo];
        }else if (buttonIndex == 1){
            _userModel.workYears = @"两年";
            [self.tableView reloadData];
            [self savePersonInfo];
        }else if (buttonIndex == 2){
            _userModel.workYears = @"三年";
            [self.tableView reloadData];
            [self savePersonInfo];
        }else if (buttonIndex == 3){
            _userModel.workYears = @"三年以上";
            [self.tableView reloadData];
            [self savePersonInfo];
        }
        
    }else if (actionSheet.tag == 40){
        UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
        if (([userInfo.jobType integerValue] == 1) && (buttonIndex == 0)) {
            [self showHint:@"您现在就是全职，不需要更改"];
        } else if (([userInfo.jobType integerValue] == 2) && (buttonIndex == 1)) {
            [self showHint:@"您现在就是兼职，不需要更改"];
        } else if (([userInfo.jobType integerValue] == 3) && (buttonIndex == 2)) {
            [self showHint:@"您现在就是校园兼职，不需要更改"];
        } else {
            if (buttonIndex == 0) {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"选择全职，需平台人员进行核实，核实通过后自动变更为全职人员，在核实期间暂时不可以更改别的求职类型，请问是否决定变更为全职人员？"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1) {
                         [self fullTime];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            }else if (buttonIndex == 1){
                _userModel.jobType = @"兼职";
                [self.tableView reloadData];
                [self savePersonInfo];
            }else if (buttonIndex == 2){
                _userModel.jobType = @"校园兼职";
                [self.tableView reloadData];
                [self savePersonInfo];
            }
        }
    }else if (actionSheet.tag == 50){
        if (buttonIndex == 0) {  // 拍照模式
            [self cameraClick];
        }else if (buttonIndex == 1){  // 手机相册
            [self albumForIDClick];
        }
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
- (void)albumForIDClick{//打开相册 id照 多张
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.delegate = self;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    [KNPickerController imagePickerController:self withTakePicturePickerViewController:picker subViewsCount:self.idImageArray.count maxCount:2];
}
- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - ZYQAssetPickerControllerDelegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < assets.count;i++) {
        ALAsset *asset = assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [array addObject:image];
    }
    
    [self modifyPicture:array];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //从系统相册拿到一张图片 用于头像
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        if ([_imgSelect isEqualToString:@"10"]) {
            self.iconView.image = resultImage;
        }else if ([_imgSelect isEqualToString:@"20"]){
//            self.fontImgView.image = resultImage;
        }
        
    }
    [self upLoadIcon:resultImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)modifyPicture:(NSArray *)array
{
    _idImgNum = array.count;
    for (UIImage *image in array) {
        [self upLoadIcon:image];
    }

}

#pragma mark 上传
- (void)upLoadIcon:(UIImage *)image{
//    UploadImageModel *model = self.idImageArray[_seledIndexPath.row];
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        if ([string rangeOfString:@","].location == NSNotFound) {
            if ([_imgSelect isEqualToString:@"10"]) {
                
            }else{
                if (self.idImageArray.count == 0 || !_idImageArray) {
                    [self.idImageArray addObject:string];
                    if (self.idImageArray.count == _idImgNum) {
                        [self savePersonInfo];
                    }
                }else{
                    [self.idImageArray addObject:string];
                    [self savePersonInfo];
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self upLoadIcon:image];//失败的时候重试
    }];
}

- (void)refreshImageUrl:(NSString *)imageUrl
{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, imageUrl]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
    _userModel.personIcon = imageUrl;
    [self savePersonInfo];
}

#pragma mark 生日时间选择后对时间格式处理
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    _userModel.birthday = confromTimespStr;
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *confromTimespStr = [formatter stringFromDate:date];
    //    self.dataArray[0][3] = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    [self.tableView reloadData];
    [self savePersonInfo];
    
}
#pragma mark 每行选择填写
#pragma mark - FXInPutViewControllerDelegate
- (void)saveTextWith:(NSString *)text{
    if ([_selectRow isEqualToString:@"10"]) {
        _userModel.nickName = text;
    }else if ([_selectRow isEqualToString:@"14"]){
        _userModel.address = text;
    }else if ([_selectRow isEqualToString:@"15"]){
//        if ([text isEqualToString:@"博士"]) {
//            _userModel.education = @"1";
//        }else
        if ([text isEqualToString:@"研究生"]){
            _userModel.education = @"2";
        }else if ([text isEqualToString:@"本科"]){
            _userModel.education = @"3";
        }else if ([text isEqualToString:@"专科"]){
            _userModel.education = @"4";
        }else if ([text isEqualToString:@"高中"]){
            _userModel.education = @"5";
        }else if ([text isEqualToString:@"中专"]){
            _userModel.education = @"6";
        }else if ([text isEqualToString:@"初中"]){
            _userModel.education = @"7";
        }else if ([text isEqualToString:@"小学"]){
            _userModel.education = @"8";
        }else{
            _userModel.education = @"0";
        }
    }else if ([_selectRow isEqualToString:@"20"]){
        _userModel.hobby = text;
    }else if ([_selectRow isEqualToString:@"21"]){
        _userModel.height = text;
    }else if ([_selectRow isEqualToString:@"22"]){
        _userModel.introduce = text;
    }
    [self.tableView reloadData];
    [self savePersonInfo];
}

- (void)inputTextViewString:(NSString *)string WithIndex:(NSInteger)index
{
    _userModel.introduce = string;
    [self.tableView reloadData];
    [self savePersonInfo];
}

//全职申请
- (void)fullTime
{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.saveInfo"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"uid"] = userModel.userID;
    dic[@"uModelid"] = userModel.identity;
    dic[@"isChange"] = @"1";
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
            userInfo.isChange = @"1";
            [ZQ_AppCache save:userInfo];
            
            [weakSelf showHint:@"申请成功"];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

//个人资料修改保存
- (void)savePersonInfo{
    NSString *sexStr;
    if ([_userModel.sex isEqualToString:@"男"]) {
        sexStr = @"1";
    }else if ([_userModel.sex isEqualToString:@"女"]){
        sexStr = @"2";
    }
    NSString *jobTypeStr;
    if ([_userModel.jobType isEqualToString:@"全职"]) {
        jobTypeStr = @"1";
    }else if ([_userModel.jobType isEqualToString:@"兼职"]){
        jobTypeStr = @"2";
    }else if ([_userModel.jobType isEqualToString:@"校园兼职"]){
        jobTypeStr = @"3";
    }else{
        jobTypeStr = @"0";
    }
    NSString *workYearStr;
    if ([_userModel.workYears isEqualToString:@"一年"]) {
        workYearStr = @"1";
    }else if ([_userModel.workYears isEqualToString:@"二年"]){
        workYearStr = @"2";
    }else if ([_userModel.workYears isEqualToString:@"三年"]){
        workYearStr = @"3";
    }else if ([_userModel.workYears isEqualToString:@"三年以上"]){
        workYearStr = @"4";
    }else{
        workYearStr = @"0";
    }
    
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.saveInfo"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"uid"] = userModel.userID;
    dic[@"uModelid"] = userModel.identity;
    dic[@"avatar"] = _userModel.personIcon;
    dic[@"nickname"] = _userModel.nickName;
    dic[@"sex"] = sexStr;
    dic[@"birthday"] = _userModel.birthday;
    dic[@"height"] = _userModel.height;
    dic[@"mobile"] = _userModel.telPhone;
    dic[@"address"] = _userModel.address;
    dic[@"jobType"] = jobTypeStr;
    dic[@"industry"] = _userModel.industry;
    dic[@"workYears"] = workYearStr;
    dic[@"hobbies"] = _userModel.hobby;
    dic[@"intro"] = _userModel.introduce;
    dic[@"education"] = _userModel.education;
    dic[@"wxUid"] = self.openId;
    if (_idImageArray.count == 0) {
        dic[@"identityCard1"] = @"";
        dic[@"identityCard2"] = @"";
    }else if (_idImageArray.count == 1){
        dic[@"identityCard1"] = _idImageArray[0];
        dic[@"identityCard2"] = @"";
    }else if (_idImageArray.count == 2){
        dic[@"identityCard1"] = _idImageArray[0];
        dic[@"identityCard2"] = _idImageArray[1];
    }
    [weakSelf showHudInView:weakSelf.view hint:@"保存中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            [weakSelf showHint:@"保存成功"];
            UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
            userModel.avatar = _userModel.personIcon;
            userModel.nickname = _userModel.nickName;
            [ZQ_AppCache save:userModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FXReloadUserInfo" object:nil];
            [_tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

//获取个人资料数据
- (void)getPersonData{
    UploadImageModel *model = [[UploadImageModel alloc] init];
    model.taskName = @"";
    model.taskId = @"";
    model.imageArray = [NSMutableArray array];
    [_idImageArray addObject:model];
    
    __weak FXPersonInfoController *weakSelf = self;
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
            _userModel.personIcon = tempDic[@"avatar"];
            _userModel.nickName = tempDic[@"nickname"];
            _userModel.sex = tempDic[@"sex_str"];
            _userModel.birthday = tempDic[@"birthday"];
            _userModel.telPhone = tempDic[@"mobile"];
            _userModel.address = tempDic[@"address"];
            _userModel.industry = tempDic[@"industry"];
            _userModel.industryStr = tempDic[@"industry_str"];
            _userModel.workYears = tempDic[@"workYears_str"];
            NSLog(@"------%@----",_userModel.workYears);
            _userModel.jobType = tempDic[@"jobType_str"];
            _userModel.hobby = tempDic[@"hobbies"];
            if ([tempDic[@"height"] isEqualToString:@"0"]) {
                _userModel.height = @"";
            }else{
                _userModel.height = tempDic[@"height"];
            }
            _userModel.introduce = tempDic[@"intro"];
            _userModel.education = tempDic[@"education"];
            _userModel.weichat = tempDic[@"wxUid"];
            if (![tempDic[@"identityCard1"] isEqualToString:@""]) {
                [self.idImageArray addObject:tempDic[@"identityCard1"]];
            }
            if (![tempDic[@"identityCard2"] isEqualToString:@""]) {
                [self.idImageArray addObject:tempDic[@"identityCard2"]];
            }
            
            NSDictionary  *referees = tempDic[@"referees"];
            
            if ([ZQ_CommonTool isEmptyDictionary:referees]){
                
            }
            else{
                _userModel.refersDic = referees;
            }
        }
        
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        
    }];
    
    
    [self.tableView reloadData];

}
//获取行业下拉列表数据
- (void)getIndustryList{
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=linkage.get"];
    NSDictionary *dic = @{@"keyid":@"3360",
                          @"parentid":@"0"
                          };
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            FXListModel *model = [[FXListModel alloc]init];
            model.linkID = dic[@"linkageid"];
            model.title = dic[@"name"];
            [self.typeArray addObject:model];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"%@",error);
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
