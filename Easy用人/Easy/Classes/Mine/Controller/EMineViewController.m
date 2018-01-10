//
//  EMineViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/23.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMineViewController.h"
#import "EMineHeaderView.h"
#import "EMineTableViewCell.h"
#import "EMoreViewController.h"
#import "EBindPhoneViewController.h"
#import "ENotiCenterViewController.h"
#import "EDocumentCenterViewController.h"
#import "EPerfectInfoViewController.h"
#import "EUserModel.h"
#import "EPartManagerViewController.h"
#import "EMineViewModel.h"
#import "EDocumentCenterModel.h"
#import "EMyTeamViewController.h"
#import "EMyCommentViewController.h"

@interface EMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) EMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <EMineCellModel *>*datas;
@property (nonatomic, strong) EMineViewModel *viewModel;

@end

@implementation EMineViewController
#pragma mark - *** lazy load
- (EMineViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EMineViewModel alloc]init];
    }
    return _viewModel;
}
- (NSMutableArray <EMineCellModel *> *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


- (EMineHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[EMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, E_RealHeight(143))];
        _headerView.image = [UIImage imageGradientWithFrame:CGRectMake(0, 0, kScreenW, E_RealHeight(143)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        JXWeak(self);
        _headerView.phoneBlock = ^{
            [weakself.navigationController pushViewController:[[EBindPhoneViewController alloc]init] animated:YES];
        };
        _headerView.headerBlock = ^{
            EPerfectInfoViewController *vc = [[EPerfectInfoViewController alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        
        _headerView.addGroupBlock = ^{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"确定申请为带队?" preferredStyle:UIAlertControllerStyleAlert];
            
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                [EMineViewModel upgradeGroup:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [EUserInfoManager updateUserInfo:^{
                            [weakself reload];
                        }];
                    }
                }];
                
            }]];
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [weakself presentViewController:alertC animated:YES completion:nil];
            
        };
        
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = E_RealHeight(44);
    }
    return _tableView;
}

#pragma mark - *** Cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.tableView.sectionFooterHeight = 0.0001;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initialize];
    
    JXWeak(self);
    self.headerView.userModel = [EUserInfoManager getUserInfo];
    self.tableView.tableHeaderView = self.headerView;
    [EMineViewModel getUnreadMsgCount:^(NSString *count) {
        EMineCellModel *model = self.datas[2];
        model.hintString = [NSString stringWithFormat:@"(%@)",count];
        [self.tableView reloadData];
    }];
    
    [self.viewModel getAuthenticationInfo:^{
         EMineCellModel *model = self.datas[0];
        
        //
        if (weakself.viewModel.authenModel.status == nil) {
            model.hintString = @"未上传";
        }
        else{
            switch ([weakself.viewModel.authenModel.status intValue]) {
                case 0:
                    model.hintString = @"审核中";
                    break;
                case 1:
                    model.hintString = @"审核失败";
                    break;
                    
                case 2:
                    model.hintString = @"已上传";
                    break;
                    
                default:
                    break;
            }
        }
        
        [weakself.tableView reloadData];
    }];
    
    
   
}


#pragma mark - *** Private Method

/// 刷新
- (void)reload{
    [self initialize];
    self.headerView.userModel = [EUserInfoManager getUserInfo];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView reloadData];
}
/// 初始化
- (void)initialize{
    self.datas = nil;
    /// 领队
    if ([[EUserInfoManager getUserInfo].type intValue] == 1) {
        
        NSArray *lefts = @[@"证件中心",@"我的评价",@"通知中心",@"兼职管理",@"我的团队",@"更多"];
        NSArray *hints = @[@"未上传",@"",@"",@"",@"",@""];
        /// 1：no 2：left 3：右
        NSArray *styles = @[@(3),@(1),@(2),@(1),@(1),@(1)];
        for (int i = 0; i < lefts.count; i ++) {
            EMineCellModel *model = [[EMineCellModel alloc]init];
            model.leftString = lefts[i];
            model.hintString = hints[i];
            model.style = [styles[i] integerValue];
            [self.datas addObject:model];
        }
    }
    /// 小时工
    else{
        
        NSArray *lefts = @[@"证件中心",@"我的评价",@"通知中心",@"更多"];
        NSArray *hints = @[@"未上传",@"",@"",@""];
        /// 1：no 2：left 3：右
        NSArray *styles = @[@(3),@(1),@(2),@(1)];
        for (int i = 0; i < lefts.count; i ++) {
            EMineCellModel *model = [[EMineCellModel alloc]init];
            model.leftString = lefts[i];
            model.hintString = hints[i];
            model.style = [styles[i] integerValue];
            [self.datas addObject:model];
        }
    }
    
}

- (void)setupUI{
    
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMineTableViewCell *cell = [EMineTableViewCell cellForTableView:tableView];
    cell.model = self.datas[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f0e9d8"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) { /// “兼职管理”与“我的团队”间距
        return 1;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: /// 证件中心
        {
            EDocumentCenterViewController *vc = [[EDocumentCenterViewController alloc]init];
            vc.model = self.viewModel.authenModel;
            if (kStringIsEmpty(self.viewModel.authenModel.status)) {
                vc.status = EDocumentCenterStatusNone;
            }
            else{
                vc.status = [self.viewModel.authenModel.status intValue];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1: /// 我的评价
        {
            [self.navigationController pushViewController:[[EMyCommentViewController alloc]init] animated:YES];
        }
            break;
            
        case 2:/// 通知中心
        {
            [self.navigationController pushViewController:[[ENotiCenterViewController alloc]init] animated:YES];
        }
            break;
            
        case 3:/// 兼职管理
        {
            /// 小时工
            if ([[EUserInfoManager getUserInfo].type intValue] == 0){
                [self.navigationController pushViewController:[[EMoreViewController alloc]init] animated:YES];
                return;
            }
            
            [self.navigationController pushViewController:[[EPartManagerViewController alloc]init] animated:YES];
        }
            break;
            
        case 4:/// 我的团队
        {
            
            [self.navigationController pushViewController:[[EMyTeamViewController alloc]init] animated:YES];
            
        }
            break;
            
        case 5:/// 更多
        {
            [self.navigationController pushViewController:[[EMoreViewController alloc]init] animated:YES];
        }
            break;
        default:
            break;
    }
}




@end
