//
//  FXTodayTaskController.m
//  yituiyun
//
//  Created by fx on 16/10/17.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXTodayTaskController.h"
#import "FXLongitudeLatitudeModel.h"
#import "ProjectModel.h"
#import "TaskHallCell.h"
#import "CancelTaskViewController.h"
#import "CCLocationManager.h"
#import "FXTodayTaskMapDetailController.h"

@interface FXTodayTaskController ()<BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,TaskHallCellDelegate>

@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic, copy) NSString *todayBDNum;//今日推广数量
@property (nonatomic, copy) NSString *dealNum;//成单数量
@property (nonatomic, strong) ProjectModel *projectModel;
@property (nonatomic, strong) NSMutableArray *pointArray;//推广地点
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, copy) NSString *myLon;
@property (nonatomic, copy) NSString *myLat;

@end

@implementation FXTodayTaskController
{
    BMKMapView *_mapView;
    CLLocationManager *_manager;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
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
    __weak FXTodayTaskController *weakSelf = self;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=1&to=5&ak=pn8B4yEuClbl9Gy84rGSd3oK", newLocation.coordinate.longitude, newLocation.coordinate.latitude];
    [mgr GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"result"];
        NSDictionary *dic = array.firstObject;
        self.myLat = [NSString stringWithFormat:@"%@", dic[@"y"]];
        self.myLon = [NSString stringWithFormat:@"%@", dic[@"x"]];
        
        BMKPointAnnotation* myAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D myCoor;
        myCoor.latitude = [self.myLat doubleValue];
        myCoor.longitude = [self.myLon doubleValue];
        myAnnotation.coordinate = myCoor;
        myAnnotation.title = @"我的位置";
        _mapView.centerCoordinate = myCoor;//设置此位置为中心点
        [_mapView addAnnotation:myAnnotation];

        [self getTaskData];

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

- (void)getTaskData
{
    __weak FXTodayTaskController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.todayTask"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:dic]) {
                weakSelf.projectModel = [[ProjectModel alloc] init];
                weakSelf.projectModel.projectId = [NSString stringWithFormat:@"%@", dic[@"demandid"]];
                weakSelf.projectModel.projectName = [NSString stringWithFormat:@"%@", dic[@"projectName"]];
                weakSelf.projectModel.tagArray = [NSMutableArray array];
                [weakSelf.projectModel.tagArray addObjectsFromArray:dic[@"tags"]];
                weakSelf.projectModel.projectTime = [NSString stringWithFormat:@"%@", dic[@"timeTypeStr"]];
                weakSelf.projectModel.isNew = @"0";
                weakSelf.projectModel.status = [NSString stringWithFormat:@"%@", dic[@"status"]];
                weakSelf.projectModel.timeType = [NSString stringWithFormat:@"%@", dic[@"timeType"]];
                weakSelf.projectModel.projectImage = [NSString stringWithFormat:@"%@%@", kHost, dic[@"thumb"]];
                
                weakSelf.todayBDNum = [NSString stringWithFormat:@"%@", dic[@"num"]];
                weakSelf.dealNum = [NSString stringWithFormat:@"%@", dic[@"okNum"]];
                
                NSArray *array = [NSArray arrayWithArray:dic[@"latlng"]];
                for (NSDictionary *subDic in array) {
                    FXLongitudeLatitudeModel *model = [[FXLongitudeLatitudeModel alloc]init];
                    model.longitudeStr = [NSString stringWithFormat:@"%@",subDic[@"lng"]];
                    model.latitudeStr = [NSString stringWithFormat:@"%@",subDic[@"lat"]];
                    model.titleStr = [NSString stringWithFormat:@"%@",subDic[@"address"]];
                    model.inputtime = [NSString stringWithFormat:@"%@",subDic[@"inputtime"]];
                    [self.pointArray addObject:model];
                }
            }
            [_tableView reloadData];
        }
        _tableView.tableHeaderView = [weakSelf setUpTableHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今日任务";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self setupLocation];

    [self setUpTableView];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

- (UIView *)setUpTableHeaderView
{
    if (self.tableHeaderView) {
        [self.tableHeaderView removeAllSubviews];
    } else {
        self.tableHeaderView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 220)];
        _tableHeaderView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    UIView *backFirView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 130)];
    backFirView.backgroundColor = MainColor;
    [_tableHeaderView addSubview:backFirView];
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake((backFirView.frame.size.width - 70) / 2, 20, 70, 70)];
    iconView.layer.cornerRadius = iconView.frame.size.height / 2;
    
//    NSLog(@"------%@---",model);
    [iconView sd_setImageWithURL:[NSString stringWithFormat:@"%@%@", kHost, model.avatar] placeholderImage:[UIImage imageNamed:@"morenIcon"]];
    iconView.clipsToBounds = YES;
    iconView.backgroundColor = [UIColor clearColor];
    [backFirView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 10, ZQ_Device_Width, 20)];
    nameLabel.text = model.nickname;
    nameLabel.textColor = kUIColorFromRGB(0xffffff);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [backFirView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(backFirView.frame), ZQ_Device_Width, 10)];
    lineView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [_tableHeaderView addSubview:lineView];
    
    UIView *backSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backFirView.frame) + 10, ZQ_Device_Width, 70)];
    backSecView.backgroundColor = kUIColorFromRGB(0xffffff);
    [_tableHeaderView addSubview:backSecView];
    
    UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, backSecView.frame.size.width / 2, 20)];
    todayLabel.text = @"今日推广";
    todayLabel.textColor = kUIColorFromRGB(0x808080);
    todayLabel.textAlignment = NSTextAlignmentCenter;
    todayLabel.font = [UIFont systemFontOfSize:14];
    [backSecView addSubview:todayLabel];
    
    UILabel *todayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame) + 10, backSecView.frame.size.width / 2, 20)];
    NSString *todayNum = nil;
    if ([ZQ_CommonTool isEmpty:self.todayBDNum]) {
        todayNum = [@"0" stringByAppendingString:@""];
    } else {
        todayNum = [self.todayBDNum stringByAppendingString:@""];
    }
    todayNumLabel.text = todayNum;
    todayNumLabel.textColor = MainColor;
    todayNumLabel.textAlignment = NSTextAlignmentCenter;
    todayNumLabel.font = [UIFont systemFontOfSize:19];
    [backSecView addSubview:todayNumLabel];
    
    UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(backSecView.frame.size.width / 2, 12, 1, 46)];
    lineFirView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backSecView addSubview:lineFirView];
    
    UILabel *finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineFirView.frame), 10, backSecView.frame.size.width / 2 - 1, 20)];
    finishLabel.text = @"成单";
    finishLabel.textAlignment = NSTextAlignmentCenter;
    finishLabel.textColor = kUIColorFromRGB(0x808080);
    finishLabel.font = [UIFont systemFontOfSize:14];
    [backSecView addSubview:finishLabel];
    
    UILabel *finishNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineFirView.frame), CGRectGetMaxY(finishLabel.frame) + 10, backSecView.frame.size.width / 2 - 1, 20)];
    NSString *finishNum = nil;
    if ([ZQ_CommonTool isEmpty:self.dealNum]) {
        finishNum = [@"0" stringByAppendingString:@""];
    } else {
        finishNum = [self.dealNum stringByAppendingString:@""];
    }
    finishNumLabel.text = finishNum;
    finishNumLabel.textAlignment = NSTextAlignmentCenter;
    finishNumLabel.textColor = MainColor;
    finishNumLabel.font = [UIFont systemFontOfSize:19];
    [backSecView addSubview:finishNumLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(backSecView.frame), ZQ_Device_Width, 10)];
    lineView1.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [_tableHeaderView addSubview:lineView1];
    
    return _tableHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([ZQ_CommonTool isEmpty:_projectModel.projectName]) {
        return 1;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (![ZQ_CommonTool isEmpty:_projectModel.projectName]) {
            static NSString *ID = @"TodayTask";
            TaskHallCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[TaskHallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = _projectModel;
            cell.button.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FXTodayTaskController"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FXTodayTaskController"];
            }
            UIView *backMapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 250)];
            [cell.contentView addSubview:backMapView];
            
//            if (_mapView) {
//                [_mapView removeAllSubviews];
//                [_mapView removeFromSuperview];
//                _mapView.delegate = nil;
//                _mapView = nil;
//            }
            _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(12, 12, ZQ_Device_Width - 24, 250 - 24)];
            [_mapView setZoomLevel:16];
            _mapView.delegate = self;
            _mapView.showMapScaleBar = YES;
            [backMapView addSubview:_mapView];
            
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
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FXTodayTaskController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FXTodayTaskController"];
    }
    UIView *backMapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 250)];
    [cell.contentView addSubview:backMapView];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(12, 12, ZQ_Device_Width - 24, 250 - 24)];
    [_mapView setZoomLevel:16];
    _mapView.delegate = self;
    _mapView.showMapScaleBar = YES;
    [backMapView addSubview:_mapView];
    
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

    if (![ZQ_CommonTool isEmptyArray:self.pointArray]) {
        CLLocationCoordinate2D coords[self.pointArray.count];
        
        for (int j = 0; j < self.pointArray.count; j++) {
            FXLongitudeLatitudeModel *model = _pointArray[j];
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [model.latitudeStr doubleValue] + j * 0.001;
            coor.longitude = [model.longitudeStr doubleValue] + j * 0.001;
            annotation.coordinate = coor;
            annotation.title = model.titleStr;
//            if (j == 0) {
//                _mapView.centerCoordinate = coor;//设置此位置为中心点
//            }
            coords[j] = coor;
            
            [_mapView addAnnotation:annotation];
            
        }
        
        
        NSMutableArray *textureIndex = [NSMutableArray new];
        for (NSInteger i = 0; i < _pointArray.count; i++) {
            [textureIndex addObject:[NSNumber numberWithInteger:i]];
        }
        BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coords count:_pointArray.count textureIndex:textureIndex];
        [_mapView addOverlay:polyline];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = YES;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ZQ_CommonTool isEmpty:_projectModel.projectName]) {
        return 250;
    }
    
    if (indexPath.section == 0) {
        return 90;
    }
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    if (section == 0) {
        if ([ZQ_CommonTool isEmpty:_projectModel.projectName]) {
            label.text = @"行动路线分析";
            imageV.image = [UIImage imageNamed:@"pushMap"];
        } else {
            label.text = @"当前任务";
            imageV.image = [UIImage imageNamed:@"jobDescription"];
        }
    } else if (section == 1) {
        label.text = @"行动路线分析";
        imageV.image = [UIImage imageNamed:@"pushMap"];
    }
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TodayTask"];
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
//地图区域滑动
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.tableView.scrollEnabled = NO;
//    NSLog(@"-----地图滑动了-----");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.tableView.scrollEnabled = YES;
//    NSLog(@"-----地图停止滑动了-----");
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.colors = [NSArray arrayWithObjects:[UIColor colorWithR:23 G:89 B:150], [UIColor colorWithR:23 G:89 B:150], [UIColor colorWithR:23 G:89 B:150],[UIColor colorWithR:23 G:89 B:150], nil];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    FXTodayTaskMapDetailController *mapVc = [[FXTodayTaskMapDetailController alloc]init];
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
////取消任务
//- (void)cancelButtonClickWithIndex:(NSIndexPath *)indexPath
//{
//    CancelTaskViewController *vc = [[CancelTaskViewController alloc] initWithDataId:_projectModel.projectId WithTaskName:_projectModel.projectName];
//    pushToControllerWithAnimated(vc)
//}

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
