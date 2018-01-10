//
//  TaskEnterpriseDetailViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "TaskEnterpriseDetailViewController.h"
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
#import "TaskSecondCell.h"
#import "CCLocationManager.h"
#import "FXPersonDetailController.h"
#import "FXLongitudeLatitudeModel.h"
#import "FXMapDetailController.h"

#define kButtonTag 30000

@interface TaskEnterpriseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,CLLocationManagerDelegate,FirstProjectOrTaskDetailCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
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

@end

@implementation TaskEnterpriseDetailViewController
{
    CLLocationManager *_manager;
    BMKMapView *_mapView;
}

- (instancetype)initWithDataId:(NSString *)dataId WithType:(NSString *)type WithWhere:(NSInteger)where
{
    self = [super init];
    if (self) {
        self.type = type;
        self.where = where;
        self.dataId = dataId;
        self.pointArray = [NSMutableArray array];
        self.locationDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    __weak TaskEnterpriseDetailViewController *weakSelf = self;
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
                weakSelf.model.projectId = [NSString stringWithFormat:@"%@", subDic[@"demandid"]];
                weakSelf.model.memberid = [NSString stringWithFormat:@"%@", subDic[@"memberid"]];
                weakSelf.model.projectName = [NSString stringWithFormat:@"%@", subDic[@"projectName"]];
                weakSelf.model.projectDesc = [NSString stringWithFormat:@"%@", subDic[@"desc"]];
                weakSelf.model.projectTime = [NSString stringWithFormat:@"%@", subDic[@"timeTypeStr"]];
                weakSelf.model.projectPrice = [NSString stringWithFormat:@"%@", subDic[@"wn"]];
                weakSelf.model.isCollection = [NSString stringWithFormat:@"%@", subDic[@"isCollect"]];
                weakSelf.model.projectPhone = [NSString stringWithFormat:@"%@", subDic[@"mobile"]];
                weakSelf.model.isget = [NSString stringWithFormat:@"%@", subDic[@"isget"]];
                weakSelf.model.timeType = [NSString stringWithFormat:@"%@", subDic[@"timeType"]];
                weakSelf.model.single = [NSString stringWithFormat:@"%@", subDic[@"okNum"]];
                weakSelf.model.taskType = [NSString stringWithFormat:@"%@", subDic[@"t"]];
                weakSelf.model.number = [NSString stringWithFormat:@"%@", subDic[@"getNum"]];
                weakSelf.model.promotion = [NSString stringWithFormat:@"%@", subDic[@"num"]];
                weakSelf.model.isAdress = @"1";
                weakSelf.model.tagArray = [NSMutableArray array];
                [weakSelf.model.tagArray addObjectsFromArray:subDic[@"tags"]];
                weakSelf.model.positionArray = [NSMutableArray array];
                [weakSelf.model.positionArray addObjectsFromArray:subDic[@"setting"]];
                weakSelf.model.adressArray = [NSMutableArray array];
                [weakSelf.model.adressArray addObjectsFromArray:subDic[@"citysArr"]];
                weakSelf.model.personnelArray = [NSMutableArray array];
                
                NSInteger ageMin = [subDic[@"ifs"][@"ageMin"] integerValue];
                NSInteger ageMax = [subDic[@"ifs"][@"ageMax"] integerValue];
                NSInteger heightMin = [subDic[@"ifs"][@"heightMin"] integerValue];
                NSInteger heightMax = [subDic[@"ifs"][@"heightMax"] integerValue];
                NSInteger sex = [subDic[@"ifs"][@"sex"] integerValue];
                NSString *role = [NSString stringWithFormat:@"%@", subDic[@"ifs"][@"jobType"]];
                
                if ([role isEqualToString:@"0"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"身份不限",@"t":@"1"}];
                } else if ([role isEqualToString:@"1"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"全职",@"t":@"1"}];
                } else if ([role isEqualToString:@"2"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"3"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"校园兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"1,2"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"全职/兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"1,3"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"全职/校园兼职",@"t":@"1"}];
                } else if ([role isEqualToString:@"2,3"]) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"兼职/校园兼职",@"t":@"1"}];
                }
                
                if (heightMin == 0 && heightMax == 999) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"身高不限",@"t":@"1"}];
                } else {
                    NSString *name = [NSString stringWithFormat:@"身高:%zd-%zdcm", heightMin, heightMax];
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":name,@"t":@"1"}];
                }
                
                if (sex == 0) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"性别不限",@"t":@"1"}];
                } else if (sex == 1) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"男",@"t":@"1"}];
                } else if (sex == 2) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"女",@"t":@"1"}];
                }
                
                if (ageMin == 0 && ageMax == 999) {
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":@"年龄不限",@"t":@"1"}];
                } else {
                    NSString *name = [NSString stringWithFormat:@"年龄:%zd-%zd岁", ageMin, ageMax];
                    [weakSelf.model.personnelArray addObject:@{@"name_zh":name,@"t":@"1"}];
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

#pragma mark - 定位
- (void)setupLocation
{
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 100;
#ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_manager requestWhenInUseAuthorization];
        }
#endif
        if ([CLLocationManager locationServicesEnabled]) {
            [_manager startUpdatingLocation];
        } else{
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    __weak TaskEnterpriseDetailViewController *weakSelf = self;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=1&to=5&ak=pn8B4yEuClbl9Gy84rGSd3oK", newLocation.coordinate.longitude, newLocation.coordinate.latitude];
    [mgr GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"result"];
        NSDictionary *dic = array.firstObject;
        self.myLat = [NSString stringWithFormat:@"%@", dic[@"y"]];
        self.myLon = [NSString stringWithFormat:@"%@", dic[@"x"]];
        [weakSelf getValueForContentViewFromDict:dic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"定位失败"];
    }];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
}

-(void)stopLocation
{
    _manager = nil;
}

//定位城市
- (void)getValueForContentViewFromDict:(NSDictionary *)dic
{
    [_locationDic removeAllObjects];
    _locationDic[@"latitude"] = dic[@"y"];
    _locationDic[@"longitude"] = dic[@"x"];
    
    [self GetPointArrayData:_locationDic];
}

- (void)GetPointArrayData:(NSDictionary *)dic
{
    __weak TaskEnterpriseDetailViewController *weakSelf = self;
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
    
    [self setUpNavigation];
    [self setupTableView];
    if ([_type isEqualToString:@"2"] || [_type isEqualToString:@"6"]) {
        [self setFooterView];
    }
    self.model = [[ProjectModel alloc] init];
    [self dataArrayFromNetwork];
    [self setupLocation];
}

#pragma mark - setUpNavigation
- (void)setUpNavigation{
    
    self.title = @"任务详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    if ([_type isEqualToString:@"2"] || [_type isEqualToString:@"6"]) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64 - 50) style:UITableViewStyleGrouped];
    } else {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64) style:UITableViewStyleGrouped];
    }
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)setFooterView
{
    [self.footerView removeAllSubviews];
    [self.footerView removeFromSuperview];
    self.operationButton = nil;
    self.footerView = nil;
    
    switch ([_type integerValue]) {
        case 2:
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 114, ZQ_Device_Width, 50)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(12, 8, ZQ_Device_Width - 24, 34);
            _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
            _operationButton.tag = kButtonTag + [_type integerValue];
            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_operationButton setTitle:@"开始任务" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_footerView addSubview:_operationButton];
        }
            break;
        case 6:
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 114, ZQ_Device_Width, 50)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(12, 8, ZQ_Device_Width - 24, 34);
            _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
            _operationButton.tag = kButtonTag + [_type integerValue];
            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_operationButton setTitle:@"停止任务" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_footerView addSubview:_operationButton];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if ([ZQ_CommonTool isEmpty:_model.projectDesc]) {
            return 2;
        } else {
            return 3;
        }
    }
    return 1;
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
        TaskSecondCell *cell1 = [TaskSecondCell cellWithTableView:tableView];
        NSString *number = nil;
        if ([ZQ_CommonTool isEmpty:_model.number]) {
            number = @"0";
        } else {
            number = _model.number;
        }
        cell1.numberLabel.text = [NSString stringWithFormat:@"%@人", number];
        NSString *single = nil;
        if ([ZQ_CommonTool isEmpty:_model.single]) {
            single = @"0";
        } else {
            single = _model.single;
        }
        cell1.singleLabel.text = [NSString stringWithFormat:@"%@单", single];
        NSString *promotion = nil;
        if ([ZQ_CommonTool isEmpty:_model.promotion]) {
            promotion = @"0";
        } else {
            promotion = _model.promotion;
        }
        cell1.promotionLabel.text = [NSString stringWithFormat:@"%@家", promotion];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.accessoryType = UITableViewCellAccessoryNone;
        return cell1;
    } else if (indexPath.section == 2) {
        SecondProjectOrTaskDetailCell *cell1 = [SecondProjectOrTaskDetailCell cellWithTableView:tableView];
        _secondDetailCell = cell1;
        if ([ZQ_CommonTool isEmpty:_model.projectDesc]) {
            if (indexPath.row == 0) {
                cell1.nameLabel.text = @"任务提交：(收集相关资料和拍摄照片)";
                [cell1.listArray removeAllObjects];
                [cell1.listArray addObjectsFromArray:self.model.positionArray];
                [cell1 btnLayOut];
            } else if (indexPath.row == 1) {
                cell1.nameLabel.text = @"人员要求：";
                [cell1.listArray removeAllObjects];
                [cell1.listArray addObjectsFromArray:self.model.personnelArray];
                [cell1 btnLayOut];
            }
        } else {
            if (indexPath.row == 0) {
                cell1.nameLabel.text = @"任务描述：";
                cell1.descString = self.model.projectDesc;
                [cell1 btnLayOut1];
            } else if (indexPath.row == 1) {
                cell1.nameLabel.text = @"任务提交：(收集相关资料和拍摄照片)";
                [cell1.listArray removeAllObjects];
                [cell1.listArray addObjectsFromArray:self.model.positionArray];
                [cell1 btnLayOut];
            } else if (indexPath.row == 2) {
                cell1.nameLabel.text = @"人员要求：";
                [cell1.listArray removeAllObjects];
                [cell1.listArray addObjectsFromArray:self.model.personnelArray];
                [cell1 btnLayOut];
            }
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.accessoryType = UITableViewCellAccessoryNone;
        return cell1;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TaskEnterpriseDetailViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskEnterpriseDetailViewController"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (_mapView) {
        [_mapView removeAllSubviews];
        [_mapView removeFromSuperview];
        _mapView.delegate = nil;
        _mapView = nil;
    }
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 250)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:16];//设置缩放比
    _mapView.showMapScaleBar = YES;
    [cell.contentView addSubview:_mapView];
    
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
    
    BMKPointAnnotation* myAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D myCoor;
    myCoor.latitude = [self.myLat doubleValue];
    myCoor.longitude = [self.myLon doubleValue];
    myAnnotation.coordinate = myCoor;
    myAnnotation.title = @"我的位置";
    _mapView.centerCoordinate = myCoor;//设置此位置为中心点
    [_mapView addAnnotation:myAnnotation];

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
    
    return cell;
}
#pragma mark 地图
#pragma mark 地图
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TaskEnterpriseDetail"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.draggable = NO;//不可拖动
        if (![annotation.title isEqualToString:@"我的位置"]) {
            newAnnotationView.image = [UIImage imageNamed:@"mappoint.png"];
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
    [self.navigationController pushViewController:mapVc animated:NO];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 40;
    } else if (section == 1) {
        return 0.00001;
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
        return _firstDetailCell.cellHight;
    } else if (indexPath.section == 1) {
        return 70;
    } else if (indexPath.section == 2) {
        return _secondDetailCell.cellHight;
    }
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
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
        
        if (section == 2) {
            label.text = @"工作描述";
            imageV.image = [UIImage imageNamed:@"jobDescription"];
        } else if (section == 3) {
//            label.text = @"地推地图";
            label.text = @"已推广商家";
            imageV.image = [UIImage imageNamed:@"pushMap"];
        }
        
        return view;
    }
    return nil;
}

//操作点击
- (void)operationButtonClick:(UIButton *)button{
    switch (button.tag - kButtonTag) {
        case 2:
        {
            if ([_applyQuest integerValue] == 1) {
                [ZQ_UIAlertView showMessage:@"此任务已经申请开始" cancelTitle:@"知道了"];
            } else {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"您真的要申请开始此任务？"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1) {
                         [self startStoreTask];//企业开始任务
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            }
        }
            
            break;
        case 6:
        {
            if ([_applyStop integerValue] == 1) {
                [ZQ_UIAlertView showMessage:@"此任务已经申请停止" cancelTitle:@"知道了"];
            } else {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"您真的要申请停止此任务？"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1) {
                         [self stopTask];//企业停止任务
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            }
        }
            
            break;
            
        default:
            break;
    }
}

//企业开始任务
- (void)startStoreTask
{
    __weak TaskEnterpriseDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _model.projectId;
    params[@"applyQuest"] = @"1";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.demand"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"您成功申请开始任务"
                         customizationBlock:^(WCAlertView *alertView) {
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     _applyQuest = @"1";
                 }
             } cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

//企业停止任务
- (void)stopTask
{
    __weak TaskEnterpriseDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _model.projectId;
    params[@"applyStop"] = @"1";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.demand"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"您成功申请停止任务，在正式停止前此项目可继续执行"
                         customizationBlock:^(WCAlertView *alertView) {
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     _applyStop = @"1";
                 }
             } cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
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





@end
