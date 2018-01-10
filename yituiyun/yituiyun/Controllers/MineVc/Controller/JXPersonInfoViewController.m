//
//  JXPersonViewController.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPersonInfoViewController.h"
#import "FXPersonInfoCell.h"
#import "FXUserInfoModel.h"
#import "FXUpLoadImageCell.h"
#import "UploadImageModel.h"
#import "FXInPutViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "FXChangePhoneController.h"
#import "ShowImageViewController.h"
#import "RealNameVc.h"

typedef enum : NSUInteger {
    JXPersonInfoJobTypeFullTime,/// 全职
    JXPersonInfoJobTypeSingle,/// 专职
    JXPersonInfoJobTypeSchoolPartTime,/// 校园兼职
} JXPersonInfoJobType;

static NSString *const cellID = @"PersonInfoCell";

@interface JXPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,FXInPutViewControllerDelegate,ShowImageViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** 标题数组*/
@property (nonatomic, strong) NSArray<NSArray *> *titleArray;
@property (nonatomic, strong) FXUserInfoModel *userModel;
/** 头像*/
@property (nonatomic, strong) UIImageView *iconView;
/// 身份证图片数组
@property (nonatomic, strong) NSMutableArray <NSString *>*idImageArray;
@property (nonatomic, strong) UIAlertController *alertC;


/** 去填写block*/
@property (nonatomic, copy) void(^sureHandler)();
/** 微信openId*/
@property (nonatomic, copy) NSString *openId;

/** 实名btn*/
@property (nonatomic, strong) UIButton *realNameBtn;
/** 是否实名 */
@property (nonatomic, assign) BOOL is_authentication;
/** 第一次刷新实名cell */
@property (nonatomic, assign) BOOL isFristReloadRealNameCell;
@end

@implementation JXPersonInfoViewController

#pragma mark - lazy load

- (UIButton *)realNameBtn{
    if (_realNameBtn == nil) {
        
        NSString *realNameString = @"去实名认证";
        CGSize size = [NSString sizeWithString:realNameString andFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _realNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _realNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _realNameBtn.frame = CGRectMake(ScreenWidth  - size.width - 30, (44 - size.height) * 0.5, size.width, size.height);
        [_realNameBtn setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
        [_realNameBtn addTarget:self action:@selector(realNameBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _realNameBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _realNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        _realNameBtn.backgroundColor = [UIColor yellowColor];
    }
    return _realNameBtn;
}
- (UIAlertController *)alertC{
    if (_alertC == nil) {
        MJWeakSelf;
        _alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"重要信息，请慎重填写" preferredStyle:UIAlertControllerStyleAlert];
        
        [_alertC addAction:[UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [_alertC addAction:[UIAlertAction actionWithTitle:@"去填写" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.sureHandler) {
                self.sureHandler();
            }
        }]];
        
    }
    return _alertC;
}
- (FXUserInfoModel *)userModel{
    if (_userModel == nil) {
        _userModel = [[FXUserInfoModel alloc]init];
    }
    return _userModel;
}
- (NSMutableArray <NSString *>*)idImageArray{
    if (!_idImageArray) {
        _idImageArray = [NSMutableArray array];
    }
    return _idImageArray;
}

- (UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 60 - 20, 15, 60, 60)];
        _iconView.layer.cornerRadius = 30;
        _iconView.clipsToBounds = YES;
        _iconView.userInteractionEnabled = YES;
        [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, self.userModel.personIcon]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewIBAction)]];
    }
    return _iconView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _tableView;
}
- (NSArray<NSArray *> *)titleArray{
    if (_titleArray == nil) {
        
        _titleArray = @[@[@""],@[@"昵称",@"手机号码",@"实名信息",@"性别",@"微信号",@"求职类型"],@[@"推荐人信息",@"名称",@"电话"]];
    }
    return _titleArray;
}

#pragma mark - cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = kUIColorFromRGB(0xededed);
    [self.view addSubview:self.tableView];
    self.isFristReloadRealNameCell = YES;
    
    [self getPersonData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAuthenticationStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
/// 实名认证状态
- (void)requestAuthenticationStatus{
    
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = userModel.userID;
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHost,API_AuthenticationStatus];
    MJWeakSelf;
    [XKNetworkManager POSTToUrlString:URLString parameters:params progress:nil success:^(id responseObject) {
        NSDictionary *resultDict = JSonDictionary;
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *rdict = resultDict[@"rst"];
            NSString *is_authentication = [rdict valueForKey:@"is_authentication"];
            
            [weakSelf.realNameBtn setTitle:[is_authentication intValue] == 2 ? @"已实名" : @"去实名认证" forState:UIControlStateNormal];
            weakSelf.realNameBtn.enabled = [is_authentication intValue] == 2 ? NO : YES;
            
            UIColor *color = [is_authentication intValue] == 2 ? kUIColorFromRGB(0x404040) : kUIColorFromRGB(0x808080);
            [weakSelf.realNameBtn setTitleColor:color forState:UIControlStateNormal];
            weakSelf.is_authentication = [is_authentication intValue] == 2 ? YES : NO;
            weakSelf.isFristReloadRealNameCell = NO;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//获取个人资料数据
- (void)getPersonData{
    UploadImageModel *model = [[UploadImageModel alloc] init];
    model.taskName = @"";
    model.taskId = @"";
    model.imageArray = [NSMutableArray array];
    [self.idImageArray addObject:model];
    
    __weak JXPersonInfoViewController *weakSelf = self;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    params[@"uModelid"] = userModel.identity;
    params[@"uid"] = userModel.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.basicInfo"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, NSDictionary *responseObject) {
        [weakSelf hideHud];
        
        
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            self.userModel.personIcon = tempDic[@"avatar"];
            self.userModel.nickName = tempDic[@"nickname"];
            self.userModel.sex = tempDic[@"sex_str"];
            self.userModel.birthday = tempDic[@"birthday"];
            self.userModel.telPhone = tempDic[@"mobile"];
            self.userModel.address = tempDic[@"address"];
            self.userModel.industry = tempDic[@"industry"];
            self.userModel.industryStr = tempDic[@"industry_str"];
            self.userModel.workYears = tempDic[@"workYears_str"];
            self.userModel.jobType = tempDic[@"jobType_str"];
            self.userModel.hobby = tempDic[@"hobbies"];
            if ([tempDic[@"height"] isEqualToString:@"0"]) {
                self.userModel.height = @"";
            }else{
                self.userModel.height = tempDic[@"height"];
            }
            self.userModel.introduce = tempDic[@"intro"];
            self.userModel.education = tempDic[@"education"];
            self.userModel.weichat = tempDic[@"wxUid"];
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
                self.userModel.refersDic = referees;
            }
        }
        
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        
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
    }else if ([_userModel.jobType isEqualToString:@"专职"]){
        jobTypeStr = @"2";
    }else if ([_userModel.jobType isEqualToString:@"校园兼职"]){
        jobTypeStr = @"3";
    }else{
        jobTypeStr = @"0";
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
    dic[@"workYears"] = _userModel.workYears;
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
            userModel.jobType = jobTypeStr;
            userModel.weixinUid = weakSelf.openId;
            if ([sexStr intValue] == 0) {
                userModel.sex = @"保密";
            }else if([sexStr intValue] == 1){
                userModel.sex = @"男";
            }else if([sexStr intValue] == 2){
                userModel.sex = @"女";
            }
            [ZQ_AppCache save:userModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FXReloadUserInfo" object:nil];
            [self.tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
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


#pragma mark - Private Method
- (void)pushInputVc:(NSString *)title{
    FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
    inputVc.title = title;
    inputVc.delegate = self;
    [self.navigationController pushViewController:inputVc animated:YES];
}

#pragma mark 微信绑定
- (void)thirdPartyButtonClick
{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    __weak JXPersonInfoViewController *weakSelf = self;
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

/// 选择求职类型
- (void)saveJobType:(JXPersonInfoJobType)type{
//    UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
    FXUserInfoModel * userInfo = self.userModel;
    if (userInfo.jobType.length >= 2) {
        if ([userInfo.jobType isEqualToString:@"全职"]) {
            userInfo.jobType = @"1";
        }else if ([userInfo.jobType isEqualToString:@"专职"]) {
            userInfo.jobType = @"2";
        }else if ([userInfo.jobType isEqualToString:@"校园兼职"]) {
            userInfo.jobType = @"3";
        }else {
            userInfo.jobType = @"0";
        }
    }
    
    
    if (([userInfo.jobType integerValue] == 1) && (type == JXPersonInfoJobTypeFullTime)) {
        [self showHint:@"您现在就是全职，不需要更改"];
    } else if (([userInfo.jobType integerValue] == 2) && (type == JXPersonInfoJobTypeSingle)) {
        [self showHint:@"您现在就是专职，不需要更改"];
    } else if (([userInfo.jobType integerValue] == 3) && (type == JXPersonInfoJobTypeSchoolPartTime)) {
        [self showHint:@"您现在就是校园兼职，不需要更改"];
    } else {
        if (type == JXPersonInfoJobTypeFullTime) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"选择全职，需平台人员进行核实，核实通过后自动变更为全职人员，在核实期间暂时不可以更改别的求职类型，请问是否决定变更为全职人员？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [self fullTime];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }else if (type == JXPersonInfoJobTypeSingle){
            _userModel.jobType = @"专职";
            [self.tableView reloadData];
            [self savePersonInfo];
        }else if (type == JXPersonInfoJobTypeSchoolPartTime){
            _userModel.jobType = @"校园兼职";
            [self.tableView reloadData];
            [self savePersonInfo];
        }
}
}

#pragma mark - Actions
- (void)realNameBtnAction{
    RealNameVc *vc = [[RealNameVc alloc]init];
    vc.navigationItem.title = @"实名认证";
    pushToControllerWithAnimated(vc);
}
- (void)iconViewIBAction{
    NSArray *array = [NSArray arrayWithObject:self.userModel.personIcon];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
    vc.delegate = self;
    [vc showMoreButton];
    pushToControllerWithAnimated(vc)
    
}
- (void)changeTelPhone{
    FXChangePhoneController *changeVc = [[FXChangePhoneController alloc]init];
    [self.navigationController pushViewController:changeVc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        NSArray *array = self.titleArray[0];
        return array.count;
    }else if (section == 1){
        NSArray *array = self.titleArray[1];
        return array.count;
        
    }else{
        
        /// 判断有无推荐人
        if ([ZQ_CommonTool isEmptyDictionary:self.userModel.refersDic]) {
            return 0;
        }else{
            NSArray *array = self.titleArray[2];
            return array.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FXPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[FXPersonInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    
    /// 上传头像
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
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, self.userModel.personIcon]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
            [cell.contentView addSubview:self.iconView];
        }
    }else if (indexPath.section == 1){
        cell.detailLabel.hidden = NO;
        cell.telNumLabel.hidden = YES;
        cell.changeTelBtn.hidden = YES;
        cell.heightLabel.hidden = YES;
        cell.cmLabel.hidden = YES;
        
        /// 昵称
        if (indexPath.row == 0) {
            if ([self.userModel.nickName isEqualToString:@""] || self.userModel.nickName.length == 0) {
                cell.detailLabel.text = @"请输入昵称";
            }else{
                cell.detailLabel.text = self.userModel.nickName;
                cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        /// 手机号
        if (indexPath.row == 1) {
            cell.detailLabel.hidden = YES;
            cell.telNumLabel.hidden = NO;
            cell.changeTelBtn.hidden = NO;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            
            cell.telNumLabel.text = self.userModel.telPhone;
            [cell.changeTelBtn addTarget:self action:@selector(changeTelPhone) forControlEvents:UIControlEventTouchUpInside];
        }
        /// 实名信息
        if (indexPath.row == 2) {
            cell.detailLabel.hidden = YES;
            cell.telNumLabel.hidden = YES;
            cell.changeTelBtn.hidden = YES;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            if (!self.isFristReloadRealNameCell) {
                cell.accessoryType = self.is_authentication  == YES ? UITableViewCellAccessoryNone:  UITableViewCellAccessoryDisclosureIndicator;
            }
             CGSize size = [NSString sizeWithString:@"去实名认证" andFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.realNameBtn.frame = self.is_authentication == YES ? CGRectMake(ScreenWidth  - size.width - 10, (44 - size.height) * 0.5, size.width, size.height) : CGRectMake(ScreenWidth  - size.width - 30, (44 - size.height) * 0.5, size.width, size.height);
            
            [cell.contentView addSubview:self.realNameBtn];
            
//            FXUpLoadImageCell *idCell = [FXUpLoadImageCell cellWithTableView:tableView];
//            idCell.nameLabel.text = @"实名认证(上传身份证正反面照片)";
//            idCell.maxNum = 1;
//            _chooseImageCell = idCell;
//            idCell.indexPath = indexPath;
//            idCell.delegate = self;
//            UploadImageModel *imageModel = self.idImageArray[indexPath.row];
//            [idCell.imageArray removeAllObjects];
//            [idCell.imageArray addObjectsFromArray:self.idImageArray];
//            [idCell makeView];
//            idCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            idCell.accessoryType = UITableViewCellAccessoryNone;
//            return idCell;
        }
        /// 性别
        if (indexPath.row == 3) {
            if ([self.userModel.sex isEqualToString:@""] || [self.userModel.sex isEqualToString:@"0"] || [self.userModel.sex isEqualToString:@"保密"] || self.userModel.sex.length == 0) {
                
                cell.detailLabel.text = @"请选择性别";
            }else{
                cell.detailLabel.text = self.userModel.sex;
                cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
            }
        }
        
        /// 微信号
        if (indexPath.row == 4) {
            if ([self.userModel.weichat isEqualToString:@""] || !self.userModel.weichat) {
                cell.detailLabel.text = @"去绑定";
            }else{
                cell.detailLabel.text = @"去修改";
            }
        }
        
        /// 求职类型
        if (indexPath.row == 5) {
            
            UITableViewCell *jobCell = [tableView dequeueReusableCellWithIdentifier:@"jobCell"];
            if (jobCell == nil) {
                jobCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"jobCell"];
            }
            if (jobCell.contentView.subviews.count) {
                [jobCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
            
            jobCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CGSize size = [NSString sizeWithString:@"求职类型" andFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            CGRect labelFrame = CGRectMake(10, (44 - size.height) * 0.5, size.width, size.height);
            UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
            label.textColor = kUIColorFromRGB(0x808080);
            label.font = [UIFont systemFontOfSize:14];
            label.text = self.titleArray[indexPath.section][indexPath.row];
            [jobCell.contentView addSubview:label];
            jobCell.detailTextLabel.textColor = kUIColorFromRGB(0x808080);
            jobCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            jobCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([_userModel.jobType isEqualToString:@""] || [_userModel.jobType isEqualToString:@"请选择"]) {
                jobCell.detailTextLabel.text = @"请选择求职类型";
            }else{
                jobCell.detailTextLabel.text = _userModel.jobType;
                jobCell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
            }
            return jobCell;
        }
        

        
        /// 推荐人信息
    }else if (indexPath.section == 2) {
        
        cell.detailLabel.hidden = NO;
        cell.telNumLabel.hidden = YES;
        cell.changeTelBtn.hidden = YES;
        cell.heightLabel.hidden = YES;
        cell.cmLabel.hidden = YES;
        
        if ([ZQ_CommonTool isEmptyDictionary:_userModel.refersDic]) {
            
        }else{
            /// 推荐人名字
            if (indexPath.row == 1) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@",_userModel.refersDic[@"nickname"]];
            /// 推荐人电话
            }else if(indexPath.row == 2){
                cell.detailLabel.text = [NSString stringWithFormat:@"%@",_userModel.refersDic[@"mobile"]];
            }
        }
        
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    /// 上传头像
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 90;
        }
    /// 个人信息
    }else if (indexPath.section == 1){
        return 44;
    }
    /// 推荐人信息
    else if (indexPath.section == 2){
        return 44;
    }
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /// 上传头像
    if (indexPath.section == 0) {
        NSArray *array = [NSArray arrayWithObject:self.userModel.personIcon];
        ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
        vc.delegate = self;
        [vc showMoreButton];
        pushToControllerWithAnimated(vc)
    }
    
    if (indexPath.section == 1) {
        
        MJWeakSelf;
        /// 昵称
        if (indexPath.row == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController: self.alertC animated: YES completion: nil];
                
            });
            [self setSureHandler:^{
                [self pushInputVc:@"昵称"];
            }];
        }
        /// 手机号码
        if (indexPath.row == 1) {
           
        }
        /// 实名信息
        if (indexPath.row == 2) {
            
        }
        /// 性别
        if (indexPath.row == 3) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController: self.alertC animated: YES completion: nil];
                
            });
            [self setSureHandler:^{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertC addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.userModel.sex = @"男";
                    [self.tableView reloadData];
                    [self savePersonInfo];
                }]];
                
                [alertC addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.userModel.sex = @"女";
                    [self.tableView reloadData];
                    [self savePersonInfo];
                }]];
                
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertC animated:YES completion:nil];
            }];
        }
        
        /// 微信号
        if (indexPath.row == 4) {
            [self thirdPartyButtonClick];
        }
        /// 求职类型
        if (indexPath.row == 5) {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"全职" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveJobType:JXPersonInfoJobTypeFullTime];
            }]];
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"专职" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveJobType:JXPersonInfoJobTypeSingle];
            }]];
            

//            
//            [alertC addAction:[UIAlertAction actionWithTitle:@"校园兼职" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self saveJobType:JXPersonInfoJobTypeSchoolPartTime];
//            }]];
            
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertC animated:YES completion:nil];
            });
            
        }
        
        
    }
}



#pragma mark header/footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2 && [ZQ_CommonTool isEmptyDictionary:self.userModel.refersDic]) {
        return 0.001;
    }
    return 10;
}


#pragma mark - FXInPutViewControllerDelegate
- (void)saveTextWith:(NSString *)text{
    self.userModel.nickName = text;
    [self.tableView reloadData];
    [self savePersonInfo];
}


#pragma mark - ShowImageViewControllerDelegate
//预览时删除
- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)refreshImageUrl:(NSString *)imageUrl{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, imageUrl]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
    self.userModel.personIcon = imageUrl;
    [self savePersonInfo];
}
@end
