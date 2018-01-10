//
//  FXMyCollectController.m
//  yituiyun
//
//  Created by fx on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXMyCollectController.h"
#import "CustomTitleButton.h"
#import "ProjectModel.h"
#import "InformationModel.h"
#import "GoodsModel.h"
#import "HomeListTableViewCell.h"
#import "InformationCell.h"
#import "GoodsCell.h"
#import "ProjectDetailViewController.h"
#import "InformationDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "PushWebViewController.h"
#import "CompanyNeedListModel.h"
#import "HomeTableViewCell.h"
#import "TaskHallEnterpriseDetailJianZhiVC.h"
@interface FXMyCollectController ()<CustomTitleDelegate>

/** 按钮下滑动的线  */
@property (nonatomic,strong) UIView* BtnlineView;

/** 数据源  */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 主视图 */
@property (nonatomic,strong) UITableView* tableView;

/** 项目按钮 */
@property (nonatomic,strong) UIButton* projectBtn;
/** 文章按钮 */
@property (nonatomic,strong) UIButton* articleBtn;
/** 商品按钮 */
@property (nonatomic,strong) UIButton* goodsBtn;
/** 收藏按钮 */
@property (nonatomic,strong) UIButton *collectionBtn;


@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, assign) NSInteger select;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;

@end

@implementation FXMyCollectController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.isremo = YES;
    self.page = @"1";
    if (_select == 0) {
        [self getProjectData];
    } else if (_select == 1) {
        [self getArticleData];
    } else if (_select == 2) {
        [self getGoodsData];
    }else if (_select == 3){
        [self getCollectionData];
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    self.select = 0;
    
    [self.view addSubview:self.projectBtn];
    [self.view addSubview:self.articleBtn];
    [self.view addSubview:self.goodsBtn];
    [self.view addSubview:self.collectionBtn];
    [self.view addSubview:self.BtnlineView];
    
    
    [self setUpTableView];
    [self setupRefresh];
    
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"我的收藏";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView*)BtnlineView{
    if (!_BtnlineView) {
        _BtnlineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.projectBtn.frame), CGRectGetMaxY(self.projectBtn.frame), self.projectBtn.width, 2)];
        _BtnlineView.backgroundColor = kUIColorFromRGB(0xf16156);
    }
    return _BtnlineView;
}

/** 项目  */
- (UIButton*)projectBtn{
    if (!_projectBtn) {
        _projectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _projectBtn.frame = CGRectMake(0, 0, self.view.frame.size.width / 4, 44);
        _projectBtn.backgroundColor = [UIColor whiteColor];
        [_projectBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_projectBtn setTitle:[NSString stringWithFormat:@"项目"] forState:UIControlStateNormal];
        if (_select == 0) {
            [_projectBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_projectBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _projectBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_projectBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _projectBtn;
}

/** 文章  */
-(UIButton*)articleBtn{
    if (!_articleBtn) {
        _articleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _articleBtn.frame = CGRectMake(CGRectGetMaxX(self.projectBtn.frame), 0, self.view.frame.size.width / 4, 44);
        _articleBtn.backgroundColor = [UIColor whiteColor];
        [_articleBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_articleBtn setTitle:[NSString stringWithFormat:@"文章"] forState:UIControlStateNormal];
        if (_select == 1) {
            [_articleBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_articleBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _articleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_articleBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _articleBtn;
}

/** 商品  */
-(UIButton*)goodsBtn{
    if (!_goodsBtn) {
        _goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodsBtn.frame = CGRectMake(CGRectGetMaxX(self.articleBtn.frame), 0, self.view.frame.size.width / 4, 44);
        _goodsBtn.backgroundColor = [UIColor whiteColor];
        [_goodsBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_goodsBtn setTitle:[NSString stringWithFormat:@"商品"] forState:UIControlStateNormal];
        if (_select == 2) {
            [_goodsBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_goodsBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _goodsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_goodsBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _goodsBtn;
}




/** 招聘收藏  */
-(UIButton*)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(CGRectGetMaxX(self.goodsBtn.frame), 0, self.view.frame.size.width / 4, 44);
        _collectionBtn.backgroundColor = [UIColor whiteColor];
        [_collectionBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_collectionBtn setTitle:[NSString stringWithFormat:@"招聘"] forState:UIControlStateNormal];
        if (_select == 3) {
            [_collectionBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_collectionBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_collectionBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectionBtn;
}


- (void)getProjectData
{
    __weak FXMyCollectController *weakSelf = self;
    [self showHudInView:self.navigationController.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"collect"] = @"1";
    params[@"page"] = _page;
    params[@"pagesize"] = @"10";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    ProjectModel *model = [[ProjectModel alloc] init];
                    model.projectId = [NSString stringWithFormat:@"%@", subDic[@"demandid"]];
                    model.projectName = [NSString stringWithFormat:@"%@", subDic[@"projectName"]];
                    model.projectImage = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"thumb"]];
                    model.tagArray = [NSMutableArray array];
                    [model.tagArray addObjectsFromArray:subDic[@"tags"]];
                    model.projectTime = [NSString stringWithFormat:@"%@", subDic[@"timeTypeStr"]];
                    model.isNew = @"0";
                    model.timeType = [NSString stringWithFormat:@"%@", subDic[@"timeType"]];
                    model.projectPrice = [NSString stringWithFormat:@"%@", subDic[@"wn"]];
                    [listDataArray addObject:model];
                }
            }
            [weakSelf configuration:listDataArray];
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        [weakSelf hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

- (void)getArticleData
{
    __weak FXMyCollectController *weakSelf = self;
    [self showHudInView:self.navigationController.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @"10";
    params[@"page"] = _page;
    params[@"uid"] = model.userID;
    params[@"type"] = @"collect";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.newsList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
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
                    [listDataArray addObject:model];
                }
            }
            [weakSelf configuration:listDataArray];
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        [weakSelf hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

- (void)getGoodsData
{
    __weak FXMyCollectController *weakSelf = self;
    [self showHudInView:self.navigationController.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @"10";
    params[@"page"] = _page;
    params[@"uid"] = model.userID;
    params[@"type"] = @"collect";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.goodsList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    GoodsModel *model = [[GoodsModel alloc] init];
                    model.icon = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"thumb"]];
                    model.title = [NSString stringWithFormat:@"%@", subDic[@"title"]];
                    model.price = [NSString stringWithFormat:@"%@", subDic[@"price"]];
                    model.originalPrice = [NSString stringWithFormat:@"%@", subDic[@"oldPrice"]];
                    model.nums = [NSString stringWithFormat:@"%@", subDic[@"joinNum"]];
                    model.goodsId = [NSString stringWithFormat:@"%@", subDic[@"goodsId"]];
                    [listDataArray addObject:model];
                }
            }
            [weakSelf configuration:listDataArray];
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        [weakSelf hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}


-(void)getCollectionData{
    
    
    
    __weak FXMyCollectController *weakSelf = self;
    [self showHudInView:self.navigationController.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @"10";
    params[@"page"] = _page;
    params[@"memberid"] = model.userID;
    params[@"collect"] = @(1);
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.jobList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            
            
            listDataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:listData];
            
            
            [weakSelf configuration:listDataArray];
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        [weakSelf hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];

    
    
    
}
- (void)configuration:(NSArray *)array
{
    
    if (_isremo == YES) {
        if ([_dataArray count] != 0) {
            [_dataArray removeAllObjects];
        }
    }
    if (![ZQ_CommonTool isEmptyArray:array]) {
        [_dataArray addObjectsFromArray:array];
    }
    if (_dataArray.count == 0) {
        self.tableView.tableHeaderView = self.thereLabel;
        NSString *string = nil;
        if (_select == 0) {
            string = @"您还没有收藏任何项目";
        } else if (_select == 1) {
            string = @"您还没有收藏任何文章";
        } else if (_select == 2) {
            string = @"您还没有收藏任何商品";
        }
        _thereLabel.text = string;
    } else {
        self.tableView.tableHeaderView = self.thereLabel1;
    }
    
    
    [self.tableView reloadData];
}

- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}

- (UILabel *)thereLabel1
{
    if (!_thereLabel1) {
        _thereLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.0000001)];
    }
    return _thereLabel1;
}


-(void)setUpTableView{
    //初始化 tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height - 64 - 46) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
     [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homecell"];
    [self.view addSubview:_tableView];
}

#pragma mark - 添加刷新
- (void)setupRefresh{
    [_tableView setHeadRefreshWithTarget:self withAction:@selector(loadNewStatus)];
    [_tableView setFootRefreshWithTarget:self withAction:@selector(loadMoreStatus)];
}

#pragma mark 下拉刷新
- (void)loadNewStatus
{
    self.isremo = YES;
    self.page = @"1";
    [_tableView endRefreshing];
    if (_select == 0) {
        [self getProjectData];
    } else if (_select == 1) {
        [self getArticleData];
    } else if (_select == 2) {
        [self getGoodsData];
    }else if (_select == 3){
        [self getCollectionData];
    }
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    if (_select == 0) {
        [self getProjectData];
    } else if (_select == 1) {
        [self getArticleData];
    } else if (_select == 2) {
        [self getGoodsData];
    }else if (_select == 3){
        [self getCollectionData];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_select == 0) {
        static NSString *ID = @"HomeListTableViewCell";
        HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[HomeListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        ProjectModel *projectModel = _dataArray[indexPath.section];
        cell.model = projectModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (_select == 1) {
        InformationCell *cell = [InformationCell cellWithTableView:tableView];
        InformationModel *model = _dataArray[indexPath.section];
        cell.infoModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (_select == 2){
        GoodsCell* cell = [GoodsCell cellWithTableView:tableView];
        GoodsModel *model = _dataArray[indexPath.section];
        cell.goodsModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    static NSString *ID = @"homecell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    CompanyJianZhiModel *model = self.dataArray[indexPath.section];
    
    cell.fujinjianzhimodel = model;
    cell.titlepanView.hidden = YES;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    cell.oneImageView.image = [UIImage imageNamed:@"tubiao_1"];
    cell.twoImageView.image = [UIImage imageNamed:@"tubiao_2"];
    cell.threeImageView.hidden = YES;
    
    return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_select == 0) {
        ProjectModel *model = _dataArray[indexPath.section];
        UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
        ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:model.projectId WithType:userInfoModel.identity WithWhere:1];
        pushToControllerWithAnimated(vc)
    } else if (_select == 1) {
        InformationModel *model = _dataArray[indexPath.section];
        if ([model.islink isEqualToString:@"0"]) {
            InformationDetailViewController *vc = [[InformationDetailViewController alloc] initWithInformationModel:model];
            pushToControllerWithAnimated(vc)
        } else {
            PushWebViewController *vc = [[PushWebViewController alloc] initWith:model.url WithWhere:1];
            vc.title = @"详情";
            pushToControllerWithAnimated(vc)
        }
    } else if (_select == 2) {
        GoodsModel *model = _dataArray[indexPath.section];
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsModel:model];
        pushToControllerWithAnimated(vc)
    }else if (_select == 3){
        CompanyJianZhiModel *model = self.dataArray[indexPath.section];
        
        [self zhaoPinSelect:model.jobid];

    }
    [self.view endEditing:YES];
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
            VC.title =model.title;
            VC.detailModel = model;
            [self.navigationController pushViewController:VC animated:YES];
            
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
}





- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _dataArray.count - 1) {
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.0000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_select == 3) {
      return   HRadio(141);
    }
    if (_select == 0) {
        return 90;
    }
    return 110;
}

-(void)titleButtonClick:(UIButton*)button{
    self.isremo = YES;
    self.page = @"1";
    
    [UIView animateWithDuration:0.3 animations:^{
        self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(button.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
    }];
    [self.projectBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [self.articleBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [self.goodsBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    
    [button setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    if (button == self.projectBtn) {
        _select = 0;
        [self getProjectData];
    }else if (button == self.articleBtn){
        _select = 1;
        [self getArticleData];
    }else if (button == self.goodsBtn){
        _select = 2;
        [self getGoodsData];
    }else if (button == self.collectionBtn){
        _select = 3;
        [self getCollectionData];
    }
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
