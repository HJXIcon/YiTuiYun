//
//  FXNearbyCompanyController.m
//  yituiyun
//
//  Created by fx on 16/10/25.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXNearbyCompanyController.h"
#import "CCLocationManager.h"
#import "FXLongitudeLatitudeModel.h"
#import "FXCompanyDetailController.h"
#import "ChatViewController.h"

@interface FXNearbyCompanyController ()<BMKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, copy) NSString *numStr; //附近企业数量
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *myLon;
@property (nonatomic, copy) NSString *myLat;
@property (nonatomic, copy) NSString *groupId;
@end

@implementation FXNearbyCompanyController{
    BMKMapView *_mapView;
    CLLocationManager *_manager;
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
    __weak FXNearbyCompanyController *weakSelf = self;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=1&to=5&ak=pn8B4yEuClbl9Gy84rGSd3oK", newLocation.coordinate.longitude, newLocation.coordinate.latitude];
    [mgr GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"result"];
        NSDictionary *dic = array.firstObject;
        [weakSelf getData:dic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"定位失败"];
    }];
    
    [manager stopUpdatingLocation];
}

- (void)getData:(NSDictionary *)dic{
    CLLocationCoordinate2D coor;
    coor.latitude = [dic[@"y"] doubleValue];
    coor.longitude = [dic[@"x"] doubleValue];
    _mapView.centerCoordinate = coor;//设置此位置为中心点
    
    __weak FXNearbyCompanyController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"t"] = @"2";
    params[@"uid"] = infoModel.userID;
    params[@"lat"] = [NSString stringWithFormat:@"%@", dic[@"y"]];
    params[@"lng"] = [NSString stringWithFormat:@"%@", dic[@"x"]];
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.nearby"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            _groupId = [NSString stringWithFormat:@"%@", responseObject[@"groupid"]];
            NSArray *listData = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                _numStr = [NSString stringWithFormat:@"%zd", listData.count];
                for (NSDictionary *subDic in listData) {
                    FXLongitudeLatitudeModel *model = [[FXLongitudeLatitudeModel alloc]init];
                    model.longitudeStr = [NSString stringWithFormat:@"%@", subDic[@"lng"]];
                    model.latitudeStr = [NSString stringWithFormat:@"%@", subDic[@"lat"]];
                    model.titleStr = [NSString stringWithFormat:@"%@", subDic[@"nickname"]];
                    model.pointId = [NSString stringWithFormat:@"%@", subDic[@"uid"]];
                    if ([subDic[@"uid"] integerValue] != [infoModel.userID integerValue]) {
                        [self.dataArray addObject:model];
                    }
                }
            }
            self.myLat = [NSString stringWithFormat:@"%@", dic[@"y"]];
            self.myLon = [NSString stringWithFormat:@"%@", dic[@"x"]];
            [weakSelf setUpViews];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
}

-(void)stopLocation
{
    _manager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"附近企业";
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"讨论组" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    
    [self setupLocation];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItem
{
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:_groupId includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
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
                    [self talkButtonClick];
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
    __weak FXNearbyCompanyController *weakSelf = self;
    [self showHudInView:self.view hint:@"加入中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = infoModel.userID;
    params[@"groupid"] = _groupId;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.addGroup"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"] || [responseObject[@"errno"] isEqualToString:@"2"]) {
            [weakSelf talkButtonClick];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加入失败，请检查网络"];
    }];
}

#pragma mark 讨论组
- (void)talkButtonClick{
    
    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:_groupId conversationType:EMConversationTypeGroupChat];

//    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_groupId conversationType:EMConversationTypeGroupChat];
    chatController.title = @"企业交流";
    pushToControllerWithAnimated(chatController)
}

- (void)setUpViews{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 100)];
    headView.backgroundColor = MainColor;
    [self.view addSubview:headView];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ZQ_Device_Width - 40, 80)];
    NSString *string = nil;
    if ([ZQ_CommonTool isEmpty:self.numStr]) {
        string = @"0";
    } else {
        string = self.numStr;
    }
    _numLabel.text = [NSString stringWithFormat:@"附近位置有%@家企业",string];
    _numLabel.textColor = kUIColorFromRGB(0x404040);
    _numLabel.backgroundColor = kUIColorFromRGB(0xffffff);
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:17];
    _numLabel.layer.cornerRadius = 5;
    _numLabel.clipsToBounds = YES;
    [headView addSubview:_numLabel];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), ZQ_Device_Width, ZQ_Device_Height - CGRectGetHeight(headView.frame) - 64)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:16];//设置缩放比
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(_mapView.frame.size.width - 45, _mapView.frame.size.height - 120, 40, 40);
    addButton.layer.cornerRadius = 5;
    addButton.backgroundColor = [UIColor colorWithR:255 G:255 B:255 A:0.9];;
    [addButton setTitle:@"十" forState:UIControlStateNormal];
    [addButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addMapZoomClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_mapView addSubview:addButton];
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(_mapView.frame.size.width - 45, _mapView.frame.size.height - 80, 40, 40);
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

    for (int i = 0; i < self.dataArray.count; i++) {
        FXLongitudeLatitudeModel *model = _dataArray[i];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.latitudeStr doubleValue];
        coor.longitude = [model.longitudeStr doubleValue];
        annotation.coordinate = coor;
        annotation.title = model.titleStr;
//        if (i == 0) {
//            _mapView.centerCoordinate = coor;//设置此位置为中心点
//        }
        [_mapView addAnnotation:annotation];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NearbyPerson"];
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
    for (FXLongitudeLatitudeModel *model in self.dataArray) {
        CLLocationCoordinate2D coor = view.annotation.coordinate;
        if (([model.latitudeStr doubleValue] == coor.latitude) && ([model.longitudeStr doubleValue] == coor.longitude)) {
            FXCompanyDetailController *detailVc = [[FXCompanyDetailController alloc] initCompanyID:model.pointId];
            pushToControllerWithAnimated(detailVc)
            break;
        }
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
