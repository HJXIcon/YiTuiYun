//
//  FXCompanyMineController.m
//  yituiyun
//
//  Created by fx on 16/10/14.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXCompanyMineController.h"
#import "MineTableViewCell.h"
#import "UserInfoModel.h"
#import "FXCompanyInfoController.h"
#import "FXNearbyCompanyController.h"
#import "FXAnalyseController.h"
#import "FXMyCollectController.h"
#import "FXNeedsListController.h"
#import "NotificationMessageViewController.h"
#import "ConversationListController.h"
#import "ContactUsViewController.h"
#import "SetViewController.h"
#import "FXMyWalletController.h"
#import "RedpacketViewControl.h"
#import "UserAgreementViewController.h"
#import "LHKCompayCenterHeadView.h"
#import "LHKLeftButoon.h"
#import "WorkupLoadListVc.h"
#import "BillViewController.h"
#import "JianZhiShenHeVC.h"

@interface FXCompanyMineController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,LHKCompayCenterHeadViewDelegate>

@property (nonatomic, strong) UserInfoModel *model;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *imageArr;


@property (nonatomic, strong) UIImageView *iconView;//头像
@property (nonatomic, strong) UIButton *nameLabel;   //昵称

/**headView */
@property(nonatomic,strong) LHKCompayCenterHeadView * headView;
/**编辑按钮 */
@property(nonatomic,strong)  LHKLeftButoon *editBtn;

/**<#type#> */
@property(nonatomic,strong) UILabel * settingNameLabel;

/**面板View */
@property(nonatomic,strong) UIView * panView;

@property(nonatomic,strong) NSString * jianzhinumber;

@end

@implementation FXCompanyMineController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [ZQ_CallMethod setupNewMessageBoxCount];
    [self tongzhiNumberMethod];
    [_tableView reloadData];
}

-(void)tongzhiNumberMethod{
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = usermodel.userID;
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载..."];
    [XKNetworkManager POSTToUrlString:JianZhiTongJi parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *result = JSonDictionary;
        
        
        
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            weakSelf.jianzhinumber = [NSString stringWithFormat:@"%@",result[@"rst"][@"num"]];
            if ([weakSelf.jianzhinumber integerValue] == 0 ) {
                self.tabBarItem.badgeValue = nil;
            }
            
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(LHKCompayCenterHeadView *)headView{
    if (_headView == nil) {
        _headView = [LHKCompayCenterHeadView headView];
        _headView.frame = CGRectMake(0, 130, ScreenWidth, 185);
        _headView.delegate = self;
    }
    return _headView;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.model = [[UserInfoModel alloc] init];

        self.dataArr= @[@[@"项目合同",@"开票信息",@"附近企业"],@[@"招聘申请",@"通知中心"],@[@"联系我们",@"系统设置"]];
        self.imageArr=@[@[@"company_yonghuxieyi",@"fapiaotaitou",@"personcenter_fujin"],@[@"company_zhaopinshenqing",@"personcenter_tongzhi"],@[@"personcenter_lianxi",@"personcenter_shezhi"]];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.redViewIsShow = YES;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [MobClick event:@"clickPersonCenterNums"];

    self.title = @"企业中心";
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCompanyInfo) name:@"FXReloadCompanyInfo" object:nil];
    
    

}
- (void)reloadCompanyInfo{
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, userModel.avatar]] placeholderImage:[UIImage imageNamed:@"morenIcon"]];

    if (self.nameLabel) {
        [self.nameLabel removeFromSuperview];    }

    if (self.settingNameLabel) {
        
        self.settingNameLabel.text = userModel.nickname;
        self.settingNameLabel.font = [UIFont systemFontOfSize:14];
        self.settingNameLabel.textColor = [UIColor whiteColor];
        [self.panView addSubview:self.settingNameLabel];
        
    }else{
        
        self.settingNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 48, self.view.frame.size.width/2, 20)];
        self.settingNameLabel.text = userModel.nickname;
        self.settingNameLabel.font = [UIFont systemFontOfSize:14];
        self.settingNameLabel.textColor = [UIColor whiteColor];
        [self.panView addSubview:self.settingNameLabel];
        
    }

}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    UIView *headerView = [self setupTableViewHeadView];
    headerView.frame =CGRectMake(0, 0, ScreenWidth, 315);
    _tableView.tableHeaderView = headerView;

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
    
   
    if ([userModel.nickname isEqualToString:@""] || !userModel.nickname) {
        self.nameLabel = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 52, 150, 20)];
        [self.nameLabel addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image= [UIImage imageNamed:@"personcenter_name_before"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        
        NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:LoginUsernameSave];
        
        [self.nameLabel setTitle:nameStr forState:UIControlStateNormal];
        self.nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        self.nameLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.nameLabel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                [self.nameLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nameLabel.userInteractionEnabled = YES;
          [bgView addSubview:self.nameLabel];
        
    }else{
        
        self.settingNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 48, self.view.frame.size.width/2, 20)];
        self.settingNameLabel.text = userModel.nickname;
        self.settingNameLabel.font = [UIFont systemFontOfSize:14];
        self.settingNameLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:self.settingNameLabel];


    }

    
    self.editBtn = [[LHKLeftButoon alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 20, 77, 100, 20)];
    [self.editBtn setImage:[UIImage imageNamed:@"bianjiziliao"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];
   
    [self.editBtn setTitle:@"编辑信息" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    [bgView addSubview:self.editBtn];
    
  
    
    [bgView addSubview:self.headView];
    
    return bgView;
}

#pragma mark--名字点击
-(void)nameBtnClick{
    FXCompanyInfoController *infoVc = [[FXCompanyInfoController alloc]init];
    infoVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVc animated:YES];
}

#pragma mark 头像点击
- (void)iconDidClick{
    FXCompanyInfoController *infoVc = [[FXCompanyInfoController alloc]init];
    infoVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVc animated:YES];
}

//企业钱包
- (void)companyInfoClick{
    FXMyWalletController *vc = [[FXMyWalletController alloc] initWithWhere:1];
    vc.hidesBottomBarWhenPushed = YES;
    pushToControllerWithAnimated(vc)
}

//企业需求
- (void)companyNeedClick{
    FXNeedsListController *needVc = [[FXNeedsListController alloc] initWithWhere:1];
    needVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:needVc animated:YES];
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArr[section];
    return array.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1|| section == 2) {
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* const identifier = @"CompanyMineTableViewCell";
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    UIImageView *accImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_jiantou"]];
    cell.accessoryView = accImageView;

    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");

    cell.redView.hidden = YES;
    NSArray *dataArray = self.dataArr[indexPath.section];
    NSArray *imageArray = self.imageArr[indexPath.section];
    cell.leftImage.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.titleLabel.text = dataArray[indexPath.row];
    cell.titleLabel.textColor = UIColorFromRGBString(@"0x545454");
    cell.jianzhinumberLabel.hidden = YES;
  
    
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if ([ZQ_CommonTool isEmpty:self.jianzhinumber]  || [self.jianzhinumber isEqualToString:@"0"]) {
                cell.jianzhinumberLabel.hidden = YES;
            }else{
                cell.jianzhinumberLabel.hidden = NO;
                cell.jianzhinumberLabel.text = self.jianzhinumber;
            }
            
        }
        
        if (indexPath.row == 1) {
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
        
        if (indexPath.section == 0) {
            
           
            if (indexPath.row == 0) {
                UserAgreementViewController *vc = [[UserAgreementViewController alloc]initWithWhere:1];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if (indexPath.row == 1){
                
                BillViewController *billvc = [[BillViewController alloc]init];
                                billvc.navigationItem.title = @"开票信息";
                                billvc.hidesBottomBarWhenPushed = YES;
                                pushToControllerWithAnimated(billvc)

                
                
            }else{
                

                FXNearbyCompanyController *nearbyVc = [[FXNearbyCompanyController alloc]init];
                nearbyVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:nearbyVc animated:YES];
            }
            


            
        }else if(indexPath.section == 1) {
            indexPath.row == 0 ?
            ({
                
                
                JianZhiShenHeVC *shenheVc = [[JianZhiShenHeVC alloc]init];
                                shenheVc.hidesBottomBarWhenPushed = YES;
                                shenheVc.navigationItem.title = @"招聘申请";
                                pushToControllerWithAnimated(shenheVc)

})
            :
            ({
                
                
                
                NotificationMessageViewController *vc = [[NotificationMessageViewController alloc] init];
                                vc.title = @"通知中心";
                                self.redViewIsShow = NO;
                                vc.hidesBottomBarWhenPushed = YES;
                                pushToControllerWithAnimated(vc)
                                self.tabBarItem.badgeValue = nil;

                
                
            });
  
            
        }else{//第二个section
            
            if (indexPath.row == 0) {

                
                ContactUsViewController *vc = [[ContactUsViewController alloc] init];
                                                vc.hidesBottomBarWhenPushed = YES;
                                                pushToControllerWithAnimated(vc)

            }else{
                SetViewController *vc = [[SetViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                pushToControllerWithAnimated(vc)
            }
            

            
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

-(void)compayCenterHeadViewButtonClick:(UIButton *)btn{
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    if ([model.userID isEqualToString:@"0"]) {
        [ZQ_CallMethod againLogin];
        return;
    }
    
    switch (btn.tag) {
        case 201: //企业钱包
        {
            [self companyInfoClick];
        }
            break;
        case 202: //企业需求
        {
            [self companyNeedClick];
        }
            break;
        case 203: //我的收藏
        {
            FXMyCollectController *collectVc = [[FXMyCollectController alloc]init];
            [self.navigationController pushViewController:collectVc animated:YES];

        }
            break;
        case 204: //工作上报列表
        {
            WorkupLoadListVc *workVc = [[WorkupLoadListVc alloc]init];
            workVc.hidesBottomBarWhenPushed = YES;
            workVc.navigationItem.title=@"凭证列表";
            //
            [MobClick event:@"pingzhengshenhe"];
            
            [self.navigationController pushViewController:workVc animated:YES];
 
        }
            break;
        case 205: //分析助手
        {
            FXAnalyseController *anaVc = [[FXAnalyseController alloc]init];
            anaVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:anaVc animated:YES];

        }
            break;
        case 206: //红包零钱
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


@end
