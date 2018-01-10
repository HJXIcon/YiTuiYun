//
//  HomePageViewController.m
//  社区快线
//
//  Created by NIT on 15/10/21.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "HomePageViewController.h"
#import "ChooseCityViewController.h"
#import "SDCycleScrollView.h"
#import "ImageVo.h"
#import "ProjectModel.h"
#import "HomeListTableViewCell.h"
#import "CCLocationManager.h"
#import "HFNeighboursTitleButton.h"
#import "HFNeighboursTitleModel.h"
#import "ProjectDetailViewController.h"
#import "PushWebViewController.h"
#import "GoodsModel.h"
#import "GoodsDetailViewController.h"
#import "InformationDetailViewController.h"
#import "InformationModel.h"
#import "VersionUpNormalView.h"
#import "VersionUpdateForceView.h"
#import "HomeHeadView.h"
#import "HomeHeadSectionView.h"
#import "HomeTableViewCell.h"
#import "homeTableModel.h"
#import "HomeSearchProjectVcView.h"
#import "HomeMiddleLabelVc.h"
#import "HomeHeadCollectionView.h"
#import "FuJinZhiJianVc.h"
#import "CompanyNeedDesc.h"
#import "TaskHallEnterpriseDetailJianZhiVC.h"


@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,ChooseCityViewControllerDelegate,CLLocationManagerDelegate,HFNeighboursTitleButtonDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,VersionUpNormalViewDelegate,VersionUpdateForceViewDelegate,UIAlertViewDelegate,HomeHeadViewDelegate,UINavigationControllerDelegate,HomeHeadCollectionViewDelegate>
{
    CLLocationManager *_manager;
    NSInteger _index;
}
@property (nonatomic, strong) SDCycleScrollView *imagePlayerView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) HFNeighboursTitleButton *titleButton;
@property (nonatomic, strong) UIView *classListView;
@property (nonatomic, strong) NSMutableArray *imageURLs; //存放首页banner模型
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic,strong) VersionUpNormalView * normalView;
/**强制更新 */
@property(nonatomic,strong) VersionUpdateForceView * forceView;

/**地理编码*/
@property(nonatomic,strong) BMKGeoCodeSearch *searcher;
/**localServier */
@property(nonatomic,strong) BMKLocationService * localServer;

/**headView */
@property(nonatomic,strong) HomeHeadView * headView;
/**homeHeadCollection */
@property(nonatomic,strong) HomeHeadCollectionView * headCollectionView;
/**sectionHead */
@property(nonatomic,strong) HomeHeadSectionView * sectionView;

/**三个类型 */
@property(nonatomic,assign)NSInteger  sectionType;

/**单前页码 */
@property(nonatomic,assign)NSInteger  page;
@property(nonatomic,strong) UIImageView * nodataImageView;
@property(nonatomic,strong) SDCycleScrollView * bannerView;


@end

@implementation HomePageViewController

#pragma mark - lazy load
-(SDCycleScrollView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[SDCycleScrollView alloc]init];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.delegate = self;
        _bannerView.dotColor = [UIColor whiteColor];
        _bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        _bannerView.frame = self.headView.bounds;
    

    }
    return _bannerView;
}

-(UIImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        _nodataImageView = [[UIImageView alloc]init];
        _nodataImageView.image = [UIImage imageNamed:@""];
        
    }
    return _nodataImageView;
}

-(HomeHeadView *)headView{
    if (_headView == nil) {
        _headView = [HomeHeadView headView];
        _headView.frame = CGRectMake(0, 20, ScreenWidth, HRadio(150));
        
        _headView.delegate = self;

    }
    return _headView;
}

-(HomeHeadCollectionView *)headCollectionView{
    if (_headCollectionView == nil) {
        _headCollectionView = [HomeHeadCollectionView collectionView];
        _headCollectionView.delegate = self;
//        _headCollectionView.frame = CGRectMake(0, 0, ScreenWidth, HRadio(120));
    }
    return _headCollectionView;
   
}
-(HomeHeadSectionView *)sectionView{
    MJWeakSelf
    if (_sectionView == nil) {
        _sectionView = [HomeHeadSectionView sectionView];
        _sectionView.frame = CGRectMake(0, 0, ScreenWidth, HRadio(44));
        _sectionView.s_block = ^(NSInteger sectionindex) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.tableView reloadData];
            NSInteger sectionType = sectionindex - 10;
            weakSelf.sectionType = sectionType;
            weakSelf.page = 1;
//            [weakSelf dataArrayFromNetwor];
            
            /// 附近全职
            if (sectionType == 2) {
               
                [weakSelf getJianZhiData];
                
            }else{/// 今日推荐/绩效栏
                
                [weakSelf dataArrayFromNetwor];
            }
        };
    }
    return _sectionView;
    
    

    
}



-(VersionUpNormalView *)normalView{
    if (_normalView == nil) {
        _normalView = [VersionUpNormalView normalView];
        _normalView.frame =[UIScreen mainScreen].bounds;
        _normalView.delegate = self;
    }
    return _normalView;
}

-(VersionUpdateForceView *)forceView{
    if (_forceView == nil) {
        _forceView = [VersionUpdateForceView forceView];
        _forceView.frame = [UIScreen mainScreen].bounds;
        _forceView.delegate = self;
    }
    return _forceView;
}


-(BMKGeoCodeSearch *)searcher{
    if (_searcher == nil) {
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}
-(BMKLocationService *)localServer{
    if (_localServer == nil) {
        _localServer = [[BMKLocationService alloc]init];
        _localServer.delegate = self;
    }
    return _localServer;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        MJWeakSelf
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HRadio(150)+20, self.view.frame.size.width, self.view.frame.size.height-HRadio(150)-20) style:UITableViewStylePlain];
        [_tableView setDelegate:(id<UITableViewDelegate>) self];
        [_tableView setDataSource:(id<UITableViewDataSource>) self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headCollectionView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homecell"];
        
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
//            [weakSelf dataArrayFromNetwor];
            /// 附近全职
            if (weakSelf.sectionType == 2) {
                [weakSelf getJianZhiData];
                
            }else{/// 今日推荐/绩效栏
                [weakSelf dataArrayFromNetwor];
            }
        }];
    
        //上拉加载
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
//            [weakSelf dataArrayFromNetwor];
            /// 附近全职
            if (weakSelf.sectionType == 2) {
                [weakSelf getJianZhiData];
                
            }else{/// 今日推荐/绩效栏
                [weakSelf dataArrayFromNetwor];
            }
            
        }];
        
    }
    return _tableView;
}




#pragma mark - cycle life
- (instancetype)init{
    self = [super init];
    if (self) {
        self.imageURLs = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.nodataImageView];
   
    
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    
    

    
    //添加站位图片
    
    [self.nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(WRadio(55)));
        make.height.mas_equalTo(@(HRadio(65)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(HRadio(-160));
    }];
   
    //默认选择第一个按钮
    self.sectionType = 0;
    
    //默认选择第一页码
    self.page =1;
    
    self.isremo == YES;
    
    MJWeakSelf;
    self.headCollectionView.loadDataSucess = ^(NSInteger count) {
        if (count <= 4) {
            weakSelf.headCollectionView.frame = CGRectMake(0, 0, ScreenWidth, HRadio(120));
            
        }else{
            weakSelf.headCollectionView.frame = CGRectMake(0, 0, ScreenWidth, HRadio(180));
        }
        [weakSelf.tableView setTableHeaderView:weakSelf.headCollectionView];
    };
    [self.view addSubview:self.headView];

    [self setUpNavigation];
    //添加bannber图
    
    [self.view addSubview:self.tableView];
    [MobClick event:@"clickHomeNums"];
        
    [self versionUpdate];

    
    [self.tableView.mj_header beginRefreshing];
    
    self.navigationController.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *backgoud  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    backgoud.backgroundColor = UIColorFromRGBString(@"0xf16156");
    [self.view addSubview:backgoud];
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    
    /// 展示切换城市view
    [self showChangeCityView];

    
}



-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}


#pragma mark - load Data
/// 附近全职详情
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
            [self.navigationController pushViewController:VC animated:YES];
            
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
       
        
    }];
    
}

/// 附近全职数据
- (void)getJianZhiData{
   
    MJWeakSelf
    self.sectionView.userInteractionEnabled = NO;
    NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @10;
    parm[@"status"] = @6;
    if ([NSString stringIsEmpty:dic[@"provinceId"]] || [NSString stringIsEmpty:dic[@"cityId"]] ) {
        parm[@"province"] = @"2";
        parm[@"city"] = @"36";
    }else{
        parm[@"province"] = dic[@"provinceId"];
        parm[@"city"] = dic[@"cityId"];
    }
    
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [XKNetworkManager POSTToUrlString:JianZhiCompanyList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
      weakSelf.sectionView.userInteractionEnabled = YES;
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        [SVProgressHUD dismiss];
        if ([code isEqualToString:@"0"] ) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            /**********/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            
            /***********/
            [weakSelf.tableView reloadData];
            
            
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showHint:@"服务器数据出错"];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showHint:error.localizedDescription];
        weakSelf.sectionView.userInteractionEnabled = YES;

    }];
}


- (void)cityCode:(NSDictionary *)dic

{
    [SVProgressHUD showWithStatus:@"城市节点加载中..."];
    __weak HomePageViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"prov"] = dic[@"province"];
    params[@"city"] = dic[@"city"];
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.getCityID"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *subDic = responseObject[@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:subDic]) {
                NSDictionary *dicc = @{@"provinceId":[NSString stringWithFormat:@"%@", subDic[@"provid"]], @"cityId":[NSString stringWithFormat:@"%@", subDic[@"cityid"]],@"province":dic[@"province"],@"city":dic[@"city"]};
                [USERDEFALUTS setObject:dicc forKey:@"location"];
                [USERDEFALUTS synchronize];
                
                [weakSelf fromNetwork];
            }
        } else {
            
            [weakSelf leftBarButtonItemClick];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [weakSelf leftBarButtonItemClick];
        
        
    }];
}

- (void)imageURLsFromNetwork
{
    [SVProgressHUD showWithStatus:@"图片加载中..."];
    __weak HomePageViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = @"1";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=data.ad"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                [_imageURLs removeAllObjects];
                for (NSDictionary *subDic in listData) {
                    ImageVo *imageVo = [[ImageVo alloc] init];
                    imageVo.cover = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"imgurl"]];
                    if ([subDic[@"type"] integerValue] == 0) {
                        imageVo.link = [NSString stringWithFormat:@"%@api.php?m=h5&mid=7&id=%@&f=description", kHost, subDic[@"dataid"]];
                    } else if ([subDic[@"type"] integerValue] == 1) {
                        imageVo.link = [NSString stringWithFormat:@"%@", subDic[@"http"]];
                    }
                    imageVo.type = [NSString stringWithFormat:@"%@", subDic[@"type"]];
                    imageVo.dataid = [NSString stringWithFormat:@"%@",  subDic[@"dataid"]];
                    [_imageURLs addObject:imageVo];
                }
            }
            
            
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *imageArray = [NSMutableArray array];
                for (ImageVo *imageVo in _imageURLs) {
                    [imageArray addObject:imageVo.cover];
                }
                
                
                
                
                if (weakSelf.headView.picturepanView.subviews.count == 0) {
                    weakSelf.bannerView.imageURLsGroup = imageArray;
                    
                    
                    
                    [weakSelf.headView.picturepanView addSubview:weakSelf.bannerView];
                }
                
                
                
                
                
                
            });
            
//            [weakSelf dataArrayFromNetwor];
            /// 附近全职
            if (weakSelf.sectionType == 2) {
                [weakSelf getJianZhiData];
                
            }else{/// 今日推荐/绩效栏
                [weakSelf dataArrayFromNetwor];
            }
            
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"图片加载失败，请检查网络"];
        [SVProgressHUD dismiss];
        
    }];
}

/// 今日推荐/绩效栏
- (void)dataArrayFromNetwor{
    self.sectionView.userInteractionEnabled = NO;
    
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载..."];
    NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"t"] = @"1";
    params[@"status"] = @"6";
    
    if ([NSString stringIsEmpty:dic[@"provinceId"]] || [NSString stringIsEmpty:dic[@"cityId"]] ) {
        params[@"provid"] = @"2";
        params[@"cityid"] = @"36";
    }else{
        params[@"provid"] = dic[@"provinceId"];
        params[@"cityid"] = dic[@"cityId"];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString * app_Version = infoDictionary[@"CFBundleShortVersionString"] ;
    
    
    //    NSLog(@"--------%@-----",app_Version);
    
    //    params[@"provid"] = dic[@"provinceId"];
    //    params[@"cityid"] = dic[@"cityId"];
    params[@"version"] = app_Version;
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(10);
    params[@"extension_type"] = @(self.sectionType);
    params[@"from"] = @"ios";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        weakSelf.sectionView.userInteractionEnabled = YES;
        
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"errno"] integerValue] == 0) {
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            
            /******************/
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempdownArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                
                if (tempdownArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempdownArray];
                    
                }
                
                
            }
            
            /******************/
            
            if (self.dataArray.count == 0) {
                
                self.nodataImageView.image = [UIImage imageNamed:@"NodataTishi"];
                
            }else{
                
                self.nodataImageView.image = [UIImage imageNamed:@""];
            }
            
            
            [weakSelf.tableView reloadData];
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        self.page --;
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.sectionView.userInteractionEnabled = YES;
        
    }];
}

- (void)fromNetwork
{
    [self imageURLsFromNetwork];
}



//版 本 更 新
- (void)versionUpdate
{
    [ZQ_AppCache clearlocalVersion];
    
    __weak AppDelegate *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"system";
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=data.config"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        
        
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        if (![ZQ_CommonTool isEmpty:model.userID]) {
            model.rsprice = [NSString stringWithFormat:@"%@", responseObject[@"rsprice"]];
            model.gzprice = [NSString stringWithFormat:@"%@", responseObject[@"gzprice"]];
            [ZQ_AppCache save:model];
        } else {
            UserInfoModel *model1 = [[UserInfoModel alloc] init];
            model1.rsprice = [NSString stringWithFormat:@"%@", responseObject[@"rsprice"]];
            model1.gzprice = [NSString stringWithFormat:@"%@", responseObject[@"gzprice"]];
            [ZQ_AppCache save:model1];
        }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString * app_Version = infoDictionary[@"CFBundleShortVersionString"] ;
        NSString * server_Version = responseObject[@"ios_version"] ;
        NSString * app_force = responseObject[@"force"];
        
        
        
        if ( [NSString isNeedToUpdateServerVersion:server_Version andappVersion:app_Version] ) {
            
            
            
            [ZQ_AppCache saveVersion:server_Version];
            
            //判断是否强制
            if ([app_force isEqualToString:@"1"]) {
                
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.forceView];
                
                
                
            }else{
                //没有提示 //普通
                if ([ZQ_AppCache getVersionTiShi].length > 1) {
                    
                }else{
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:self.normalView];
                    
                }
                
            }
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

//普通更新
-(void)normalViewBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 80://取消
        {
            [self.normalView removeFromSuperview];
            self.normalView =nil;
            
        }
            break;
        case 81://更新
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:App_url]];
            [self.normalView removeFromSuperview];
            self.normalView =nil;
            
        }
            break;
            
            
        default:
            break;
    }
}
//强制更新
-(void)forceViewBtnClick{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:App_url]];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    if (self.bannerView) {
//        if (self.bannerView.timer) {
//
//        }else{
//            [self.bannerView setupTimer];
//        }
//    }
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//
//    if (self.bannerView) {
//        if (self.bannerView.timer) {
//            [self.bannerView.timer invalidate];
//            self.bannerView.timer = nil;
//            [self.bannerView  removeFromSuperview];
//
//        }
//    }
//
//}




#pragma mark - Private Method
#pragma mark 定位
- (void)setupLocation
{
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
#ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            
        }
#endif
        if ([CLLocationManager locationServicesEnabled]) {
            
        } else{
            
            
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alvertView show];
    }
    [self.localServer startUserLocationService];
    
    
}


/// 展示切换城市view
- (void)showChangeCityView{
    
    NSDictionary *dict = [USERDEFALUTS objectForKey:@"location"];
    NSString *city = dict[@"city"];
    
    if ([ZQ_CommonTool isEmptyDictionary:dict]) {
        return ;
    }
    
    MJWeakSelf;
    [[JXLocationTool shareInstance]getCurrentLocations:^(NSDictionary *dict) {
        
        NSString *locationCity = dict[@"city"];
        if (locationCity.length == 0 || [locationCity isEqualToString:city]) {
            
            return ;
            
        }else{
            
            NSString *desc = [NSString stringWithFormat:@"您目前定位的城市是%@，是否切换至该城市？",locationCity];
            LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示！" andDesc:desc WithCancelBlock:^(LHKAlterView *alterView) {
                [alterView removeFromSuperview];
                
            } WithMakeSure:^(LHKAlterView *alterView) {
                
                
                [weakSelf cityCode:dict];
                [weakSelf setStringToCityBtn:dict[@"city"]];
                [alterView removeFromSuperview];
                
            }];
            
            [alt.oneSureBtn setTitle:@"切换" forState:UIControlStateNormal];
            [[UIApplication sharedApplication].keyWindow addSubview:alt];
        }
        
    } error:^(BMKSearchErrorCode error) {
        
        
    }];
    
}

/// 设置城市btn
-(void)setStringToCityBtn:(NSString *)string{
    
    if (string.length>3) {
        string = [string substringToIndex:2];
        string = [NSString stringWithFormat:@"%@..",string];
    }
    [self.headView.citySlectBtn setTitle:string forState:UIControlStateNormal];
    [self.headView.citySlectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


-(void)defaultCitySelect{
    
    if (![XKNetworkManager networkStateChange]) {
        [self showHint:@"无网络"];
        return;
    }

     NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    
    if ([ZQ_CommonTool isEmptyDictionary:dic]) {
        NSDictionary  *location = @{@"cityId":@"36",@"provinceId":@"2",@"province":@"北京市",@"city":@"东城区"};
        [USERDEFALUTS setObject:location forKey:@"location"];
        [USERDEFALUTS synchronize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setStringToCityBtn:location[@"city"]];
            [self fromNetwork];
        });
        
      

    }
    
  
}
- (void)setUpNavigation{
    
    self.navigationItem.title = @"易推云";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
   
    NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    if (!dic) {
        if (![XKNetworkManager networkStateChange]) {
            [self showHint:@"无网络"];
            return;
        }
        
        [self setupLocation];
    } else {

        NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
        [self setStringToCityBtn:dic[@"city"]];
        [self fromNetwork];
        
    }
    
    }


/// 城市重新跳转
- (void)leftBarButtonItemClick
{
    ChooseCityViewController *vc = [[ChooseCityViewController alloc] initWithPositioningString:@"123" WithWhere:1];
    vc.delegate = self;
    [self presentViewController:[self addNavigationController:vc] animated:YES completion:nil];
}

/// 创建导航vc
- (UINavigationController *)addNavigationController:(UIViewController *)viewController
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    //修改所有导航栏控制器的title属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //修改所有导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xf16156)] forBarMetrics:UIBarMetricsDefault];
    
    return nav;
}
/// 根据颜色创建UIImage
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




#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *const ID = @"homecell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   
    
    /// 附近全职(日结栏)
    if (self.sectionType == 2) {
        cell.zhaopinPersonNumberLabel.hidden = NO;
        CompanyJianZhiModel *model = self.dataArray[indexPath.row];
        cell.fujinjianzhimodel = model;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
        cell.oneImageView.image = [UIImage imageNamed:@"tubiao_1"];
        cell.twoImageView.image = [UIImage imageNamed:@"tubiao_2"];
        cell.threeImageView.hidden = YES;
        cell.titlepanView.hidden = NO;
        
    }else{/// 今日推荐/绩效栏
        
        homeTableModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.zhaopinPersonNumberLabel.hidden = YES;
        //        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
        cell.threeImageView.hidden = NO;
        cell.titlepanView.hidden = NO;
        
    }
    
    
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HRadio(141);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /// 附近全职(日结栏)
    if (self.sectionType == 2) {
        UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
        
        if ([userInfoModel.userID isEqualToString:@"0"]) {
            [ZQ_CallMethod againLogin];
            return;
        }
        CompanyJianZhiModel *model = self.dataArray[indexPath.row];
        /// 附近全职详情
        [self zhaoPinSelect:model.jobid];
       
        
    }else{/// 今日推荐/绩效栏
        
        homeTableModel *projectModel = self.dataArray[indexPath.row];
        
        UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
        if ([userInfoModel.userID isEqualToString:@"0"]) {
            [ZQ_CallMethod againLogin];
        } else {
            ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:projectModel.demandid WithType:userInfoModel.identity WithWhere:1];
            pushToControllerWithAnimated(vc)
        }
    }
    
    
   
    
}


#pragma mark header/footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
        return HRadio(44);
    }
    return 0.00001;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.sectionView;
    }
    return [UIView new];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
//    if ([userInfoModel.userID isEqualToString:@"0"]) {
//        [ZQ_CallMethod againLogin];
//    } else {
        //0无跳转 1外链 2商品详情 3资讯详情
        ImageVo *imageVo = _imageURLs[index];
        if ([imageVo.type integerValue] == 0 || [imageVo.type integerValue] == 1){
            PushWebViewController *vc = [[PushWebViewController alloc] initWith:imageVo.link WithWhere:1];
            vc.title = imageVo.title;
            pushToControllerWithAnimated(vc)
//        } else if ([imageVo.type integerValue] == 1) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imageVo.link]];
        } else if ([imageVo.type integerValue] == 2) {
            GoodsModel *model = [[GoodsModel alloc] init];
            model.goodsId = imageVo.dataid;
            GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] initWithGoodsModel:model];
            pushToControllerWithAnimated(vc)
        } else if ([imageVo.type integerValue] == 3) {
            InformationModel *model = [[InformationModel alloc] init];
            model.InfoId = imageVo.dataid;
            InformationDetailViewController *vc = [[InformationDetailViewController alloc] initWithInformationModel:model];
            pushToControllerWithAnimated(vc)
        }
//    }
}




#pragma mark - ChooseCityViewControllerDelegate
- (void)seleCity:(NSDictionary *)dic {
    NSString *string = [NSString stringWithFormat:@"%@", dic[@"city"]];
    if (string.length>3) {
        string = [string substringToIndex:2];
        string = [NSString stringWithFormat:@"%@..",string];
    }
    
    [self setStringToCityBtn:string];
    [self imageURLsFromNetwork];
    
    
}


#pragma mark - <BMKLocationServiceDelegate>

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //发起反向地理编码检索
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint =userLocation.location.coordinate;
    
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
    }
    else
    {
        [self leftBarButtonItemClick];
    }
    
    [self.localServer stopUserLocationService];
    
}
#pragma mark--- 地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        [self  setStringToCityBtn: result.addressDetail.city];
    }
    else {
        
        
        [self leftBarButtonItemClick];
        
        
        
    }
    
    //        NSDictionary *dicc = @{@"latitude":@(result.location.latitude), @"longitude":@(result.location.longitude),@"dataid":@(100),@"province":result.addressDetail.province,@"city":result.addressDetail.city};
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"latitude"] = @(result.location.latitude);
    dicc[@"longitude"] = @(result.location.longitude);
    dicc[@"dataid"] = @(100);
    dicc[@"province"] = result.addressDetail.province;
    dicc[@"city"] = result.addressDetail.city;
    
    /// 判断直辖市
    if ([result.addressDetail.province isEqualToString:result.addressDetail.city]) {
        dicc[@"province"] = result.addressDetail.city;
        dicc[@"city"] = result.addressDetail.district;
    }
    
    
    
    [self cityCode:dicc];
    
}


#pragma mark - HomeHeadViewDelegate

-(void)headViewSoSouBtnClick:(UIButton *)btn{
    [self.navigationController pushViewController:[HomeSearchProjectVcView new] animated:YES];
}
-(void)headViewcityBtnClick:(UIButton *)btn{
    [self leftBarButtonItemClick];
}


#pragma mark - HomeHeadCollectionViewDelegate
-(void)collectionViewHeadClick:(NSDictionary *)dict{
    
    
//    if ([dict[@"linkageid"] isEqualToString:@"3415"]) {
//        //附近全职
//        
//        NSDictionary *addressDict = [USERDEFALUTS objectForKey:@"location"];
//        
//        
//        
//        FuJinZhiJianVc *fvc = [[FuJinZhiJianVc alloc]init];
//        fvc.province = addressDict[@"provinceId"];
//        fvc.city =  addressDict[@"cityId"];
//        fvc.navigationItem.title = @"附近全职";
//        
//        [self.navigationController pushViewController:fvc animated:YES];
//        
//        
//        
//    }else{
        HomeMiddleLabelVc *vc = [[HomeMiddleLabelVc alloc]init];
        vc.dict = dict;
        
        
        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    
    
}


#pragma mark - navgationdelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}





@end
