//
//  RecommendViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/10.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "RecommendViewController.h"
#import "InformationModel.h"
#import "GoodsModel.h"
#import "InformationCell.h"
#import "GoodsCell.h"
#import "RecommendCell.h"
#import "InformationListViewController.h"
#import "InformationDetailViewController.h"
#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "PushWebViewController.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate,GoodsDetailViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *informationDataArr;
@property (nonatomic, strong) NSMutableArray *goodsDataArr;
@property (nonatomic, strong) NSString *informationDesc;
@property (nonatomic, strong) NSString *goodsDesc;
@end

@implementation RecommendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.informationDataArr = [NSMutableArray array];
        self.goodsDataArr = [NSMutableArray array];
        self.informationDesc = @"这是热点资讯";
        self.goodsDesc = @"这是热门商品";
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
    [self setupRefresh];
    [self getNetworkData];
    [MobClick event:@"clickSquareNums"];

}

- (void)setupNav{
    self.title = @"云展中心";
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark - 添加刷新
- (void)setupRefresh {
    [_tableView setHeadRefreshWithTarget:self withAction:@selector(getNetworkData)];
}

- (void)getNetworkData
{
    [self getInformationData];
    [self getGoodsData];
    [_tableView endRefreshing];
}

#pragma mark 下拉刷新
- (void)getInformationData {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak RecommendViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"type"] = @"recommend";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.newsList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] integerValue] == 0) {
            [_informationDataArr removeAllObjects];
            NSArray *listData = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    InformationModel *model = [[InformationModel alloc] init];
                    model.icon = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"thumb"]];
                    model.title = [NSString stringWithFormat:@"%@", subDic[@"title"]];
                    model.desc = [NSString stringWithFormat:@"%@", subDic[@"description"]];
                    model.time = [NSString stringWithFormat:@"%@", subDic[@"inputtime"]];
                    model.InfoId = [NSString stringWithFormat:@"%@", subDic[@"newsId"]];
                    model.islink = [NSString stringWithFormat:@"%@", subDic[@"islink"]];
                    model.url = [NSString stringWithFormat:@"%@", subDic[@"url"]];
                    [_informationDataArr addObject:model];
                }
            }
            [_tableView reloadData];
            
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)getGoodsData
{
    __weak RecommendViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"type"] = @"recommend";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.goodsList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] integerValue] == 0) {
            [_goodsDataArr removeAllObjects];
            NSArray *listData = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    GoodsModel *model = [[GoodsModel alloc] init];
                    model.icon = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"thumb"]];
                    model.title = [NSString stringWithFormat:@"%@", subDic[@"title"]];
                    model.price = [NSString stringWithFormat:@"%@", subDic[@"price"]];
                    model.originalPrice = [NSString stringWithFormat:@"%@", subDic[@"oldPrice"]];
                    model.nums = [NSString stringWithFormat:@"%@", subDic[@"joinNum"]];
                    model.goodsId = [NSString stringWithFormat:@"%@", subDic[@"goodsId"]];
                    [_goodsDataArr addObject:model];
                }
            }
            [_tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _informationDataArr.count;
    } else if (section == 2) {
        return _goodsDataArr.count;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 45;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 45)];
        view.backgroundColor = kUIColorFromRGB(0xffffff);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ZQ_Device_Width - 24, 45)];
        if (section == 1) {
            label.text = @"精选资讯";
        } else if (section == 2) {
            label.text = @"猜你喜欢";
        }
        label.textColor = kUIColorFromRGB(0x000000);
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        InformationCell* cell = [InformationCell cellWithTableView:tableView];
        InformationModel *model = _informationDataArr[indexPath.row];
        cell.infoModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        GoodsCell* cell = [GoodsCell cellWithTableView:tableView];
        GoodsModel *model = _goodsDataArr[indexPath.row];
        cell.goodsModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.iconView.image = [UIImage imageNamed:@"hotInformation"];
        cell.nameLabel.text = @"热点资讯";
        cell.nameLabel.textColor = kUIColorFromRGB(0x404040);
        cell.descLabel.text = _informationDesc;
    } else if (indexPath.row == 1) {
        cell.iconView.image = [UIImage imageNamed:@"hotGoods"];
        cell.nameLabel.text = @"热门商品";
        cell.nameLabel.textColor = kUIColorFromRGB(0x404040);
        cell.descLabel.text = _goodsDesc;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            InformationListViewController *vc = [[InformationListViewController alloc] initWith:1];
            pushToControllerWithAnimated(vc)
        } else if (indexPath.row == 1) {
            GoodsListViewController *vc = [[GoodsListViewController alloc] initWith:1];
            pushToControllerWithAnimated(vc)
        }
    } else if (indexPath.section == 1) {
        UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
        if ([userInfoModel.userID isEqualToString:@"0"]) {
            [ZQ_CallMethod againLogin];
        } else {
            InformationModel *model = _informationDataArr[indexPath.row];
            if ([model.islink isEqualToString:@"0"]) {
                InformationDetailViewController *vc = [[InformationDetailViewController alloc] initWithInformationModel:model];
                pushToControllerWithAnimated(vc)
            } else {
                PushWebViewController *vc = [[PushWebViewController alloc] initWith:model.url WithWhere:1];
                vc.title = @"详情";
                pushToControllerWithAnimated(vc)
            }
        }
    } else if (indexPath.section == 2) {
        UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
        if ([userInfoModel.userID isEqualToString:@"0"]) {
            [ZQ_CallMethod againLogin];
        } else {
            GoodsModel *model = _goodsDataArr[indexPath.row];
            GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsModel:model];
            vc.indexPath = indexPath;
            vc.delegate = self;
            pushToControllerWithAnimated(vc)
        }
    }
}

- (void)bookingGoodsButtonClickWithIndex:(NSIndexPath *)indexPath WithNum:(NSString *)num
{
    GoodsModel *model = _goodsDataArr[indexPath.row];
    model.nums = num;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
