//
//  CloudSquareViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/1/3.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CloudSquareViewController.h"
#import "MineTableViewCell.h"

#import "InformationListViewController.h"
#import "GoodsListViewController.h"

#import "JYSlideSegmentController.h"
#import "ContactListViewController.h"
#import "ConversationListController.h"

#import "AllyCircleViewController.h"

#import "AddFriendViewController.h"
#import "CreateGroupViewController.h"
#import "AllyCircleViewController.h"
#import "ReleaseAllyCircleViewController.h"
#import "LHKNearSellerViewController.h"
#import "LHKSellerWriteViewController.h"
#import "JXCloudSquareHeaderView.h"
#import "NotificationMessageViewController.h"


@interface CloudSquareViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,ReleaseAllyCircleViewControllerDeleagete>
@property (nonatomic, strong) UIView *popUpView;
@property (nonatomic, strong) AllyCircleViewController *allyCircleVC;
@property(nonatomic,assign)  BOOL isCanWirteCompanyInfo;
@property (nonatomic, strong) NotificationMessageViewController *notiMsgVc;
@property (nonatomic, weak) JXCloudSquareHeaderView *headerView;

@end

@implementation CloudSquareViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [ZQ_CallMethod setupNewMessageBoxCount];
    [_tableView reloadData];
    
    UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
    if ([userInfoModel.userID isEqualToString:@"0"]) {
        
    }else{
        [self getPersonInfoData];
    }
    
    /// 刷新数据
    [self.notiMsgVc.tableView.mj_header beginRefreshing];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    if ([model.userID isEqualToString:@"0"]) {
        [_headerView leftAction];
    }
}




//先拿个人资料的数据
- (void)getPersonInfoData{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    params[@"uModelid"] = userModel.identity;
    params[@"uid"] = userModel.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.basicInfo"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            
            NSString *jobStr =  tempDic[@"jobType"];
            
            if ([jobStr integerValue] == 1 ) {
                weakSelf.isCanWirteCompanyInfo = YES;
            }else{
                weakSelf.isCanWirteCompanyInfo = NO;
            }
            
        }else{
            [weakSelf showHint:@"数据异常"];
            weakSelf.isCanWirteCompanyInfo = NO;
            
        }
        
        [weakSelf.tableView reloadData];
     
      
        
        
        
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
       
        [SVProgressHUD dismiss];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupHeaderView];
    [self setupTableView];
    [MobClick event:@"clickSquareNums"];
    [self addNotiMsgVc];
    
}



- (void)addNotiMsgVc{
    self.notiMsgVc = [[NotificationMessageViewController alloc]init];
    [self addChildViewController:self.notiMsgVc];
    self.notiMsgVc.view.frame = CGRectMake(0, HRadio(44), ScreenWidth, ScreenHeight - 44 - HRadio(44));
    self.notiMsgVc.view.hidden = YES;
    [self.view addSubview:self.notiMsgVc.view];
}

- (void)setupHeaderView{
    JXCloudSquareHeaderView *headerView = [[JXCloudSquareHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HRadio(44))];
    _headerView = headerView;
    MJWeakSelf;
    headerView.selectBlock = ^(NSInteger idx) {
        weakSelf.notiMsgVc.view.hidden = idx == 0 ? YES : NO;
    };
    
    [self.view addSubview:headerView];
}

- (void)setupNav{
    self.title = @"云广场";
    
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HRadio(44), self.view.frame.size.width, self.view.frame.size.height - 49 - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
}




#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;
//    }else {
//        //
//        if ([ZQ_AppCache canSellerWrite]) {
//            return 2;
//        }else{
//            return 1;
//        }    }
    
    
    if (self.isCanWirteCompanyInfo) {
                    return 2;
                }
                    return 1;
                

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *const identifier = @"CloudSquareViewController";
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.redView.hidden = YES;
    cell.jianzhinumberLabel.hidden = YES;
//    if (indexPath.section == 0) {
//        cell.leftImage.image = [UIImage imageNamed:@"messages_icon"];
//        cell.titleLabel.text = @"消息";
//        if (self.tabBarItem.badgeValue != nil && self.tabBarItem.badgeValue != 0) {
//            cell.redView.hidden = NO;
//        }
//    } else if(indexPath.section == 1) {
//        cell.leftImage.image = [UIImage imageNamed:@"friendsquan"];
//        cell.titleLabel.text = @"盟友圈";
//        NSInteger allyC = [USERDEFALUTS integerForKey:@"allyCircleCount"];
//        if (allyC == nil || allyC == 0) {
//            allyC = 0;
//        }
//        if (allyC != 0) {
//            cell.redView.hidden = NO;
//        }
//    } else
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");

//        if(indexPath.section == 0) {
//            
//          if(indexPath.row == 0) {
//            cell.leftImage.image = [UIImage imageNamed:@"hot_zixun"];
//            cell.titleLabel.text = @"热点资讯";
//          }else if(indexPath.row == 1) {
//            cell.leftImage.image = [UIImage imageNamed:@"hot_shangpin"];
//            cell.titleLabel.text = @"热门商品";
//        }
//        
//        } else if (indexPath.section == 1){
//        //新增加的功能
//        if (indexPath.row == 0) {
//            cell.leftImage.image = [UIImage imageNamed:@"nearSeller"];
//            cell.titleLabel.text = @"附近商家";
//        }else if (indexPath.row == 1 && [ZQ_AppCache canSellerWrite]){
//            cell.titleLabel.text = @"商家录入";
//            cell.leftImage.image = [UIImage imageNamed:@"sellerwrite"];
//
//        }
//    
//    }
    
    
    //新增加的功能
            if (indexPath.row == 0) {
                cell.leftImage.image = [UIImage imageNamed:@"nearSeller"];
//                cell.titleLabel.text = @"已推广商家";
                cell.titleLabel.text = @"附近商家";
            }else if (indexPath.row == 1 && self.isCanWirteCompanyInfo){
                // else if (indexPath.row == 1 && [ZQ_AppCache canSellerWrite])
                cell.titleLabel.text = @"商家录入";
                cell.leftImage.image = [UIImage imageNamed:@"sellerwrite"];
    
            }

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *backGroudView = [[UIView alloc]initWithFrame:cell.bounds];
    backGroudView.backgroundColor = UIColorFromRGBString(@"#e8e8e8");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
//    if (indexPath.section == 0) {
//        if ([infoModel.userID isEqualToString:@"0"]) {
//            [ZQ_CallMethod againLogin];
//        } else {
//            ConversationListController *chatListVC = [[ConversationListController alloc] init];
//            chatListVC.title = @"消息";
//            ContactListViewController *contactsVC = [[ContactListViewController alloc] init];
//            contactsVC.title = @"通讯录";
//            if (self.allyCircleVC) {
//                [self.allyCircleVC removeFromParentViewController];
//                self.allyCircleVC = nil;
//            }
//            self.allyCircleVC = [[AllyCircleViewController alloc] initWithWhere:2];
//            _allyCircleVC.title = @"盟友圈";
//            NSArray *vcs2 = [NSArray arrayWithObjects:chatListVC, contactsVC, _allyCircleVC, nil];
//            JYSlideSegmentController *messageVC = [[JYSlideSegmentController alloc] initWithViewControllers:vcs2];
//            messageVC.title = @"消息";
//            messageVC.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
//            messageVC.indicator.backgroundColor = MainColor;
//            messageVC.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"add_icon2" selectedImage:@"add_icon2" target:self action:@selector(rightBarButtonItem)];
//            messageVC.hidesBottomBarWhenPushed = YES;
//            pushToControllerWithAnimated(messageVC)
//        }
//    } else if (indexPath.section == 1) {
//        if ([infoModel.userID isEqualToString:@"0"]) {
//            [ZQ_CallMethod againLogin];
//        } else {
//            if (self.allyCircleVC) {
//                [self.allyCircleVC removeFromParentViewController];
//                self.allyCircleVC = nil;
//            }
//            AllyCircleViewController *vc = [[AllyCircleViewController alloc] initWithWhere:1];
//            vc.hidesBottomBarWhenPushed = YES;
//            pushToControllerWithAnimated(vc)
//        }
//    } else
    
        
//        if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            InformationListViewController *vc = [[InformationListViewController alloc] initWith:1];
//            pushToControllerWithAnimated(vc)
//        } else if (indexPath.row == 1) {
//            GoodsListViewController *vc = [[GoodsListViewController alloc] initWith:1];
//            pushToControllerWithAnimated(vc)
//        }
//    }
//    else if (indexPath.section == 1){
//        //附近的商家
//        if (indexPath.row == 0) {
//            LHKNearSellerViewController *nearSellearVc = [[LHKNearSellerViewController alloc]initWith:1];
//            
//            nearSellearVc.hidesBottomBarWhenPushed = YES;
//            pushToControllerWithAnimated(nearSellearVc);
//            
//        
//
//            
//        }else if (indexPath.row == 1){
//            LHKSellerWriteViewController *sellerWirteVc = [[LHKSellerWriteViewController alloc]initWith:1];
//            
//            sellerWirteVc.hidesBottomBarWhenPushed = YES;
//            pushToControllerWithAnimated(sellerWirteVc);
//
//            
//        }
//        
//    }
//
    
    
    if (indexPath.row == 0) {
                    LHKNearSellerViewController *nearSellearVc = [[LHKNearSellerViewController alloc]initWith:1];
        
                    nearSellearVc.hidesBottomBarWhenPushed = YES;
                    pushToControllerWithAnimated(nearSellearVc);
        
        
        
        
                }else if (indexPath.row == 1){
                    LHKSellerWriteViewController *sellerWirteVc = [[LHKSellerWriteViewController alloc]initWith:1];
        
                    sellerWirteVc.hidesBottomBarWhenPushed = YES;
                    pushToControllerWithAnimated(sellerWirteVc);
        
                    
                }
    

}




//导航栏右边按钮点击事件
- (void)rightBarButtonItem{
    
    if (_popUpView) {
        [_popUpView removeAllSubviews];
        [_popUpView removeFromSuperview];
        _popUpView = nil;
    } else {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:[self setPopView]];
    }
}

#pragma mark 导航栏右侧按钮点击之后出现的页面
- (UIView *)setPopView
{
    self.popUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height)];
    _popUpView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.3];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 63)];
    view1.backgroundColor = [UIColor clearColor];
    [_popUpView addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width - 152, ZQ_Device_Height)];
    view2.backgroundColor = [UIColor clearColor];
    [_popUpView addSubview:view2];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(ZQ_Device_Width - 152, 193, ZQ_Device_Width, ZQ_Device_Height - 193)];
    view3.backgroundColor = [UIColor clearColor];
    [_popUpView addSubview:view3];
    
    UITapGestureRecognizer *singleFinger1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPopUpView:)];
    singleFinger1.numberOfTouchesRequired = 1; //手指
    singleFinger1.numberOfTapsRequired = 1;    //tap次数
    singleFinger1.cancelsTouchesInView = NO;
    singleFinger1.delegate = self;
    UITapGestureRecognizer *singleFinger2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPopUpView:)];
    singleFinger2.numberOfTouchesRequired = 1;
    singleFinger2.numberOfTapsRequired = 1;
    singleFinger2.cancelsTouchesInView = NO;
    singleFinger2.delegate = self;
    UITapGestureRecognizer *singleFinger3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPopUpView:)];
    singleFinger3.numberOfTouchesRequired = 1;
    singleFinger3.numberOfTapsRequired = 1;
    singleFinger3.cancelsTouchesInView = NO;
    singleFinger3.delegate = self;
    [view1 addGestureRecognizer:singleFinger1];
    [view2 addGestureRecognizer:singleFinger2];
    [view3 addGestureRecognizer:singleFinger3];
    
    
    UIImageView *popView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageBox"]];
    popView.frame = CGRectMake(ZQ_Device_Width - 152, 63, 140, 130);
    [popView setUserInteractionEnabled:YES];
    [_popUpView addSubview:popView];
    
    //发起群聊
    ZQImageAndLabelButton *groupChatButton = [[ZQImageAndLabelButton alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(popView.frame), (CGRectGetHeight(popView.frame) - 10)/3 - 0.5)];
    groupChatButton.label.font = [UIFont systemFontOfSize:15];
    groupChatButton.label.text = @"发起群聊";
    groupChatButton.label.textColor = kUIColorFromRGB(0x808080);
    groupChatButton.imageV.image = [UIImage imageNamed:@"groupChat"];
    groupChatButton.imageV.frame = ZQ_RECT_CREATE(20, 10, 20, 20);
    groupChatButton.label.frame = ZQ_RECT_CREATE(50, 0, CGRectGetWidth(groupChatButton.frame) - 50, 40);
    [groupChatButton addTarget:self action:@selector(groupChatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:groupChatButton];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(10, 10 + (CGRectGetHeight(popView.frame) - 10)/3 - 0.5, CGRectGetWidth(popView.frame) - 20, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [popView addSubview:lineView1];
    
    //添加朋友
    ZQImageAndLabelButton *addBuddyButton = [[ZQImageAndLabelButton alloc] initWithFrame:CGRectMake(0, 10 + (CGRectGetHeight(popView.frame) - 10)/3 + 0.5, CGRectGetWidth(popView.frame), (CGRectGetHeight(popView.frame) - 10)/3 - 0.5)];
    addBuddyButton.label.font = [UIFont systemFontOfSize:15];
    addBuddyButton.label.text = @"添加好友";
    addBuddyButton.label.textColor = kUIColorFromRGB(0x808080);
    addBuddyButton.imageV.image = [UIImage imageNamed:@"addBuddy"];
    addBuddyButton.imageV.frame = ZQ_RECT_CREATE(20, 10, 20, 20);
    addBuddyButton.label.frame = ZQ_RECT_CREATE(50, 0, CGRectGetWidth(groupChatButton.frame) - 50, 40);
    [addBuddyButton addTarget:self action:@selector(addBuddyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:addBuddyButton];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(10, 10 + (CGRectGetHeight(popView.frame) - 10)/3*2 - 0.5, CGRectGetWidth(popView.frame) - 20, 1)];
    lineView2.backgroundColor = kUIColorFromRGB(0xcccccc);
    [popView addSubview:lineView2];
    
    //发朋友圈
    ZQImageAndLabelButton *releaseButton = [[ZQImageAndLabelButton alloc] initWithFrame:CGRectMake(0, 10 + (CGRectGetHeight(popView.frame) - 10)/3*2 + 0.5, CGRectGetWidth(popView.frame), (CGRectGetHeight(popView.frame) - 10)/3 - 0.5)];
    releaseButton.label.font = [UIFont systemFontOfSize:15];
    releaseButton.label.text = @"发盟友圈";
    releaseButton.label.textColor = kUIColorFromRGB(0x808080);
    releaseButton.imageV.image = [UIImage imageNamed:@"sendFriendCircle"];
    releaseButton.imageV.frame = ZQ_RECT_CREATE(20, 10, 20, 20);
    releaseButton.label.frame = ZQ_RECT_CREATE(50, 0, CGRectGetWidth(groupChatButton.frame) - 50, 40);
    [releaseButton addTarget:self action:@selector(releaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:releaseButton];
    
    return _popUpView;
}

-(void)hiddenPopUpView:(UITapGestureRecognizer *)tap
{
    [_popUpView removeAllSubviews];
    [_popUpView removeFromSuperview];
    _popUpView = nil;
}

//发起群聊
- (void)groupChatButtonClick

{
    
    if (_popUpView) {
        [_popUpView removeAllSubviews];
        [_popUpView removeFromSuperview];
        _popUpView = nil;
 
    }
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
//    [self.navigationController pushViewController:createChatroom animated:YES];
     createChatroom.hidesBottomBarWhenPushed = YES;
    [[self getTabBarVcChilrdVC:3] pushViewController:createChatroom animated:YES];
    
}

//加好友
- (void)addBuddyButtonClick
{
    if (_popUpView) {
        [_popUpView removeAllSubviews];
        [_popUpView removeFromSuperview];
        _popUpView = nil;
        
    }
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    AddFriendViewController *vc;
    if ([model.identity integerValue] == 6) {
        vc = [[AddFriendViewController alloc] initWithBDOrEnterprise:1];
    } else if ([model.identity integerValue] == 5) {
        vc = [[AddFriendViewController alloc] initWithBDOrEnterprise:2];
    }
     vc.hidesBottomBarWhenPushed = YES;
    [[self getTabBarVcChilrdVC:3] pushViewController:vc animated:YES];
}

//发盟友圈
- (void)releaseButtonClick
{
    if (_popUpView) {
        [_popUpView removeAllSubviews];
        [_popUpView removeFromSuperview];
        _popUpView = nil;
        
    }
    ReleaseAllyCircleViewController *vc = [[ReleaseAllyCircleViewController alloc] initWithWhere:1];
    vc.deleagete = self;
    vc.hidesBottomBarWhenPushed = YES;
    [[self getTabBarVcChilrdVC:3] pushViewController:vc animated:YES];
}

- (void)gobackTableViewReload
{
    [_allyCircleVC tableViewDataReload];
}


@end
