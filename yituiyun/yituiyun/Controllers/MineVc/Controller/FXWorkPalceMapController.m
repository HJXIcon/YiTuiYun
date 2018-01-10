//
//  FXWorkPalceMapController.m
//  yituiyun
//
//  Created by fx on 16/10/24.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXWorkPalceMapController.h"
#import "CCLocationManager.h"
#import "FXLongitudeLatitudeModel.h"
#import "FXWorkPlaceDetailController.h"

@interface FXWorkPalceMapController ()<BMKMapViewDelegate,FXWorkPlaceDetailControllerDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *anolongitude;//大头针拖动后的经度
@property (nonatomic, copy) NSString *anolatitude;//大头针拖动后的纬度
@property (nonatomic, strong) UITextField *addressField;

@property (nonatomic, strong) NSMutableArray *pointArray;
//@property (nonatomic, strong) FXLongitudeLatitudeModel *placeModel;

@end

@implementation FXWorkPalceMapController{
    BMKMapView* _mapView;
    CLLocationManager *_manager;
}
- (instancetype)init{
    if (self = [super init]) {
        self.pointArray = [NSMutableArray new];
//        self.placeModel = [[FXLongitudeLatitudeModel alloc]init];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择办公地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self setupLocation];

}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
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
    __weak FXWorkPalceMapController *weakSelf = self;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=1&to=5&ak=pn8B4yEuClbl9Gy84rGSd3oK", newLocation.coordinate.longitude, newLocation.coordinate.latitude];
    [mgr GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"result"];
        NSDictionary *dic = array.firstObject;
        [weakSelf performSelectorOnMainThread:@selector(getValueForContentViewFromDict:) withObject:dic waitUntilDone:YES];
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
    NSDictionary *dicc = @{@"latitude":dic[@"y"], @"longitude":dic[@"x"]};
    self.anolatitude = [NSString stringWithFormat:@"%@", dic[@"y"]];
    self.anolongitude = [NSString stringWithFormat:@"%@", dic[@"x"]];
    [self setUpViews];
}
- (void)setUpViews{
    UIView *backFirView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    backFirView.backgroundColor = MainColor;
    [self.view addSubview:backFirView];
    
    self.addressField = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, backFirView.frame.size.width - 40, 50)];
    _addressField.backgroundColor = kUIColorFromRGB(0xffffff);
    _addressField.textColor = kUIColorFromRGB(0x404040);
    _addressField.font = [UIFont systemFontOfSize:15];
    _addressField.layer.cornerRadius = 5;
    _addressField.placeholder = @"请输入具体办公地址的楼层和门牌号";
    _addressField.returnKeyType = UIReturnKeyDone;
    _addressField.delegate = self;
    [backFirView addSubview:_addressField];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backFirView.frame), self.view.frame.size.width, self.view.frame.size.height - 100 - 50)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:16];
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.anolatitude doubleValue];
    coor.longitude = [self.anolongitude doubleValue];
    annotation.coordinate = coor;
//    annotation.title = model.titleStr;
    _mapView.centerCoordinate = coor;//设置此位置为中心点
    [_mapView addAnnotation:annotation];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, 30)];
    tipLabel.backgroundColor = [UIColor colorWithR:255 G:255 B:255 A:0.7];
    tipLabel.text = @"长按定位图标拖动至您的办公地点";
    tipLabel.layer.cornerRadius = 5;
    tipLabel.clipsToBounds = YES;
    tipLabel.textColor = kUIColorFromRGB(0x808080);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    [_mapView addSubview:tipLabel];

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

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(20, 10, bottomView.frame.size.width - 40, 30);
    sureButton.layer.cornerRadius = 5;
    sureButton.backgroundColor = MainColor;
    [sureButton setTitle:@"确 定" forState:UIControlStateNormal];
    [sureButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:sureButton];
    
}
//缩放地图
- (void)addMapZoomClick{
    [_mapView zoomIn];
}
- (void)minusMapZoomClick{
    [_mapView zoomOut];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.draggable = YES;//可拖动
//        newAnnotationView.image = [UIImage imageNamed:@"greenBottle.png"];
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    [self.addressField resignFirstResponder];
    
    CLLocationCoordinate2D coor;
    BMKPointAnnotation *annotation = view.annotation;
    coor = annotation.coordinate;
    self.anolongitude = [NSString stringWithFormat:@"%f",coor.longitude];
    self.anolatitude = [NSString stringWithFormat:@"%f",coor.latitude];
//    NSLog(@"..大头针拖动了....%f%f",coor.longitude,coor.latitude);
}
- (void)sureButtonClick{
    if ([self.addressField.text isEqualToString:@""]) {
        [self showHint:@"请填写具体地址"];
        return;
    }
    FXWorkPlaceDetailController *listVc = [[FXWorkPlaceDetailController alloc]init];
    listVc.delegate = self;
    listVc.longitudeStr = self.anolongitude;
    listVc.latitude = self.anolatitude;
    listVc.placeString = self.addressField.text;
    [self.navigationController pushViewController:listVc animated:YES];
}

//代理
- (void)detailPlaceWith:(NSString *)detailPlace WithLng:(NSString *)lng WithLat:(NSString *)lat{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setWorkPlaceWith:WithLng:WithLat:)]) {
        [self.delegate setWorkPlaceWith:detailPlace WithLng:lng WithLat:lat];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
