//
//  ProjectDetailViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "FirstProjectOrTaskDetailCell.h"
#import "SecondProjectOrTaskDetailCell.h"
#import "ProjectModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import "CancelTaskViewController.h"
#import "TaskNodeModel.h"
#import "TaskNodeCell.h"
#import "SignInViewController.h"
#import "UploadViewController.h"
#import "UploadDetailViewController.h"
#import "CCLocationManager.h"
#import "FXLongitudeLatitudeModel.h"
#import "FXPersonDetailController.h"
#import "FXMapDetailController.h"
#import "ChatViewController.h"
#import "ProjectDetailDescCell.h"
#import "TaskDetailNavView.h"
#import "NodeListViewController.h"
#import "TaskDetailSectionHeadView.h"
#import "CompanyPublishTwofortw0Cell.h"
#import "LHKNearSellerViewController.h"
#import "ShowImageViewController.h"
#import "LHKMapAnoModel.h"
#import "PdfTableCell.h"
#import "UIViewController+PhotoBrowser.h"

#define kButtonTag 30000

@interface TaskDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TaskNodeCellDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,FirstProjectOrTaskDetailCellDelegate,CompanyPublishTwofortw0CellDelegate>

{
    CLLocationManager *_manager;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) FirstProjectOrTaskDetailCell *firstDetailCell;
@property (nonatomic, strong) SecondProjectOrTaskDetailCell *secondDetailCell;
@property (nonatomic, copy) NSString *dataId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NSMutableDictionary *locationDic;
@property (nonatomic, copy) NSString *myLon;
@property (nonatomic, copy) NSString *myLat;
/**mapView */
@property(nonatomic,strong) BMKMapView * mapView;
/**当前的coor */
@property(nonatomic,assign) CLLocationCoordinate2D coor;
/**navTitleView */
@property(nonatomic,strong) TaskDetailNavView * navView;
/**节点列表 */
@property(nonatomic,strong) NodeListViewController * nodeListVC;
/**sectionOneView */
@property(nonatomic,strong) TaskDetailSectionHeadView * sectionHeadView;
/**签到按钮 */
@property(nonatomic,strong) UIButton  * qiandaobtn;
@property(nonatomic,strong) NSMutableArray * stepArrays;
@property(nonatomic,assign)BOOL  isNavSecond;

@property(nonatomic,strong) BMKLocationService * localserver;

@property(nonatomic,strong) NSMutableArray * datas;


@end

@implementation TaskDetailViewController

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
-(BMKLocationService *)localserver{
    if (_localserver == nil) {
        _localserver = [[BMKLocationService alloc]init];
        _localserver.distanceFilter =kCLLocationAccuracyHundredMeters;
        _localserver.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        
        _localserver.delegate = self;
        
    }
    
    
    return _localserver;
}

-(NSMutableArray *)stepArrays{
    if (_stepArrays == nil) {
        _stepArrays = [NSMutableArray array];
    }
    return _stepArrays;
}
-(UIButton *)qiandaobtn{
    if (_qiandaobtn == nil) {
        _qiandaobtn = [[UIButton alloc]init];
        [_qiandaobtn setTitle:@"任务签到" forState:UIControlStateNormal];
        _qiandaobtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _qiandaobtn.backgroundColor = UIColorFromRGBString(@"f16156");
        [_qiandaobtn addTarget:self action:@selector(newCheckIn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qiandaobtn;
}


#pragma mark - 页面跳转


-(void)newCheckIn{
    MJWeakSelf
    SignInViewController *vc = [[SignInViewController alloc] initWithProjectModel:_model];
   
    //进行回调处理
    vc.tiaoBlock = ^{
                
        if (weakSelf.isNavSecond == NO) {
   
            [weakSelf.navView TaskDetailNav:weakSelf.navView.twoBtn];
            
            weakSelf.isNavSecond = YES;

        }
        
    };
    pushToControllerWithAnimated(vc)
}
-(TaskDetailSectionHeadView *)sectionHeadView{
    if (_sectionHeadView == nil) {
        _sectionHeadView = [TaskDetailSectionHeadView sectionHeadView];
        _sectionHeadView.frame = CGRectMake(0,0, ScreenWidth,195);
    }
    return _sectionHeadView;
}

-(NodeListViewController *)nodeListVC{
    if (_nodeListVC == nil) {
        _nodeListVC =[[NodeListViewController alloc] initWith:1 WithProjectModel:_model];
    }
    return _nodeListVC;
}
-(TaskDetailNavView *)navView{
    if (_navView == nil) {
        MJWeakSelf
        _navView = [TaskDetailNavView navView];
        _navView.frame = CGRectMake(0, 0, 189, 44);
        _navView.nav_block = ^(NSInteger index) {
      
            /***************处理segemetn选项卡*/
            if (index == 0) { //任务详情
                [weakSelf dataArrayFromNetwork];
                [weakSelf.nodeListVC removeFromParentViewController];
                [weakSelf.nodeListVC.view removeFromSuperview];
                
                weakSelf.isNavSecond = NO;
            }else{//任务节点
                [weakSelf addChildViewController:self.nodeListVC];
                [weakSelf.view addSubview:self.nodeListVC.view];
                weakSelf.isNavSecond = YES;
            }
       /*******************************/
        
        };
    }
    return _navView;
}
-(BMKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 250)];
        _mapView.delegate = self;
        [_mapView setZoomLevel:16];//设置缩放比
        _mapView.showMapScaleBar = YES;

    }
    return _mapView;
}

- (instancetype)initWithDataId:(NSString *)dataId WithType:(NSString *)type WithWhere:(NSInteger)where
{
    self = [super init];
    if (self) {
        self.type = type;
        self.where = where;
        self.dataId = dataId;
        self.dataArray = [NSMutableArray array];
        self.pointArray = [NSMutableArray array];
        self.locationDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self nodeListDataArray];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dataArrayFromNetwork
{
    __weak TaskDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _dataId;
    params[@"uid"] = infoModel.userID;
    params[@"uModelid"] = infoModel.identity;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskDetail"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *subDic = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:subDic]) {
                
                
                [weakSelf.stepArrays removeAllObjects];
                if (![ZQ_CommonTool isEmptyArray:subDic[@"execute_step"]]) {
                    for (NSDictionary *dict in subDic[@"execute_step"] ) {
                        UploadImageModel *model = [[UploadImageModel alloc]init];
                        model.imageArray = [NSMutableArray array];
                        model.taskField = dict[@"text"];
                        for (NSDictionary *imgdict in dict[@"img"] ) {
                            [model.imageArray addObject:imgdict[@"url"]];
                        }
                        
                        [weakSelf.stepArrays addObject:model];
                    }
                }
                
                
                //判断pdf
                NSString *pdfstr = responseObject[@"rst"][@"enclosure"];
                
                if ([ZQ_CommonTool isEmpty:pdfstr]) {
                    _model.pdfStr = @"";
                }else{
                    _model.pdfStr = [NSString imagePathAddPrefix:pdfstr];
                }
                
                
                NSString *pdfname = responseObject[@"rst"][@"enclosure_name"];
                
                if ([ZQ_CommonTool isEmpty:pdfname]) {
                    _model.pdfName = @"";
                }else{
                    _model.pdfName = pdfname;
                }
                


                /************/
                //lhkd第二次新增
                //名称
                weakSelf.sectionHeadView.titleNameLabel.text = [NSString stringWithFormat:@"%@",subDic[@"projectName"]];
                //价格
                weakSelf.sectionHeadView.priceLabel.text = [NSString stringWithFormat:@"%@",subDic[@"wn"]];
                //判断tags
                NSArray *tagsArrayNew = subDic[@"tags"];
                if (tagsArrayNew.count == 0) {
                    
                    weakSelf.sectionHeadView.fenjieLabel.hidden = YES;
                    weakSelf.sectionHeadView.tagsSubLabel.hidden = YES;
                    weakSelf.sectionHeadView.timeLabel.hidden = YES;
                    weakSelf.sectionHeadView.tagsLabel.text = [NSString stringWithFormat:@"截止%@",subDic[@"endDate"]];
                    
                }else{
                    weakSelf.sectionHeadView.fenjieLabel.hidden = NO;
                    weakSelf.sectionHeadView.timeLabel.hidden = NO;
                                        
                    if (tagsArrayNew.count == 1) {
                        weakSelf.sectionHeadView.tagsLabel.text = tagsArrayNew[0];
                        weakSelf.sectionHeadView.timeLabel.text =[NSString stringWithFormat:@"截止%@",subDic[@"endDate"]];
                        weakSelf.sectionHeadView.tagsSubLabel.hidden = YES;
                    }else{
                        
                        NSMutableString *tempstring = [NSMutableString string];
                        weakSelf.sectionHeadView.tagsLabel.text = tagsArrayNew[0];

                        for (int i = 1; i<tagsArrayNew.count; i++) {
                            NSString *temptt = [NSString stringWithFormat:@"%@ ",tagsArrayNew[i]];
                            [tempstring appendString:temptt];
                        }
                        
                        weakSelf.sectionHeadView.tagsSubLabel.text = tempstring;
                        weakSelf.sectionHeadView.timeLabel.text =[NSString stringWithFormat:@"截止%@",subDic[@"endDate"]];
                        
                    }
                    
                    
                  
                    
                }
                
                //剩余单量
                weakSelf.sectionHeadView.shengyuLabel.text = [NSString stringWithFormat:@"%@",subDic[@"surplus_single"]];
                
                //接单量
                weakSelf.sectionHeadView.jiedanLabel.text = [NSString stringWithFormat:@"%@",subDic[@"count"]];
                
                //成单量
                weakSelf.sectionHeadView.chengdanLabel.text = [NSString stringWithFormat:@"%@",subDic[@"complete_count"]];
                

                /************/
                
                
                
                _model.projectId = [NSString stringWithFormat:@"%@", subDic[@"demandid"]];
                _model.memberid = [NSString stringWithFormat:@"%@", subDic[@"memberid"]];
                _model.projectName = [NSString stringWithFormat:@"%@", subDic[@"projectName"]];
                _model.projectDesc = [NSString stringWithFormat:@"%@", subDic[@"desc"]];
                _model.projectTime = [NSString stringWithFormat:@"%@", subDic[@"timeTypeStr"]];
                _model.projectPrice = [NSString stringWithFormat:@"%@", subDic[@"wn"]];
                _model.isCollection = [NSString stringWithFormat:@"%@", subDic[@"isCollect"]];
                _model.projectPhone = [NSString stringWithFormat:@"%@", subDic[@"mobile"]];
                _model.isget = [NSString stringWithFormat:@"%@", subDic[@"isget"]];
                _model.timeType = [NSString stringWithFormat:@"%@", subDic[@"timeType"]];
                _model.single = [NSString stringWithFormat:@"%@", subDic[@"okNum"]];
                _model.number = [NSString stringWithFormat:@"%@", subDic[@"getNum"]];
                _model.promotion = [NSString stringWithFormat:@"%@", subDic[@"num"]];
                _model.payType = [NSString stringWithFormat:@"%@", subDic[@"payType"]];
                _model.groupId = [NSString stringWithFormat:@"%@", subDic[@"group_id"]];
                _model.taskType = [NSString stringWithFormat:@"%@", subDic[@"t"]];
                _model.groupManager = [NSString stringWithFormat:@"%@", subDic[@"guestsid"]];
                _model.doingName = [NSString stringWithFormat:@"%@", subDic[@"doingName"]];
                _model.doingDemandid = [NSString stringWithFormat:@"%@", subDic[@"doingDemandid"]];
                /**************/
                //lhk新增
                _model.projectDesc = [[NSString stringWithFormat:@"%@", subDic[@"desc"]] stringIsNull];
                _model.projectTarget_clients = [[NSString stringWithFormat:@"%@", subDic[@"taget_clients"]] stringIsNull];
                
                _model.project_advantage = [[NSString stringWithFormat:@"%@", subDic[@"project_advantage"]] stringIsNull];
                
                _model.project_materials_needed = [[NSString stringWithFormat:@"%@", subDic[@"materials_needed"]] stringIsNull];
                
                _model.project_explain = [[NSString stringWithFormat:@"%@", subDic[@"explain"]] stringIsNull];
                _model.Cityarray = subDic[@"citysArr"];
                /**************/
                _model.isAdress = @"1";
                _model.type = _type;
                _model.adressArray = [NSMutableArray array];
                [_model.adressArray addObjectsFromArray:subDic[@"citysArr"]];
                _model.tagArray = [NSMutableArray array];
                [_model.tagArray addObjectsFromArray:subDic[@"tags"]];
                _model.positionArray = [NSMutableArray array];
                [_model.positionArray addObjectsFromArray:subDic[@"setting"]];
                _model.textArray = [NSMutableArray array];
                [_model.textArray addObjectsFromArray:subDic[@"text"]];
                _model.imgsArray = [NSMutableArray array];
                [_model.imgsArray addObjectsFromArray:subDic[@"imgs"]];
                _model.personnelArray = [NSMutableArray array];
                
                NSInteger ageMin = [subDic[@"ifs"][@"ageMin"] integerValue];
                NSInteger ageMax = [subDic[@"ifs"][@"ageMax"] integerValue];
                NSInteger heightMin = [subDic[@"ifs"][@"heightMin"] integerValue];
                NSInteger heightMax = [subDic[@"ifs"][@"heightMax"] integerValue];
                NSInteger sex = [subDic[@"ifs"][@"sex"] integerValue];
                NSString *role = [NSString stringWithFormat:@"%@", subDic[@"ifs"][@"jobType"]];
                
                if ([role isEqualToString:@"0"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"身份不限",@"t":@"1"}];
                } else if ([role isEqualToString:@"1"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"全职",@"t":@"1"}];
                } else if ([role isEqualToString:@"2"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"3"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"校园兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"1,2"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"全职/兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"1,3"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"全职/校园兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"2,3"]) {
                    [_model.personnelArray addObject:@{@"name_zh":@"兼职/校园兼职",@"t":@"1"}];
                }
                
                if (heightMin == 0 && heightMax == 999) {
                    [_model.personnelArray addObject:@{@"name_zh":@"身高不限",@"t":@"1"}];
                } else {
                    NSString *name = [NSString stringWithFormat:@"身高:%zd-%zdcm", heightMin, heightMax];
                    [_model.personnelArray addObject:@{@"name_zh":name,@"t":@"1"}];
                }
                
                if (sex == 0) {
                    [_model.personnelArray addObject:@{@"name_zh":@"性别不限",@"t":@"1"}];
                } else if (sex == 1) {
                    [_model.personnelArray addObject:@{@"name_zh":@"男",@"t":@"1"}];
                } else if (sex == 2) {
                    [_model.personnelArray addObject:@{@"name_zh":@"女",@"t":@"1"}];
                }
                
                if (ageMin == 0 && ageMax == 999) {
                    [_model.personnelArray addObject:@{@"name_zh":@"年龄不限",@"t":@"1"}];
                } else {
                    NSString *name = [NSString stringWithFormat:@"年龄:%zd-%zd岁", ageMin, ageMax];
                    [_model.personnelArray addObject:@{@"name_zh":name,@"t":@"1"}];
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

- (void)nodeListDataArray
{
    __weak TaskDetailViewController *weakSelf = self;
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _dataId;
    params[@"memberid"] = infoModel.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.node"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            [_dataArray removeAllObjects];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    
                    TaskNodeModel *model = [[TaskNodeModel alloc] init];
                    model.taskId = _dataId;
                    model.taskName = [NSString stringWithFormat:@"%@", _model.projectName];
                    model.nodeName = [NSString stringWithFormat:@"%@", subDic[@"address"]];
                    model.nodeId = [NSString stringWithFormat:@"%@", subDic[@"nodeid"]];
                    model.nodeState = [NSString stringWithFormat:@"%@", subDic[@"status"]];
                    model.state = _type;
                    model.signInAddress = [NSString stringWithFormat:@"%@", subDic[@"address"]];
                    [_dataArray addObject:model];
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

#pragma mark - 定位
- (void)setupLocation
{
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
//        _manager = [[CLLocationManager alloc] init];
//        _manager.delegate = self;
//        _manager.desiredAccuracy = kCLLocationAccuracyBest;
//        _manager.distanceFilter = 100;
#ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_manager requestWhenInUseAuthorization];
            
        }
#endif
        if ([CLLocationManager locationServicesEnabled]) {
//            [_manager startUpdatingLocation];
            [self.localserver startUserLocationService];

        } else{
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.myLat = [NSString stringWithFormat:@"%lf", userLocation.location.coordinate.latitude];
    self.myLon = [NSString stringWithFormat:@"%lf", userLocation.location.coordinate.longitude];
    
    NSDictionary *dic = @{@"x":self.myLon,@"y":self.myLat};
    
    [self getValueForContentViewFromDict:dic];
    
    [self.localserver stopUserLocationService];
    
    
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    BMKPointAnnotation* myAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D myCoor;
    myCoor.latitude = [self.myLat doubleValue];
    myCoor.longitude = [self.myLon doubleValue];
    myAnnotation.coordinate = myCoor;
    myAnnotation.title = @"我的位置";
    _mapView.centerCoordinate = myCoor;//设置此位置为中心点
    [_mapView addAnnotation:myAnnotation];
    
    
    if (self.datas.count == 0) {
        //faqingqiu
        
        /****************************************************/
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"lng"] =self.myLon;
        dict[@"lat"] = self.myLat;
        dict[@"t"] = @(2);
        
        MJWeakSelf
        
        [XKNetworkManager POSTToUrlString:GetNearySellerURL parameters:dict progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            
            
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"errno"]];
            if ([code isEqualToString:@"0"]) {
                /************/
                weakSelf.datas = [LHKMapAnoModel objectArrayWithKeyValuesArray:dict[@"rst"]];
                
                
                
                
                [weakSelf.datas enumerateObjectsUsingBlock:^(LHKMapAnoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    BMKPointAnnotation* myAnnotation = [[BMKPointAnnotation alloc]init];
                    CLLocationCoordinate2D myCoor;
                    myCoor.latitude =obj.lat;
                    myCoor.longitude = obj.lng;
                    myAnnotation.coordinate = myCoor;
                    myAnnotation.title = obj.nickname;
                    
                    [self.mapView addAnnotation:myAnnotation];
                    
                    
                }];
                
                
                /************/
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismiss];
        }];
        
        
        /*****************************************************/
    }else{
        /******************************************/
        [self.datas enumerateObjectsUsingBlock:^(LHKMapAnoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            BMKPointAnnotation* myAnnotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D myCoor;
            myCoor.latitude =obj.lat;
            myCoor.longitude = obj.lng;
            myAnnotation.coordinate = myCoor;
            myAnnotation.title = obj.nickname;
            
            [self.mapView addAnnotation:myAnnotation];
            
            
        }];
        
        /****************************************/
    }
    

}

//定位城市
- (void)getValueForContentViewFromDict:(NSDictionary *)dic
{
    [_locationDic removeAllObjects];
    _locationDic[@"latitude"] = dic[@"y"];
    _locationDic[@"longitude"] = dic[@"x"];
    
    [self GetPointArrayData:_locationDic];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
}

-(void)stopLocation
{
    _manager = nil;
}

- (void)GetPointArrayData:(NSDictionary *)dic
{
    __weak TaskDetailViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _dataId;
    params[@"lat"] = [NSString stringWithFormat:@"%@", dic[@"latitude"]];
    params[@"lng"] = [NSString stringWithFormat:@"%@", dic[@"longitude"]];
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.nearbdMap"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *array = responseObject[@"rst"];
            if (![ZQ_CommonTool isEmptyArray:array]) {
                for (NSDictionary *subDic in array) {
                    FXLongitudeLatitudeModel *model = [[FXLongitudeLatitudeModel alloc] init];
                    model.pointId = [NSString stringWithFormat:@"%@", subDic[@"uid"]];
                    model.titleStr = [NSString stringWithFormat:@"%@", subDic[@"nickname"]];
                    model.latitudeStr = [NSString stringWithFormat:@"%@", subDic[@"lat"]];
                    model.longitudeStr = [NSString stringWithFormat:@"%@", subDic[@"lng"]];
                    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
                    if ([subDic[@"uid"] integerValue] != [infoModel.userID integerValue]) {
                        [_pointArray addObject:model];
                    }
                }
                [_tableView reloadData];
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)viewDidLoad {
    
        [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isNavSecond = NO;
    
    [self setUpNavigation];
    [self setupTableView];
    //设置footView
    [self setFooterView];
    self.model = [[ProjectModel alloc] init];
    [self dataArrayFromNetwork];
    [self setupLocation];
}

#pragma mark - setUpNavigation
- (void)setUpNavigation{
    
//    self.title = @"任务详情";
    
    self.navigationItem.titleView = self.navView;
    
    
    
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:UIColorFromRGBString(@"0xf16156")]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    if ([_type isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"delete_icon" selectedImage:@"delete_icon" target:self action:@selector(rightBarButtonItemClick)];
    }
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


- (void)leftBarButtonItem{
    if (_where == 1 || _where == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemClick
{
    NSString *string = nil;
    if ([_model.taskType integerValue] != 2) {
        string = @"若取消此任务，想要再次领取此任务需要等待24小时，确认取消任务？";
    } else {
        string = @"是否确认取消任务？";
    }
    [WCAlertView showAlertWithTitle:@"提示"
                            message:string
                 customizationBlock:^(WCAlertView *alertView) {
                     
                 } completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             CancelTaskViewController *vc;
             if (_where == 3) {
                 vc = [[CancelTaskViewController alloc] initWithDataId:_model.projectId WithTaskName:_model.projectName With:2];
             } else {
                 vc = [[CancelTaskViewController alloc] initWithDataId:_model.projectId WithTaskName:_model.projectName With:1];
             }
             
             pushToControllerWithAnimated(vc)
         }
     } cancelButtonTitle:@"继续任务" otherButtonTitles:@"取消任务", nil];
    
}

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64 - 44) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 50;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectDetailDescCell" bundle:nil] forCellReuseIdentifier:@"desc"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanyPublishTwofortw0Cell" bundle:nil] forCellReuseIdentifier:@"CompanyPublishTwofortw0Cell"];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"PdfTableCell" bundle:nil] forCellReuseIdentifier:@"PdfTableCell"];
   
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = self.sectionHeadView;
}

- (void)setFooterView
{
    [self.footerView removeAllSubviews];
    [self.footerView removeFromSuperview];
    self.operationButton = nil;
    self.footerView = nil;
    
    
    
        if ([self.demand_status isEqualToString:@"0"] || [self.demand_status isEqualToString:@"7"] || [self.demand_status isEqualToString:@"8"]) {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 44);
            _operationButton.backgroundColor = UIColorFromRGBString(HuiSeBtnValue);
            _operationButton.tag = kButtonTag + [_type integerValue];
            //            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_operationButton setTitle:@"任务已停止" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            _operationButton.userInteractionEnabled = NO;
            [_footerView addSubview:_operationButton];
            
            return ;
        }

    
    switch ([_type integerValue]) {
        case 3:
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(0, 0, ZQ_Device_Width , 44);
            _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
            _operationButton.tag = kButtonTag + [_type integerValue];
//            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_operationButton setTitle:@"重新开始任务" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_footerView addSubview:_operationButton];
        }
            break;
        case 1: //进行中的任务
        {
            
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _operationButton.frame = ZQ_RECT_CREATE(0, 0, 134, 44);
            _operationButton.backgroundColor = [UIColor whiteColor];
            _operationButton.tag = kButtonTag + [_type integerValue];
//            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0x4d4d4d) forState:UIControlStateNormal];
                        [_operationButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateHighlighted];
            [_operationButton setTitle:@"取消任务" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            self.qiandaobtn.frame = CGRectMake(134, 0, ScreenWidth-134, 44);
            [_footerView addSubview:self.qiandaobtn];
            
            [_footerView addSubview:_operationButton];
        }
            break;
            
            
        case 2:
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 44);
            _operationButton.backgroundColor = UIColorFromRGBString(HuiSeBtnValue);
            _operationButton.tag = kButtonTag + [_type integerValue];
//            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_operationButton setTitle:@"任务已停止" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            _operationButton.userInteractionEnabled = NO;
            [_footerView addSubview:_operationButton];
        }
            break;

            
        default:
            break;
    }
    
    //
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if ([ZQ_CommonTool isEmpty:_model.projectDesc]) {
            return 1 - 1;
        } else {
            return 2 - 1;
        }
    }else if (section == 2){
        if ([ZQ_CommonTool isEmpty:_model.pdfStr]) {
            return 0;
        }
        return 1;
    }else if (section == 3){
        return self.stepArrays.count;
    }
    
    return 1;
}

-(void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{

    UploadImageModel *model = self.stepArrays[indexPath.row];
    NSMutableArray <NSURL *>*photosURL = [NSMutableArray array];
    for (NSString *URLString in model.imageArray) {
        NSURL *url = [NSURL URLWithString:[NSString imagePathAddPrefix:URLString]];
        [photosURL addObject:url];
    }
    [self pushPhotoBrowser:photosURL currentPhotoIndex:tag];
    
    /**!
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:model.imageArray];
    vc.hideRightBtn = YES;
    vc.delegate = self;
    vc.indexPath = indexPath;
    [vc seleImageLocation:tag];
    [vc showDeleteButton];
    [self.navigationController pushViewController:vc animated:YES];
     */
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        FirstProjectOrTaskDetailCell *cell = [FirstProjectOrTaskDetailCell cellWithTableView:tableView];
        _firstDetailCell = cell;
        cell.delegate = self;
        [cell btnLayOut:_model];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == 1) {
        SecondProjectOrTaskDetailCell *cell1 = [SecondProjectOrTaskDetailCell cellWithTableView:tableView];
        _secondDetailCell = cell1;
//        if ([ZQ_CommonTool isEmpty:_model.projectDesc]) {
//            
//                if (indexPath.row == 0) {
//                cell1.nameLabel.text = @"人员要求：";
//                [cell1.listArray removeAllObjects];
//                [cell1.listArray addObjectsFromArray:self.model.personnelArray];
//                [cell1 btnLayOut];
//            }
//        } else {
            if (indexPath.row == 0) {
                //                cell1.nameLabel.text = @"任务描述：";
                //                cell1.descString = self.model.projectDesc;
                //                [cell1 btnLayOut1];
                
                ProjectDetailDescCell *celllhk = [self.tableView dequeueReusableCellWithIdentifier:@"desc"];
                
                celllhk.targetLabel.text = self.model.projectTarget_clients;
                celllhk.descLabel.text = self.model.projectDesc;
                celllhk.advantageLabel.text = self.model.project_advantage;
                celllhk.needsLabel.text = self.model.project_materials_needed;
                celllhk.explainLabel.text = self.model.project_explain;
                celllhk.selectionStyle=UITableViewCellSelectionStyleNone;
                return celllhk;
                
            }
            
            
//            else if (indexPath.row == 1) {
//                cell1.nameLabel.text = @"人员要求：";
//                [cell1.listArray removeAllObjects];
//                [cell1.listArray addObjectsFromArray:self.model.personnelArray];
//                [cell1 btnLayOut];
//            }
//        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.accessoryType = UITableViewCellAccessoryNone;
        return cell1;
    }else if (indexPath.section == 2){
        PdfTableCell *pdfcell = [self.tableView dequeueReusableCellWithIdentifier:@"PdfTableCell"];
        pdfcell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        pdfcell.shareblock = ^{
            
            if ([NSURL URLWithString:_model.pdfStr] == nil) {
                [self showHint:@"服务器返回的url不正确"];
            }else{
                [self shareWithpdf:_model.pdfStr andPdfname:_model.pdfName];
            }
            
            
        };
        pdfcell.readblock = ^{
            
            
            
            NSURL *cleanURL = [NSURL URLWithString:_model.pdfStr];
            
            if (cleanURL == nil) {
                [self showHint:@"服务器返回的url不正确"];
            }else{
                [[UIApplication sharedApplication] openURL:cleanURL];
            }
            
            
            
            
        };

        
        
        pdfcell.pdfNameLabel.text = _model.pdfName;
        return pdfcell;
        
    }else if (indexPath.section == 3){
        
        CompanyPublishTwofortw0Cell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyPublishTwofortw0Cell"];
        UploadImageModel *model = self.stepArrays[indexPath.row];
        twoCell.indexPath = indexPath;
        twoCell.delegate =self;
        
        twoCell.isDetail = YES;
        twoCell.model = model;
        twoCell.numberLabel.font = [UIFont systemFontOfSize:12];
        twoCell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];

        return twoCell;
    }

    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TaskDetailViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskDetailViewController"];
    }
    
    [cell.contentView addSubview:self.mapView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(_mapView.frame.size.width - 40, _mapView.frame.size.height - 100, 40, 40);
    addButton.layer.cornerRadius = 5;
    addButton.backgroundColor = [UIColor colorWithR:255 G:255 B:255 A:0.9];;
    [addButton setTitle:@"十" forState:UIControlStateNormal];
    [addButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addMapZoomClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_mapView addSubview:addButton];
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(_mapView.frame.size.width - 40, _mapView.frame.size.height - 60, 40, 40);
    minusButton.layer.cornerRadius = 5;
    minusButton.backgroundColor = [UIColor colorWithR:255 G:255 B:255 A:0.9];;
    [minusButton setTitle:@"一" forState:UIControlStateNormal];
    [minusButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusMapZoomClick) forControlEvents:UIControlEventTouchUpInside];
    minusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_mapView addSubview:minusButton];
    
    
    
    if (![ZQ_CommonTool isEmptyArray:_pointArray]) {
        for (int i = 0; i < _pointArray.count; i++) {
            FXLongitudeLatitudeModel *model = _pointArray[i];
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            CLLocationCoordinate2D coor;
            coor.latitude = [model.latitudeStr doubleValue];
            coor.longitude = [model.longitudeStr doubleValue];
            annotation.coordinate = coor;
            annotation.title = model.titleStr;
            [_mapView addAnnotation:annotation];
        }
    } else {
        CLLocationCoordinate2D coor;
        coor.latitude = [_locationDic[@"latitude"] doubleValue];
        coor.longitude = [_locationDic[@"longitude"] doubleValue];
        _mapView.centerCoordinate = coor;//设置此位置为中心点
    }
    self.tableView.scrollEnabled = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}



-(void)shareWithpdf:(NSString *)pdfStr andPdfname:(NSString *)pdfNmae{
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [SSUIShareActionSheetStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    [SSUIShareActionSheetStyle setActionSheetColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setItemNameColor:kUIColorFromRGB(0x777777)];
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:11]];
    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setCancelButtonLabelColor:kUIColorFromRGB(0x666666)];
    NSString *projectName = [NSString stringWithFormat:@"%@的附件",self.model.projectName];
    if ([ZQ_CommonTool isEmpty:model.shareImg]) {
        model.shareImg = @"http://dev.yituiyun.cn//images/applogo.jpg";
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:pdfNmae
                                     images:@[model.shareImg]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", pdfStr]]
                                      title:projectName
                                       type:SSDKContentTypeAuto];
    
    
    [shareParams SSDKSetupQQParamsByText:pdfNmae
                                   title:projectName
                                     url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", pdfStr]]
                              thumbImage:[NSURL URLWithString:model.shareImg]
                                   image:nil
                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatFav),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
    //2、分享
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                     items:platforms
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   [MobClick event:@"shareObjectNums"];
                                                                   
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                                   
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    
}

#pragma mark 地图
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TaskDetail"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.draggable = NO;//不可拖动
        if (![annotation.title isEqualToString:@"我的位置"]) {
            newAnnotationView.image = [UIImage imageNamed:@"2"];
        }
        return newAnnotationView;
    }
    return nil;
}

//缩放地图
- (void)addMapZoomClick{
    [_mapView zoomIn];
}
- (void)minusMapZoomClick{
    [_mapView zoomOut];
}

//点击大头针 弹出或收起气泡
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //    NSLog(@"点击了大头针");
}
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    for (FXLongitudeLatitudeModel *model in _pointArray) {
        CLLocationCoordinate2D coor = view.annotation.coordinate;
        if (([model.latitudeStr doubleValue] == coor.latitude) && ([model.longitudeStr doubleValue] == coor.longitude)) {
            FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:model.pointId];
            pushToControllerWithAnimated(detailVc)
            break;
        }
    }
}

//地图区域滑动
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.tableView.scrollEnabled = NO;
    //    NSLog(@"-----地图滑动了-----");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.tableView.scrollEnabled = YES;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    FXMapDetailController *mapVc = [[FXMapDetailController alloc]init];
    mapVc.myLon = self.myLon;
    mapVc.myLat = self.myLat;
    mapVc.dataArray = self.pointArray;
    //创建动画
    CATransition*ani = [CATransition animation];
    //设置动画类型
    ani.type = @"oglFlip";
    //设置动画时间
    ani.duration = 1;
    //动画的类型 type
    //@"cube"－ 立方体效果  @"suckEffect"－收缩效果，如一块布被抽走   @"oglFlip"－上下翻转效果   @"rippleEffect"－滴水效果  @"pageCurl"－向上翻一页  @"pageUnCurl"－向下翻一页 @"rotate" 旋转效果 @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
    //    @"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"rotate",@"cameraIrisHollowOpen", @"cameraIrisHollowClose",kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal
    //动画类型
    //kCATransitionFade    新视图逐渐显示在屏幕上，旧视图逐渐淡化出视野
    //kCATransitionMoveIn  新视图移动到旧视图上面，好像盖在上面
    //kCATransitionPush    新视图将旧视图退出去
    //kCATransitionReveal  将旧视图移开显示下面的新视图
    
    //动画快慢 timingFunction
    /*
     *  kCAMediaTimingFunctionLinear            线性,即匀速
     *  kCAMediaTimingFunctionEaseIn            先慢后快
     *  kCAMediaTimingFunctionEaseOut           先快后慢
     *  kCAMediaTimingFunctionEaseInEaseOut     先慢后快再慢
     *  kCAMediaTimingFunctionDefault           实际效果是动画中间比较快.
     */
    //设置动画速率
    NSArray *array = @[kCAMediaTimingFunctionLinear,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionEaseInEaseOut,kCAMediaTimingFunctionDefault];
    //设置动画的运动方式
    ani.timingFunction = [CAMediaTimingFunction functionWithName:array[0]];
    
    //动画出现方向
    NSArray *array1 = @[kCATransitionFromLeft,kCATransitionFromRight,kCATransitionFromTop,kCATransitionFromBottom];
    /*
     *  90cw    逆时针旋转90°
     *  90ccw   顺时针旋转90°
     *  180cw   逆时针旋转180°
     *  180ccw  顺时针旋转180°
     */
    //动画rotate时 方向为旋转
    NSArray *array2 = @[@"90cw",@"90ccw",@"180cw",@"180ccw"];
    
    //设置动画从哪个方向出现
    ani.subtype = array1[1];
    //    if (indexPath.row==6) {
    //        ani.subtype=array2[arc4random()%4];
    //    }else{
    //        ani.subtype=array1[arc4random()%4];
    //    }
    
    //添加动画在导航页面上
    [self.navigationController.view.layer addAnimation:ani forKey:nil];
    //push 需要注意最后的参数为NO
    LHKNearSellerViewController *serallvc = [[LHKNearSellerViewController alloc]init];
    [self.navigationController pushViewController:serallvc animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 3 || section == 4) {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        if ([ZQ_CommonTool isEmpty:_model.pdfStr]) {
            return 0.0001;
        }
    }

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _firstDetailCell.cellHight;
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return UITableViewAutomaticDimension;
        }else{
            return _secondDetailCell.cellHight;}
        
        
        
    } else if (indexPath.section == 2) {
        return 44;
    }else if (indexPath.section == 3){
        return UITableViewAutomaticDimension;
    }
    return 250;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1  || section == 3 || section == 4) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 40)];
        view.backgroundColor = kUIColorFromRGB(0xffffff);
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 12.5, 15, 15)];
        [view addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, ZQ_Device_Width - 33, 39)];
        label.textColor = kUIColorFromRGB(0x000000);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15.f];
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 39, ZQ_Device_Width, 1)];
        lineView.backgroundColor = kUIColorFromRGB(0xeeeeee);
        [view addSubview:lineView];
        
        if (section == 1) {
            label.text = @"工作描述";
            imageV.image = [UIImage imageNamed:@"jobDescription"];
        } else if (section == 4) {
//            label.text = @"地推地图";
            label.text = @"已推广商家";
            imageV.image = [UIImage imageNamed:@"pushMap"];
            
            UIButton *talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            talkButton.frame = CGRectMake(self.view.frame.size.width - 13 - 10 - 60, 0, 60, 40);
            [talkButton setTitle:@"讨论组" forState:UIControlStateNormal];
            [talkButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
            [talkButton addTarget:self action:@selector(talkButtonClick) forControlEvents:UIControlEventTouchUpInside];
            talkButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [view addSubview:talkButton];
            
            UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(talkButton.frame), 13, 8, 13)];
            rightView.image = [UIImage imageNamed:@"com_arrows_right.png"];
            [view addSubview:rightView];
            
        }else if (section ==3) {
            label.text = @"任务步骤";
            imageV.image = [UIImage imageNamed:@"jobDescription"];

        }
        
        //        else if (section == 3) {
//            imageV.image = [UIImage imageNamed:@"taskNode"];
//            if ([_model.payType integerValue] == 1) {
//                label.text = @"任务节点";
//            } else if ([_model.payType integerValue] == 2){
//                label.text = @"任务节点(9:00-18:30签到无效)";
//            }
//            
////            if (_dataArray.count >= 2) {
//                UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                moreButton.frame = CGRectMake(self.view.frame.size.width - 13 - 10 - 40, 0, 40, 40);
//                [moreButton setTitle:@"更多" forState:UIControlStateNormal];
//                [moreButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
//                [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
//                moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
//                [view addSubview:moreButton];
//                
//                UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moreButton.frame), 13, 8, 13)];
//                rightView.image = [UIImage imageNamed:@"com_arrows_right.png"];
//                [view addSubview:rightView];
////            }
//        }
        
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 3) {
        if (![ZQ_CommonTool isEmptyArray:_dataArray]) {
            if (indexPath.row == 0) {
                TaskNodeModel *model = _dataArray[indexPath.row];
                if ([model.nodeState isEqualToString:@"1"] || [model.nodeState isEqualToString:@"2"] || [model.nodeState isEqualToString:@"3"] || [model.nodeState isEqualToString:@"4"]) {
                            UploadDetailViewController *vc = [[UploadDetailViewController alloc] initWithTaskNodeModel:model WithDataArray:_model.positionArray WithWhere:1];
                            pushToControllerWithAnimated(vc)
                }
            }
        }
    }
}

#pragma mark 讨论组
- (void)talkButtonClick{
    
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:_model.groupId includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            if (aGroup) {
                BOOL isHave = NO;
                for (NSString *str in aGroup.occupants) {
                    if ([infoModel.userID isEqualToString:str]) {
                        isHave = YES;
                        break;
                    }
                }
                if (isHave == YES) {
                    [self joinGroup];
                } else {
                    [self joinGroupGet];
                }
            }
        }
    }];
}

- (void)joinGroupGet
{
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    __weak TaskDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加入中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = infoModel.userID;
    params[@"groupid"] = _model.groupId;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.addGroup"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"] || [responseObject[@"errno"] isEqualToString:@"2"]) {
            [weakSelf joinGroup];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加入失败，请检查网络"];
    }];
}

- (void)joinGroup
{
    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:_model.groupId conversationType:EMConversationTypeGroupChat];
    
    //    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_model.groupId conversationType:EMConversationTypeGroupChat];
    chatController.title = _model.projectName;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark 更多节点
- (void)moreButtonClick
{
    NodeListViewController *vc = [[NodeListViewController alloc] initWith:1 WithProjectModel:_model];
    pushToControllerWithAnimated(vc)
}

#pragma mark - TaskNodeCellDelegate
- (void)checkInButtonClickWithIndex:(NSIndexPath *)indexPath//签到
{
    [self checkInButtonReques];
}

-(void)checkInButtonReques{
    
    SignInViewController *vc = [[SignInViewController alloc] initWithProjectModel:_model];
    pushToControllerWithAnimated(vc)

}

#pragma mark-上传资料
- (void)uploadButtonClickWithIndex:(NSIndexPath *)indexPath//上传
{
    if ([_type isEqualToString:@"1"]) {
        TaskNodeModel *model = _dataArray[indexPath.row];
        UploadViewController *vc = [[UploadViewController alloc] initWithTaskNodeModel:model WithWhere:1];
        [vc.textArray addObjectsFromArray:_model.textArray];
        [vc.imageArray addObjectsFromArray:_model.imgsArray];
        pushToControllerWithAnimated(vc)
    } else {
        [ZQ_UIAlertView showMessage:@"此任务不能上传资料" cancelTitle:@"确定"];
    }
}


#pragma mark--是否开始取消任务
- (void)operationButtonClick:(UIButton *)button{
    MJWeakSelf
    
    
    switch (button.tag - kButtonTag) {
       
        case 1:
        {
            
            
            LHKAlterView *alterView =[LHKAlterView alterViewWithTitle:@"是否取消的任务" andDesc:@"取消的任务在任务大厅-历史任务" WithCancelBlock:^(LHKAlterView *alterView) {
                [alterView removeFromSuperview];
                
            } WithMakeSure:^(LHKAlterView *alterView) {
                [weakSelf  startOrCancelTaskType:3];//BD取消任务
                 [alterView removeFromSuperview];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alterView];
        }
            break;
        case 3: //重新开始任务
        {
            
                        
            LHKAlterView *alterView =[LHKAlterView alterViewWithTitle:@"是否重新开始任务" andDesc:@"重新开始任务在任务大厅-我的任务" WithCancelBlock:^(LHKAlterView *alterView) {
                [alterView removeFromSuperview];
                
            } WithMakeSure:^(LHKAlterView *alterView) {
                [weakSelf  startOrCancelTaskType:1];//BD取消任务

                [alterView removeFromSuperview];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alterView];
    

        }
            break;
            
        default:
            break;
    }
}

//开始任务
- (void)startTask
{
    __weak TaskDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _model.projectId;
    params[@"memberid"] = infoModel.userID;
    params[@"status"] = @"1";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.taskStatus"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [MobClick event:@"startTaskNums"];
            
            _type = @"1";
//            [weakSelf setFooterView];
            [weakSelf nodeListDataArray];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

//取消任务
- (void)startOrCancelTaskType:(NSInteger)type
{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中"];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"memberid"] =model.userID;
    param[@"demandid"] = self.dataId;
    param[@"status"] = @(type);
    [XKNetworkManager POSTToUrlString:TaskStartorCancel parameters:param progress:^(CGFloat progress) {
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];

        NSDictionary *result = JSonDictionary;
        
        if ([result[@"errno"]  integerValue] == 0 ) {
            [weakSelf showHint:result[@"errmsg"]];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else{
            [weakSelf showHint:result[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showHint:error.localizedDescription];
        [SVProgressHUD dismiss];
    }];
    
    
}

- (void)moreAdressButtonClick
{
    if ([_model.isAdress integerValue] == 1) {
        _model.isAdress = @"2";
    } else if ([_model.isAdress integerValue] == 2) {
        _model.isAdress = @"1";
    }
    [_tableView reloadData];
}




-(void)restartTaskWith:(NSString *)pid wihtT_demanType:(NSString *)t{
    
    MJWeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"t"] = @"1";
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    dict[@"memberid"] = model.userID;
    dict[@"demandid"] = pid;
    dict[@"demandType"] = @(1);
    
    [SVProgressHUD showWithStatus:@"正在重新开始任务"];
    [XKNetworkManager POSTToUrlString:ProjectRestartTaskURL parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        
        [SVProgressHUD dismiss];
        
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
    
}


@end
