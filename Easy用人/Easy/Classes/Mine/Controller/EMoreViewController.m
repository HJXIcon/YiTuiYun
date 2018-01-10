//
//  EMoreViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMoreViewController.h"
#import "EMineTableViewCell.h"
#import "EChangePsdViewController.h"
#import "EFeedbackViewController.h"
#import "EHomeViewModel.h"
#import "EMineViewModel.h"
#import "ESetPasswordViewController.h"
#import "EUserModel.h"

@interface EMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <EMineCellModel *>*datas;
@property (nonatomic, strong) UIButton *logoutBtn;
@end

@implementation EMoreViewController
#pragma mark - *** lazy load
- (UIButton *)logoutBtn{
    if (_logoutBtn == nil) {
        _logoutBtn = [JXFactoryTool creatButton:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"退出当前账号" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(logoutAction:)];
        _logoutBtn.centerX = self.view.centerX;
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(100)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        _logoutBtn.cornerRadius = E_RealHeight(25);
        [_logoutBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _logoutBtn;
}


- (NSMutableArray <EMineCellModel *> *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        NSArray *lefts = @[@"修改密码",@"关于我们",@"意见反馈",@"版本更新"];
        for (int i = 0; i < lefts.count; i ++) {
            EMineCellModel *model = [[EMineCellModel alloc]init];
            model.leftString = lefts[i];
            [_datas addObject:model];
        }
    }
    return _datas;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
    [self setupUI];
    
    
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = E_RealHeight(44);
    self.logoutBtn.frame = CGRectMake(0, 44 * 4 + E_RealHeight(64), E_RealWidth(300), E_RealHeight(50));
    self.logoutBtn.centerX = self.view.centerX;
    [self.tableView addSubview:self.logoutBtn];
    [self.tableView bringSubviewToFront:self.logoutBtn];
    
}


#pragma mark - *** Actions
- (void)logoutAction:(UIButton *)button{
    [[NSUserDefaults standardUserDefaults]setObject:[EUserInfoManager getUserInfo].mobile forKey:E_MobileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [EUserInfoManager removeUserInfo];
    [EControllerManger turnToLoginController];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMineTableViewCell *cell = [EMineTableViewCell cellForTableView:tableView];
    cell.model = self.datas[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f0e9d8"];
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:/// 修改密码
            {
                /// 是否设置了密码
                [EMineViewModel checkIsSetPwd:^(BOOL isSetPwd) {
                    if (isSetPwd) {
                         [self.navigationController pushViewController:[[EChangePsdViewController alloc]init] animated:YES];
                    }else{
                         [self.navigationController pushViewController:[[ESetPasswordViewController alloc]init] animated:YES];
                    }
                }];
               
            }
            break;
            
        case 1:/// 关于我们
        {
            
        }
            break;
            
        case 2:/// 意见反馈
        {
            [self.navigationController pushViewController:[[EFeedbackViewController alloc]init] animated:YES];
        }
            break;
            
        case 3:/// 版本更新
        {
            [self checkUpVersion];
        }
            break;
            
        default:
            break;
    }
}


/// 版本更新
- (void)checkUpVersion{
    
    [EHomeViewModel getVersion:^(NSString *iosVersion, NSString *iosUrl, NSString *force) {
        NSString *appUpdateString = @"当前已是最新版本";
        if ([E_APP_VERSION isEqualToString:iosVersion]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:appUpdateString preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertC animated:YES completion:nil];
            return ;
        }
        
        if (![E_APP_VERSION isEqualToString:iosVersion]) {
            appUpdateString = [NSString stringWithFormat:@"检测到最新版本%@,你是否要更新？",iosVersion];
        }
        
        [self jx_showNewVersionWithDes:appUpdateString isShowNeverUpdate:NO cancelBlock:^(BOOL isNever) {
            JXLog(@"cancel --- %d",isNever);
        } updateBlock:^{
            JXLog(@"updateBlock --- ");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iosUrl]];
        }];
        
        
    }];
}

@end
