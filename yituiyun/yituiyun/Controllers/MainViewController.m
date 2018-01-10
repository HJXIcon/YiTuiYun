
#import "MainViewController.h"

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "PushWebViewController.h"

#import "HomePageViewController.h"
#import "TaskHallViewController.h"
//#import "RecommendViewController.h"
#import "CloudSquareViewController.h"
#import "KNMineController.h"
#import "FXCompanyMineController.h"
#import "TaskHallEnterpriseViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "FXMyWalletController.h"
#import "FXNeedsListController.h"
#import "TaskDetailViewController.h"
#import "FXInsureTaskListController.h"
#import "InformationListViewController.h"
#import "GoodsListViewController.h"
#import "ProjectDetailViewController.h"
#import "ChatViewController.h"
#import "ApplyViewController.h"
#import "InvitationManager.h"
#import "JYSlideSegmentController.h"
#import "ConversationListController.h"
#import "ContactListViewController.h"
#import "AllyCircleViewController.h"
#import "LHKNavController.h"
#import "LogoutAlterView.h"
#import "RealNameVc.h"
#import "YYModel.h"
#import "TaskHallEnterpriseDetailJianZhiVC.h"
@interface MainViewController () <UITabBarControllerDelegate,EMChatManagerDelegate,EMClientDelegate,EMContactManagerDelegate,EMGroupManagerDelegate>
@property (nonatomic, strong) HomePageViewController *homePageVC;
@property (nonatomic, strong) TaskHallViewController *taskHallVC;
//@property (nonatomic, strong) RecommendViewController *recommendVC;
@property (nonatomic, strong) CloudSquareViewController *recommendVC;
@property (nonatomic, strong) KNMineController *mineVC;
@property (nonatomic, strong) FXCompanyMineController *companyMineVC;;
@property (nonatomic, strong) TaskHallEnterpriseViewController *taskHallEnterpriseVC;
@property(nonatomic,strong) JYSlideSegmentController * messageVc;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
/**logoutView */
@property(nonatomic,strong) LogoutAlterView * logoutView;
@property(nonatomic,assign) BOOL isCityChange;

@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [self setupSubviews];
    
//    for (UITabBarItem *item in self.tabBar.items) {
//        item.titlePositionAdjustment = UIOffsetMake(0, -3);
//    }
    
    
    
    
}



-(LogoutAlterView *)logoutView{
    MJWeakSelf
    if (_logoutView == nil) {
        _logoutView= [LogoutAlterView alterView];
        _logoutView.frame = [UIScreen mainScreen].bounds;
        
        _logoutView.l_block = ^{
          
             
            
                     [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
                     //登录者userid
                     UserInfoModel *model = [ZQ_AppCache userInfoVo];
                     model.userID = @"0";
                     model.identity = @"6";
                     [ZQ_AppCache save:model];
                     
                     [USERDEFALUTS setInteger:0 forKey:@"pushMessageCount"];
                     [USERDEFALUTS synchronize];
                     
                     EMError *error = [[EMClient sharedClient] logout:YES];
                     if (!error) {
                         [self hideHud];
                     }
            
            
//                     [ZQ_CallMethod refreshInterface];
            
                     [ZQ_CallMethod againLogin];
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
           
            
            [weakSelf.logoutView removeFromSuperview];
            weakSelf.logoutView = nil;

            
            
        };
    }
    return _logoutView;
}


-(JYSlideSegmentController *)messageVc{
    
    if (_messageVc == nil) {
        
        ConversationListController *chatListVC = [[ConversationListController alloc] init];
        chatListVC.title = @"消息";
        ContactListViewController *contactsVC = [[ContactListViewController alloc] init];
        contactsVC.title = @"通讯录";
        AllyCircleViewController *allyCircleVC = [[AllyCircleViewController alloc] initWithWhere:2];
        allyCircleVC.title = @"盟友圈";
        NSArray *vcs2 = [NSArray arrayWithObjects:chatListVC, contactsVC, allyCircleVC,nil];
        
        
        JYSlideSegmentController *messageVC = [[JYSlideSegmentController alloc] initWithViewControllers:vcs2];
        messageVC.title = @"消息";
        messageVC.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        messageVC.indicator.backgroundColor = MainColor;
        messageVC.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"add_icon2" selectedImage:@"add_icon2" target:self action:@selector(rightBarButtonItem)];
        
        _messageVc = messageVC;
        
       
    }
    return _messageVc;
}
-(void)rightBarButtonItem{
    [self.recommendVC rightBarButtonItem];
}

-(CloudSquareViewController *)recommendVC{
    if (_recommendVC == nil) {
        _recommendVC =[[CloudSquareViewController alloc] init];

    }
    return _recommendVC;
}
//加载视图
- (void)setupSubviews
{
    for (UIViewController *vc in self.viewControllers) {
        [vc removeFromParentViewController];
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    
        //首页
        self.homePageVC = [[HomePageViewController alloc] init];
    
   
        LHKNavController *firstNC = [[LHKNavController alloc] initWithRootViewController:_homePageVC];
        self.homePageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"home_tabbar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_tabbar_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
      //云广场
    
     LHKNavController *thirdNC = [[LHKNavController alloc] initWithRootViewController:self.recommendVC];
    
    self.recommendVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"云广场" image:[[UIImage imageNamed:@"square_tabbar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"square_tabbar_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    //消息
    LHKNavController  *messNav = [[LHKNavController alloc]initWithRootViewController:self.messageVc];
    self.messageVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[[UIImage imageNamed:@"tabbar_message_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_message_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    LHKNavController *secondNC; 
    LHKNavController *fourthNC;
    
    
    if ([model.identity isEqualToString:@"6"]) {
        self.taskHallVC = [[TaskHallViewController alloc] init];
        self.mineVC = [[KNMineController alloc] init];
       
        //个人任务大厅
        _taskHallVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"任务大厅" image:[[UIImage imageNamed:@"task_tabbar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"task_tabbar_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        secondNC = [[LHKNavController alloc] initWithRootViewController:_taskHallVC];
       
        //个人任务中心
        _mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[[UIImage imageNamed:@"personCenter_tabbar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"personCenter_tabbar_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        fourthNC = [[LHKNavController alloc] initWithRootViewController:_mineVC];
    } else if ([model.identity isEqualToString:@"5"]) {
        self.taskHallEnterpriseVC = [[TaskHallEnterpriseViewController alloc] init];
        self.companyMineVC = [[FXCompanyMineController alloc]init];
       
        //企业任务大厅
        _taskHallEnterpriseVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的需求" image:[[UIImage imageNamed:@"task_tabbar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"task_tabbar_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        secondNC = [[LHKNavController alloc] initWithRootViewController:_taskHallEnterpriseVC];
        
        //企业中心
        _companyMineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"企业中心" image:[[UIImage imageNamed:@"personCenter_tabbar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"personCenter_tabbar_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        fourthNC = [[LHKNavController alloc] initWithRootViewController:_companyMineVC];
    }
    

    
    //修改所有导航栏控制器的title属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //修改所有导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xf16156)] forBarMetrics:UIBarMetricsDefault];
    
    //把试图控制器包含在rootTBC中
    self.viewControllers = @[firstNC, secondNC, thirdNC, messNav,fourthNC];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate = self;
    self.selectedIndex = 0;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       kUIColorFromRGB(0x666666), NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       kUIColorFromRGB(0xf16156), NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setupUnreadMessageCount];
    
    
      
    
}

#pragma mark - UITabBarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    LHKNavController *nav = (LHKNavController *)viewController;
    if (nav.viewControllers.firstObject == _taskHallVC || nav.viewControllers.firstObject == _mineVC || nav.viewControllers.firstObject == _taskHallEnterpriseVC || nav.viewControllers.firstObject == _companyMineVC || nav.viewControllers.firstObject == _messageVc) {
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        if ([model.userID isEqualToString:@"0"]) {
            LoginViewController *loginVC = [[LoginViewController alloc] init:2];
            LHKNavController *nav = [self addNavigationController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (void)againLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init:2];
    LHKNavController *nav = [self addNavigationController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)refreshInterface
{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    if ([model.identity isEqualToString:@"6"]) {
        if (_taskHallVC) {
            [_taskHallVC getMyTaskHall];
        }
    } else if ([model.identity isEqualToString:@"5"]) {
        if (_taskHallEnterpriseVC) {
            [_taskHallEnterpriseVC getMyTaskHall];
        }
    }
    
    if (_homePageVC) {
        [_homePageVC fromNetwork];
    }
    
}

- (void)jumpAPP:(NSDictionary *)dic
{
        
    NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
    num = num + 1;
    [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
    [USERDEFALUTS synchronize];
    
    NSInteger key = [dic[@"type"] integerValue];
    NSString *value = [NSString stringWithFormat:@"%@", dic[@"params"]];
    
    if (key == 1) {//提现驳回
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 FXMyWalletController *walletVc = [[FXMyWalletController alloc] initWithWhere:2];
                 LHKNavController *nav = [self addNavigationController:walletVc];
                 nav.hidesBottomBarWhenPushed = YES;
                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
                 
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 2) {//系统
        [WCAlertView showAlertWithTitle:@"系统通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 0) {
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
    } else if (key == 3) { //需求
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 FXNeedsListController *needVc = [[FXNeedsListController alloc] initWithWhere:2];
                 LHKNavController *nav = [self addNavigationController:needVc];
                 nav.hidesBottomBarWhenPushed = YES;
                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 4) {//任务
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 self.selectedIndex = 1;
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 5) {//节点
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 TaskDetailViewController *taskVC = [[TaskDetailViewController alloc] initWithDataId:value WithType:@"1" WithWhere:2];
                 LHKNavController *nav = [self addNavigationController:taskVC];
                 nav.hidesBottomBarWhenPushed = YES;
                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 6) {//保险
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
//                 FXInsureTaskListController *vc = [[FXInsureTaskListController alloc] initWith:2];
//                 LHKNavController *nav = [self addNavigationController:vc];
//                 nav.hidesBottomBarWhenPushed = YES;
//                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 7) {//商品
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 GoodsListViewController *vc = [[GoodsListViewController alloc] initWith:2];
                 LHKNavController *nav = [self addNavigationController:vc];
                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 8) {//资讯
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 InformationListViewController *vc = [[InformationListViewController alloc] initWith:2];
                 LHKNavController *nav = [self addNavigationController:vc];
                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    } else if (key == 9) {//项目详情
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 
                 
                 RealNameVc *relVc = [[RealNameVc alloc]init];
                 relVc.where = 2;
                 relVc.navigationItem.title = @"实名认证";

//                 UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
//                 ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:value WithType:userInfoModel.identity WithWhere:2];
                 relVc.hidesBottomBarWhenPushed = YES;
                 LHKNavController *nav = [self addNavigationController:relVc];
                 [self presentViewController:nav animated:YES completion:nil];
                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    }else if (key == 10){
        //招聘详情
        [WCAlertView showAlertWithTitle:@"通知"
                                message:dic[@"aps"][@"alert"]
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 
                if ([ZQ_CommonTool isEmpty:value]) {
                     
                 }else{
                   [self zhaoPinSelect:value];
                 }

                 NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
                 num = num - 1;
                 [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
                 [USERDEFALUTS synchronize];
                 [self setupUnreadMessageCount];
             }
         } cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
        
    }
    
    [self setupUnreadMessageCount];
}


-(void)zhaoPinSelect:(NSString*)jobID{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userinfo.userID;
    parm[@"jobid"] = jobID;
    [XKNetworkManager POSTToUrlString:JianZhiCompanyListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resut = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resut[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            JianZhiModelDetail *model = [JianZhiModelDetail objectWithKeyValues:resut[@"rst"]];
            
            TaskHallEnterpriseDetailJianZhiVC *VC = [[TaskHallEnterpriseDetailJianZhiVC alloc]init];
            VC.title = model.title;
            VC.detailModel = model;
            UITabBarController *tabVc = self;
            
            [tabVc.selectedViewController pushViewController:VC animated:YES];
            
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
}


- (void)jumpH5:(NSDictionary *)dic
{
    NSInteger num = [USERDEFALUTS integerForKey:@"pushMessageCount"];
    num = num + 1;
    [USERDEFALUTS setInteger:num forKey:@"pushMessageCount"];
    [USERDEFALUTS synchronize];
    
    PushWebViewController *webVC = [[PushWebViewController alloc] initWith:[NSString stringWithFormat:@"%@", dic[@"link"]] WithWhere:2];
    LHKNavController *nav = [self addNavigationController:webVC];
    nav.title = @"详情";
    [self presentViewController:nav animated:YES completion:nil];
    
    [self setupUnreadMessageCount];
    
}

#pragma mark -- number

- (void)customMessage:(NSDictionary *)dic
{
       NSDictionary *extras = dic[@"extras"];
    NSInteger key = [extras[@"type"] integerValue];
    if (key == 10) {
        NSString *string = [dic objectForKey:@"content"];
        [USERDEFALUTS setInteger:[string integerValue] forKey:@"allyCircleCount"];
        [USERDEFALUTS synchronize];
        [self setupUnreadMessageCount];
    }
    
    if (key == 11) {
        
        NSString *number = [ NSString stringWithFormat:@"%@",dic[@"content"]];
        
        if (self.companyMineVC !=nil) {
          self.companyMineVC.tabBarItem.badgeValue = number;  
        }
        
    }
}

- (LHKNavController *)addNavigationController:(UIViewController *)viewController
{
    LHKNavController *nav = [[LHKNavController alloc] initWithRootViewController:viewController];
    //修改所有导航栏控制器的title属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //修改所有导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xf16156)] forBarMetrics:UIBarMetricsDefault];
    
    return nav;
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

#pragma mark 环信
#pragma mark - IChatManagerDelegate 消息变化
- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    for(EMMessage *message in aMessages){
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                [self setupUnreadMessageCount];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                [self setupUnreadMessageCount];
                break;
            case UIApplicationStateBackground:
                [self setupUnreadMessageCount];
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
    }
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConversationListController" object:nil];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSInteger messC = [USERDEFALUTS integerForKey:@"pushMessageCount"];
    if (messC == nil || messC == 0) {
        messC = 0;
    } else {
        if (_mineVC) {
            if (messC > 0) {
                _mineVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)messC];
                _mineVC.redViewIsShow = YES;
            }else{
                _mineVC.tabBarItem.badgeValue = nil;
                
                _mineVC.redViewIsShow = NO;
            }
            [_mineVC.tableView reloadData];

        }
        if (_companyMineVC) {
            if (messC > 0) {
                _companyMineVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)messC];
                _companyMineVC.redViewIsShow = YES;
                
            }else{
                _companyMineVC.tabBarItem.badgeValue = nil;
                
                _companyMineVC.redViewIsShow = NO;
            }
            [_companyMineVC.tableView reloadData];
        }
    }
    
    NSInteger allyC = [USERDEFALUTS integerForKey:@"allyCircleCount"];
    if (allyC == nil || allyC == 0) {
        allyC = 0;
    }
    NSLog(@"mesc%zd",messC);
    NSLog(@"allyC:%zd", allyC);
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@(allyC),@"allyCircleciunt", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allyCircleciunt" object:nil userInfo:dict3];
    
    NSInteger applyCount = 0;
    NSString *loginName = [[EMClient sharedClient] currentUsername];
    if(loginName && [loginName length] > 0)
    {
        NSArray *applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        applyCount = [applyArray count];
    }
    NSLog(@"applyCount:%zd", applyCount);

    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@(applyCount),@"unreadContactcout", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadContactcout" object:nil userInfo:dict2];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    NSLog(@"unreadCount:%zd", unreadCount);

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(unreadCount),@"unreadcount", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadcount" object:nil userInfo:dict];
    
 
             if (self.messageVc) {
        
                if (unreadCount+applyCount+allyC > 0) {
                    
                self.messageVc.tabBarItem.badgeValue =  [NSString stringWithFormat:@"%i",(int)unreadCount + applyCount + allyC];
                
                }else{
                self.messageVc.tabBarItem.badgeValue = nil;                }
            }
            

    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount+messC+applyCount+allyC];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 2) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                messageStr = didReceiveText;
                if ([message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    messageStr = @"[动画表情]";
                }
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = @"[图片]";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = @"[语音]";
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = @"[视频]";
            }
                break;
            case EMMessageBodyTypeFile:{
                messageStr = @"[文件]";
            }
                break;
            default:{
                
            }
                break;
        }
        
        
        [self obtainUserInfo:message WithMessageStr:messageStr];
        
    } else {
        NSString *alertBody = @"您有一条新消息";
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
        BOOL playSound = NO;
        if (!self.lastPlaySoundDate || timeInterval >= 2) {
            self.lastPlaySoundDate = [NSDate date];
            playSound = YES;
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:@"MessageType"];
        [userInfo setObject:message.conversationId forKey:@"ConversationChatter"];
        
        if (![message.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:message.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    message.ext = ext;
                    [userInfo setObject:group.subject forKey:@"subject"];
                    break;
                }
            }
        }
        
        NSLog(@"%@", message.ext);
        
        //发送本地推送
        if (NSClassFromString(@"UNUserNotificationCenter")) {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            if (playSound) {
                content.sound = [UNNotificationSound defaultSound];
            }
            content.body =alertBody;
            content.userInfo = userInfo;
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        } else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date]; //触发通知的时间
            notification.alertBody = alertBody;
            notification.alertAction = @"打开";
            notification.timeZone = [NSTimeZone defaultTimeZone];
            if (playSound) {
                notification.soundName = UILocalNotificationDefaultSoundName;
            }
            notification.userInfo = userInfo;
            UIUserNotificationSettings *local = [UIUserNotificationSettings settingsForTypes:1 << 2 categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:local];
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        
    }
}

- (void)obtainUserInfo:(EMMessage *)message WithMessageStr:(NSString *)messageStr
{
    __weak MainViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uids"] = message.from;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.avatars"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:dic]) {
                NSDictionary *infoDic = responseObject[@"rst"][message.from];
                [ZQ_AppCache saveUserFriendInfo:infoDic WithName:message.from];
                [weakSelf noticeTitleWith:message With:infoDic WithMessageStr:messageStr];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf obtainUserInfo:message WithMessageStr:messageStr];
    }];
}

- (void)noticeTitleWith:(EMMessage *)message With:(NSDictionary *)dic WithMessageStr:(NSString *)messageStr
{
    NSString *title = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
    NSString *alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= 2) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:@"MessageType"];
    [userInfo setObject:message.conversationId forKey:@"ConversationChatter"];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    } else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)userAccountDidLoginFromOtherDevice
{
        [[UIApplication sharedApplication].keyWindow addSubview:self.logoutView];
    
}

#pragma mark - EMGroupManagerDelegate
//离开群组回调
- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason
{
    NSString *str = nil;
    if (aReason == EMGroupLeaveReasonBeRemoved) {
        str = [NSString stringWithFormat:@"您从%@被提出群组", aGroup.subject];
    } else if (aReason == EMGroupLeaveReasonDestroyed) {
        str = [NSString stringWithFormat:@"%@群组已解散", aGroup.subject];
    }
    
    if (str.length > 0) {
        [ZQ_UIAlertView showMessage:str cancelTitle:@"确定"];
    }
}
//申请加入群组
- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
                              user:(NSString *)aUsername
                            reason:(NSString *)aReason
{
    if (!aGroup || !aUsername) {
        return;
    }
    
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:aUsername];
    NSString *msgstr;
    if (dic) {
        if (!aReason || aReason.length == 0) {
            aReason = [NSString stringWithFormat:@"%@ 申请加入群聊", dic[@"nickname"]];
        }
        else{
            aReason = [NSString stringWithFormat:@"%@ 申请加入群聊 ：%@", dic[@"nickname"], aReason];
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aGroup.subject, @"groupId":aGroup.groupId, @"username":aUsername, @"groupname":aGroup.subject, @"applyMessage":aReason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
        [[ApplyViewController shareController] addNewApply:dic];
        [self setupUnreadMessageCount];
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
    } else {
        [self obtainUserInfoWithUserName:aUsername WithWhere:@"申请加入群组" WithOtherMessage:aReason WithGroup:aGroup];
    }
    
}

// 申请加入群组,被拒绝回调
- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
                            reason:(NSString *)aReason
{
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:aGroupId includeMembersList:NO completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            NSString *string;
            if (!aReason || aReason.length == 0) {
                string = [NSString stringWithFormat:@"\'%@\'拒绝您的加入申请", aGroup.subject];
            } else {
                string = aReason;
            }
            [ZQ_UIAlertView showMessage:string cancelTitle:@"确定"];
        }
    }];
}
// 申请加入群组，同意后的回调
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup
{
    NSString *message = [NSString stringWithFormat:@"\'%@\'通过您的加入申请", aGroup.subject];
    [ZQ_UIAlertView showMessage:message cancelTitle:@"确定"];
}
//邀请加入群组
- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage
{
    if (!aGroupId || !aInviter) {
        return;
    }
    
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:aGroupId includeMembersList:NO completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aGroup.subject, @"groupId":aGroupId, @"username":aInviter, @"groupname":aGroup.subject, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
            [[ApplyViewController shareController] addNewApply:dic];
            [self setupUnreadMessageCount];
#if !TARGET_IPHONE_SIMULATOR
            [self playSoundAndVibration];
#endif
        }
    }];
}

#pragma mark - EMContactManagerDelegate
//同意加好友
- (void)friendRequestDidApproveByUser:(NSString *)aUsername
{
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:aUsername];
    NSString *msgstr;
    if (dic) {
        msgstr = [NSString stringWithFormat:@"%@同意了您的加好友申请", dic[@"nickname"]];
        [ZQ_UIAlertView showMessage:msgstr cancelTitle:@"确定"];
    } else {
        [self obtainUserInfoWithUserName:aUsername WithWhere:@"同意了您的加好友申请" WithOtherMessage:nil WithGroup:nil];
    }
}
//拒绝加好友
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername
{
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:aUsername];
    NSString *msgstr;
    if (dic) {
        msgstr = [NSString stringWithFormat:@"%@拒绝了您的加好友申请", dic[@"nickname"]];
        [ZQ_UIAlertView showMessage:msgstr cancelTitle:@"确定"];
    } else {
        [self obtainUserInfoWithUserName:aUsername WithWhere:@"拒绝了您的加好友申请" WithOtherMessage:nil WithGroup:nil];
    }
}
////被删
//- (void)friendshipDidRemoveByUser:(NSString *)aUsername
//{
//    NSString *msgstr = [NSString stringWithFormat:@"%@删除了好友关系", aUsername];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//}

//同意加好友后，双方回调
- (void)friendshipDidAddByUser:(NSString *)aUsername
{
}
//别人申请加好友
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage
{
    if (!aUsername) {
        return;
    }
    
    [self obtainUserInfoWithUserName:aUsername WithWhere:@"别人申请加好友" WithOtherMessage:aMessage WithGroup:nil];
}

//获取资料
- (void)obtainUserInfoWithUserName:(NSString *)username WithWhere:(NSString *)name WithOtherMessage:(NSString *)message WithGroup:(EMGroup *)aGroup
{
    __weak MainViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uids"] = username;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.avatars"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:dic]) {
                NSDictionary *infoDic = responseObject[@"rst"][username];
                [ZQ_AppCache saveUserFriendInfo:infoDic WithName:username];
                if ([name isEqualToString:@"别人申请加好友"]) {
                    [weakSelf friendRequestFromUser:username message:message withInfoDic:infoDic];
                } else if ([name isEqualToString:@"同意了加好友申请"]) {
                    [ZQ_UIAlertView showMessage:[NSString stringWithFormat:@"%@同意了您的加好友申请", infoDic[@"nickname"]] cancelTitle:@"确定"];
                } else if ([name isEqualToString:@"拒绝了加好友申请"]) {
                    [ZQ_UIAlertView showMessage:[NSString stringWithFormat:@"%@拒绝了您的加好友申请", infoDic[@"nickname"]] cancelTitle:@"确定"];
                } else if ([name isEqualToString:@"申请加入群组"]) {
                    [weakSelf joinGroupRequestDidReceive:aGroup user:username reason:message];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
    }];
}

- (void)friendRequestFromUser:(NSString *)aUsername message:(NSString *)aMessage withInfoDic:(NSDictionary *)infoDic
{
    if (!aMessage) {
        aMessage = [NSString stringWithFormat:@"%@ 想加您为朋友", infoDic[@"nickname"]];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":infoDic[@"nickname"], @"username":aUsername, @"avatar":infoDic[@"avatar"], @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
    [self setupUnreadMessageCount];
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        if (NSClassFromString(@"UNUserNotificationCenter")) {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.sound = [UNNotificationSound defaultSound];
            
            content.body =[NSString stringWithFormat:@"%@ 想加您为朋友", infoDic[@"nickname"]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate] * 1000] stringValue] content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date]; //触发通知的时间
            notification.alertBody = [NSString stringWithFormat:@"%@ 想加您为朋友", infoDic[@"nickname"]];
            notification.alertAction = @"打开";
            notification.timeZone = [NSTimeZone defaultTimeZone];
        }
    }
#endif
}
//
- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userInfo[@"ConversationChatter"] conversationType:[userInfo[@"MessageType"] integerValue]];

//        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userInfo[@"ConversationChatter"] conversationType:userInfo[@"MessageType"]];
        chatController.title = userInfo[@"subject"];
        chatController.where = 2;
        chatController.hidesBottomBarWhenPushed = YES;
        LHKNavController *nav = [self addNavigationController:chatController];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
    }
}

@end
