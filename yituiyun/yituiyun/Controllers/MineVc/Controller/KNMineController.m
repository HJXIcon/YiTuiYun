//
//  KNMineController.m
//  荣坤
//
//  Created by LUKHA_Lu on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "KNMineController.h"
#import "MineTableViewCell.h"
#import "UserInfoModel.h"
#import "FXMyResumeController.h"
#import "FXTodayTaskController.h"
#import "FXMyWalletController.h"
#import "FXMyCollectController.h"
//#import "FXPersonInfoController.h"
#import "JXPersonInfoViewController.h"
#import "FXInsureTaskListController.h"
#import "FXChoseInsureController.h"
#import "LoginViewController.h"
#import "FXNearbyPersonController.h"
#import "NotificationMessageViewController.h"
#import "ConversationListController.h"
#import "JobSearchStrategyViewController.h"
#import "ContactUsViewController.h"
#import "SetViewController.h"
#import "MyLogViewController.h"
#import "WorkerTaskViewController.h"
#import "RedpacketViewControl.h"
#import "LHKPersonCenterHeadView.h"
#import "LHKLeftButoon.h"
#import "MyInviteVc.h"
#import "RealNameVc.h"

@interface KNMineController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,LHKPersonCenterHeadViewDelegate>

@property (nonatomic, strong) UserInfoModel *model;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UIImageView *iconView;//头像
@property (nonatomic, strong) UIButton *nameLabel;   //昵称
/**头部View */
@property(nonatomic,strong) LHKPersonCenterHeadView *headView;
/**编辑按钮 */
@property(nonatomic,strong)  LHKLeftButoon *editBtn;

/**<#type#> */
@property(nonatomic,strong) UILabel * settingNameLabel;

/**面板View */
@property(nonatomic,strong) UIView * panView;

/** 实名btn*/
@property (nonatomic, strong) UIButton *realNameBtn;
@end

@implementation KNMineController

#pragma mark--懒加载
-(LHKPersonCenterHeadView *)headView{
    if (_headView == nil) {
        _headView = [LHKPersonCenterHeadView headView];
        _headView.frame = CGRectMake(0, 130, ScreenWidth, 185);
        _headView.delegate = self;
    }
    return _headView;
}


#pragma mark - cycle life
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [ZQ_CallMethod setupNewMessageBoxCount];
    [_tableView reloadData];
    // 是否实名请求
    [self requestAuthenticationStatus];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.model = [[UserInfoModel alloc] init];
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];

        
//        self.dataArr = @[@[@"通知中心"],@[@"联系我们",@"系统设置"]];
//        
//        self.imageArr = @[@[@"personcenter_tongzhi"],@[@"personcenter_lianxi",@"personcenter_shezhi"]];
//        
        self.dataArr = @[@[@"联系我们",@"系统设置"]];
        
        self.imageArr = @[@[@"personcenter_lianxi",@"personcenter_shezhi"]];
        
        //,@"附近的人" ,@"personcenter_fujin"
        
        
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.redViewIsShow = YES;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [MobClick event:@"clickPersonCenterNums"];

    self.title = @"个人中心";
    [self setupTableView];
//    self.view.backgroundColor =UIColorFromRGBString(@"0xe1e1e1");
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfo) name:@"FXReloadUserInfo" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FXReloadUserInfo" object:nil];
}

#pragma mark - Private Method
- (void)requestAuthenticationStatus{
    
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = userModel.userID;
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHost,API_AuthenticationStatus];
    
    [XKNetworkManager POSTToUrlString:URLString parameters:params progress:nil success:^(id responseObject) {
        NSDictionary *resultDict = JSonDictionary;
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *rdict = resultDict[@"rst"];
            NSString *is_authentication = [rdict valueForKey:@"is_authentication"];
            
            if ([is_authentication intValue] == 2) {
                [self.realNameBtn setTitle: @"已实名" forState:UIControlStateNormal];
            }else if ([is_authentication intValue] == 1){
                [self.realNameBtn setTitle: @"未实名" forState:UIControlStateNormal];
            }else if ([is_authentication intValue] == 3){
                [self.realNameBtn setTitle: @"实名失败" forState:UIControlStateNormal];
                [self.realNameBtn sizeToFit];
            }else {
                 [self.realNameBtn setTitle: @"未实名" forState:UIControlStateNormal];
            }
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadUserInfo{
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, userModel.avatar]] placeholderImage:[UIImage imageNamed:@"morenIcon"]];
    
    if ([ZQ_CommonTool isEmpty:userModel.nickname] || !userModel.nickname){
        
        NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:LoginUsernameSave];
        
        [self.nameLabel setTitle:[NSString stringWithFormat:@"%@",nameStr] forState:UIControlStateNormal];
    }else{
        NSString *nameStr = userModel.nickname;
        
        [self.nameLabel setTitle:[NSString stringWithFormat:@"%@",nameStr] forState:UIControlStateNormal];
    }
  
    
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [self setupTableViewHeadView];
    headerView.frame =CGRectMake(0, 0, ScreenWidth, 315);
    _tableView.tableHeaderView = headerView;
    _tableView.bounces = NO;

    [self.view addSubview:_tableView];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIView *)setupTableViewHeadView{
    
    // 背景 view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    self.panView = bgView;
    bgView.tag = 1;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = MainColor;
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    bgImgView.image = [UIImage imageNamed:@"detailback"];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:bgImgView];
    
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];

    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 70, 70)];
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height / 2;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, userModel.avatar]] placeholderImage:[UIImage imageNamed:@"morenIcon"]];
    self.iconView.clipsToBounds = YES;
    self.iconView.userInteractionEnabled = YES;
    self.iconView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconDidClick)]];
    [bgView addSubview:self.iconView];

    /*******************/
    
    if ([ZQ_CommonTool isEmpty:userModel.nickname] || !userModel.nickname) {
        self.nameLabel = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 52, 150, 20)];
       
        [self.nameLabel addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];

        NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:LoginUsernameSave];
        
        [self.nameLabel setTitle:[NSString stringWithFormat:@"%@",nameStr] forState:UIControlStateNormal];
        self.nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.nameLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.nameLabel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.nameLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nameLabel.userInteractionEnabled = YES;
        [bgView addSubview:self.nameLabel];
        
        
    }else{
        self.nameLabel = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 52, 150, 20)];
        
        [self.nameLabel addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *nameStr = userModel.nickname;
        
        [self.nameLabel setTitle:[NSString stringWithFormat:@"%@",nameStr] forState:UIControlStateNormal];
        self.nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.nameLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.nameLabel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.nameLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nameLabel.userInteractionEnabled = YES;
        [bgView addSubview:self.nameLabel];
       

    }


    
    self.editBtn = [[LHKLeftButoon alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 77, 100, 20)];
    [self.editBtn setImage:[UIImage imageNamed:@"bianjiziliao"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.editBtn setTitle:@"编辑信息" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
   

    [bgView addSubview:self.editBtn];
    
    /*********是否实名*********/
    
    NSString *realNameString = @"未实名";
    CGSize realNameBtnSize = [NSString sizeWithString:realNameString andFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.realNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.realNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.realNameBtn.layer.borderWidth = 1;
    self.realNameBtn.clipsToBounds = YES;
    
    
    self.realNameBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.realNameBtn.frame = CGRectMake(ScreenWidth - realNameBtnSize.width - 30, 48, realNameBtnSize.width + 10, realNameBtnSize.height + 6);
    [self.realNameBtn addTarget:self action:@selector(realNameBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.realNameBtn];
   
    /******************/
    
    
    
    [bgView addSubview:self.headView];
    
    return bgView;
}


#pragma mark - Actions
- (void)realNameBtnAction{
    NSLog(@"realNameBtnAction -- ");
}
#pragma mark--名字点击
-(void)nameBtnClick{
//    FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
    JXPersonInfoViewController *personVc = [[JXPersonInfoViewController alloc]init];
    personVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personVc animated:YES];
}

#pragma mark 头像点击
- (void)iconDidClick{
    
    
//    FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
    JXPersonInfoViewController *personVc = [[JXPersonInfoViewController alloc]init];
        personVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personVc animated:YES];
}
//今日任务
- (void)taskClick{
    FXTodayTaskController *taskVc = [[FXTodayTaskController alloc]init];
    taskVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskVc animated:YES];
}
//我的工资
- (void)myWalletClick{
    FXMyWalletController *walletVc = [[FXMyWalletController alloc] initWithWhere:1];
    walletVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVc animated:YES];
}
//我的简历
- (void)myResumeClick{
    //
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.basicInfo"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"uid":userModel.userID,
                          @"uModelid":userModel.identity,
                          };
    [weakSelf showHudInView:weakSelf.view hint:@""];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            NSString *birStr = tempDic[@"birthday"];
            NSString *nameStr = tempDic[@"nickname"];
            NSString *sexStr = tempDic[@"sex_str"];
            NSString *edStr = tempDic[@"education"];

            
            FXMyResumeController *resumeVc = [[FXMyResumeController alloc]init];
            resumeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resumeVc animated:YES];
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
    }];

}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray  *rowAarry = self.dataArr[section];
    return rowAarry.count;

}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
//    view.backgroundColor =UIColorFromRGBString(<#rgbString#>)
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.000001;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* const identifier = @"MineTableViewCell";
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *rowDataArray = self.dataArr[indexPath.section];
    NSArray *rowImageArray = self.imageArr[indexPath.section];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *accImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_jiantou"]];
                                 cell.accessoryView = accImageView;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    cell.jianzhinumberLabel.hidden = YES;
    cell.redView.hidden = YES;
    cell.leftImage.image = [UIImage imageNamed:rowImageArray[indexPath.row]];
    cell.titleLabel.text = rowDataArray[indexPath.row];
    cell.titleLabel.textColor = UIColorFromRGBString(@"0x545454");
    

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //小红点显示或者隐藏
            
            if (self.redViewIsShow) {
                cell.redView.hidden = NO;
            }
            
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
  
    if ([model.userID isEqualToString:@"0"]) {
        [ZQ_CallMethod againLogin];
    } else {
        
//        if (indexPath.section == 0) {//通知中心 联系我们
////            indexPath.row == 0 ?
////            ({
//            
//    NotificationMessageViewController *vc = [[NotificationMessageViewController alloc] init];
//                                vc.title = @"通知中心";
//                self.redViewIsShow = NO;
//                                vc.hidesBottomBarWhenPushed = YES;
//                                pushToControllerWithAnimated(vc)
//                                self.tabBarItem.badgeValue = nil;
////        })
////             :
////            ({
////            
////                FXNearbyPersonController *perVc = [[FXNearbyPersonController alloc]init];
////                perVc.hidesBottomBarWhenPushed = YES;
////                [self.navigationController pushViewController:perVc animated:YES];
////
////            
////
////            
////            });
//            
//        }else
            if (indexPath.section == 0){//系统设置
            
            if (indexPath.row == 0) {
            ContactUsViewController *vc = [[ContactUsViewController alloc] init];
                                            vc.hidesBottomBarWhenPushed = YES;
                                            pushToControllerWithAnimated(vc)

            }else{
            
            SetViewController *vc = [[SetViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
                pushToControllerWithAnimated(vc)}

        }
        
    }
}

- (UINavigationController *)addNavigationController:(UIViewController *)viewController
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    //修改所有导航栏控制器的title属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //修改所有导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xf16156)] forBarMetrics:UIBarMetricsDefault];
    
    return nav;
}


#pragma mark---personCenterHeadViewDelegate




-(void)personCenterHeadViewButtonClick:(UIButton *)btn{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    if ([model.userID isEqualToString:@"0"]) {
        [ZQ_CallMethod againLogin];
        return ;
    }

    
    switch (btn.tag) {
        case 101:   //工资
        {
            [self myWalletClick];
        }
            break;
            
        case 102:  //简历
        {
            [self myResumeClick];
        }
            break;

        case 103:  //收藏
        {
            FXMyCollectController *collectVc = [[FXMyCollectController alloc]init];
            collectVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectVc animated:YES];

        }
            
            break;

        case 104: //附近的人---个人端现在变成邀约赚钱
        {
//            FXNearbyPersonController *perVc = [[FXNearbyPersonController alloc]init];
//            perVc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:perVc animated:YES];
            
//            NSLog(@"------邀约赚钱");
            
            MyInviteVc *perVc = [[MyInviteVc alloc]init];
            perVc.navigationItem.title = @"邀约赚钱";
                        perVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:perVc animated:YES];


        }
            break;

        case 105: //职工任务 //今日任务 -- 现在变成 实名认证
        {
            
//            NSLog(@"========实名认证");
            
            RealNameVc *relVc = [[RealNameVc alloc]init];
            relVc.navigationItem.title = @"实名认证";
            pushToControllerWithAnimated(relVc)
//            UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
//            if ([userModel.jobType integerValue] != 1){
//                MyLogViewController *vc = [[MyLogViewController alloc] initWithWhere:1];
//                           vc.hidesBottomBarWhenPushed = YES;
//                            pushToControllerWithAnimated(vc)
//            }else{
//                WorkerTaskViewController *vc = [[WorkerTaskViewController alloc] initWith:1];
//                vc.hidesBottomBarWhenPushed = YES;
//                pushToControllerWithAnimated(vc)
            
//            }


        }
            break;
            
        case 106: //我的钱包
        {
//            UIViewController *vc = [RedpacketViewControl changeMoneyController];
//            UINavigationController *nav = [self addNavigationController:vc];
//            nav.hidesBottomBarWhenPushed = YES;
//            [self presentViewController:nav animated:YES completion:nil];
            
            LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"红包功能还在完善中,敬请期待!" WithMakeSure:^(LHKAlterView *alterView) {
                
                [alterView removeFromSuperview];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alt];
 
        }
            break;


            
        default:
            break;
    }
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 76, 0);
}


@end
