//
//  SetViewController.m
//  宝力优佳
//
//  Created by 张强 on 16/1/8.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "SetViewController.h"
#import "AboutMyViewController.h"
#import "EMSDImageCache.h"
#import "SettingVersionCell.h"
#import "JXFileManager.h"
#import "JXShowAgreementViewController.h"



@interface SetViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** BD版数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 企业版数据源 */
@property (nonatomic, strong) NSMutableArray *enterprise_dataArray;
@property (nonatomic, strong) UISwitch *switchs;
@property (nonatomic, strong) UIButton *quitButton; //退出登录
@property(nonatomic,strong) NSString * cacheSize;


@end


@implementation SetViewController

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"关于易推云", @"当前版本号",@"易推云用户使用协议",@"易推云平台服务协议",nil];
        
        self.enterprise_dataArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"关于易推云", @"当前版本号",@"易推云用户使用协议",nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
   
    [self setupNav];
    [self setUpTableView];
    [self versionUpdate];
}

- (void)setupNav{
    self.title = @"设置";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBtnDidClick)];
}

- (void)leftBtnDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    [footer addSubview:self.quitButton];
    _tableView.tableFooterView = footer;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingVersionCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
    
    [self.view addSubview:_tableView];
}

- (UIButton*)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _quitButton.frame = CGRectMake(12, 30, self.view.frame.size.width - 24, 40);
        _quitButton.layer.cornerRadius = 5;
        _quitButton.backgroundColor =[UIColor whiteColor];
        [_quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_quitButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
        _quitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _quitButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"setViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *title = [JXLocationTool isBD] ? _dataArray[indexPath.section] : _enterprise_dataArray[indexPath.section];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = kUIColorFromRGB(0x404040);
    if (indexPath.section != 0 || indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
    }
    
    if (indexPath.section == 0) {
        SettingVersionCell   *cell0 = [self.tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        cell0.selectionStyle=UITableViewCellSelectionStyleNone;
        cell0.textLabel.text = _dataArray[indexPath.section];
        cell0.textLabel.text = title;
        cell0.textLabel.font = [UIFont systemFontOfSize:14];
        cell0.textLabel.textColor = kUIColorFromRGB(0x404040);
        cell0.showVersionLabel.font = [UIFont systemFontOfSize:14];
        cell0.showVersionLabel.textColor = kUIColorFromRGB(0x808080);
        cell0.showVersionLabel.hidden = NO;
        cell0.showVersionImageView.hidden = YES;
        
        CGFloat cacache = 1.0f*[JXFileManager getSizeOfDirectoryPath:JXCachePath]/(1024*1024);
        
        if (cacache>1) {
          cell0.showVersionLabel.text = [NSString stringWithFormat:@"%.2f M",cacache];
        }else{
            cell0.showVersionLabel.text = @"0 M";
        }
        
        
        
        return cell0;
    }

    if (indexPath.section == 2) {
     SettingVersionCell   *cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        cell1.textLabel.text = _dataArray[indexPath.section];
        cell1.textLabel.text = title;
        cell1.textLabel.font = [UIFont systemFontOfSize:14];
        cell1.textLabel.textColor = kUIColorFromRGB(0x404040);
        cell1.showVersionLabel.font = [UIFont systemFontOfSize:14];
        cell1.showVersionLabel.textColor = kUIColorFromRGB(0x808080);
        



        
        if ([ZQ_AppCache isShowVersionImage]) {
            cell1.showVersionImageView.hidden = NO;
            cell1.showVersionLabel.hidden = YES;
        }else{
            cell1.showVersionImageView.hidden = YES;
            cell1.showVersionLabel.hidden = NO;
            
                            NSString *versionStr = [NSString stringWithFormat:@"V%@", [ZQ_AppCache getSystemVersion]];
            
            cell1.showVersionLabel.text = versionStr;
        }

        return cell1;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [JXLocationTool isBD] ? _dataArray.count :_enterprise_dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.00000000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 190;
    }
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 190)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
        imageV.frame = ZQ_RECT_CREATE((ZQ_Device_Width - 80)/2, 35, 80, 80);
        [view addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(imageV.frame)+5, ZQ_Device_Width, 30)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = @"易推云";
        [view addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(label.frame), ZQ_Device_Width, 20)];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = kUIColorFromRGB(0x808080);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.backgroundColor = [UIColor clearColor];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        label1.text = [NSString stringWithFormat:@"V%@", [ZQ_AppCache getSystemVersion]];
        [view addSubview:label1];
        
        return view;
    }
    return nil;
}



//版 本 更 新
- (void)versionUpdate
{
    [ZQ_AppCache clearlocalVersion];
    [SVProgressHUD showWithStatus:@"加载中..."];
    MJWeakSelf
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"system";
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=data.config"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString * app_Version = infoDictionary[@"CFBundleShortVersionString"] ;
        NSString * server_Version = responseObject[@"ios_version"] ;
        NSString * app_force = responseObject[@"force"];
        
        if ( [NSString isNeedToUpdateServerVersion:server_Version andappVersion:app_Version] ) {
            
            
            
            [ZQ_AppCache saveVersion:server_Version];
            
            [weakSelf.tableView reloadData];
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        
    }];
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        
        CGFloat cacache = 1.0f*[JXFileManager getSizeOfDirectoryPath:JXCachePath]/(1024*1024);
        
        if (cacache>1) {
            [JXFileManager removeDirectoryPath:JXCachePath];
            [self clearCache];//清除缓存
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
      
       
    } else if (indexPath.section == 1) {
        AboutMyViewController *vc = [[AboutMyViewController alloc] initWithWhere:1];
        pushToControllerWithAnimated(vc)
    }else if (indexPath.section==2 && ([ZQ_AppCache isShowVersionImage])){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:App_url]];
        
    }else if(indexPath.section == 3){ // 易推云用户使用协议
        JXShowAgreementViewController *web = [[JXShowAgreementViewController alloc] init];
        web.navigationItem.title = @"用户使用协议";
        [self.navigationController pushViewController:web animated:true];
    }
    
    ///BD版专职用户协议
    if (indexPath.section == 4 && [JXLocationTool isBD]) {
        JXShowAgreementViewController *web = [[JXShowAgreementViewController alloc] init];
        web.style = JXShowAgreementFulltimeUser;
        web.navigationItem.title = @"平台服务协议";
        [self.navigationController pushViewController:web animated:true];
    }
}

#pragma mark-- 清除缓存
- (void)clearCache {
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    [[EMSDImageCache sharedImageCache] clearMemory];
    [[EMSDImageCache sharedImageCache] cleanDisk];
    [ZQ_AppCache clearCache];
    
    __weak SetViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"清除中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showHint:@"清除成功"];
    });
}

//退出登录
- (void)quitClick{
    [self showHudInView:self.view hint:@"退出中..."];
    
    [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
     
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    model.userID = @"0";
    model.identity = @"6";
    [ZQ_AppCache save:model];
    
    [USERDEFALUTS setInteger:0 forKey:@"pushMessageCount"];
    [USERDEFALUTS synchronize];
    
    //清除实名认证状态
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PersonCenterName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PersonCenterCarId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [self hideHud];
    }
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [ZQ_CallMethod refreshInterface];
    
    [ZQ_CallMethod againLogin];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
