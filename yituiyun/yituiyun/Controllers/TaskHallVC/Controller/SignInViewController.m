//
//  SignInViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "SignInViewController.h"
#import "ProjectModel.h"
#import "CCLocationManager.h"

@interface SignInViewController ()<BMKMapViewDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    CLLocationManager *_manager;
    BMKMapView *_mapView;
    BMKPointAnnotation *_annotation;
    
}

@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) UIView *mapBackView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, assign) NSInteger rotatNum;
@property (nonatomic, strong) NSMutableDictionary *locationDic;

@property(nonatomic,strong) BMKLocationService * locaServer;

/** */
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
/**地址 */
@property(nonatomic,strong) NSString * localaddress;

/**经纬度 */
@property(nonatomic,assign)CLLocationCoordinate2D  coor;
@end

@implementation SignInViewController

-(BMKLocationService *)locaServer{
    if (_locaServer == nil) {
        _locaServer = [[BMKLocationService alloc]init];
        _locaServer.delegate = self;
    }
    return _locaServer;
}

-(BMKGeoCodeSearch *)searcher{
    if (_searcher == nil) {
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
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
    _searcher.delegate = nil;
    _locaServer.delegate = nil;
}

- (instancetype)initWithProjectModel:(ProjectModel *)projectModel{
    self = [super init];
    if (self) {
        self.model = projectModel;
        self.locationDic = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 定位
- (void)setupLocation
{
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        #ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
           
            
        }
#endif
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locaServer startUserLocationService];
        } else{
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}


#pragma mark - 百度地图定位的

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //发起反向地理编码检索
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint =userLocation.location.coordinate;
    
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    self.coor = userLocation.location.coordinate;
    
    
    _annotation.coordinate = userLocation.location.coordinate;
    _mapView.centerCoordinate = userLocation.location.coordinate;//设置此位置为中心点
    [_mapView addAnnotation:_annotation];

    
    if(flag)
    {
    }
    else
    {
    }
    
    [self.locaServer stopUserLocationService];
    
}
#pragma mark--- 地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {

          self.localaddress =  result.address;
         _addressLabel.text = result.address;
     
    }
    else {
        
        [self showHint:@"定位失败"];
        
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.localaddress = @"";
    _annotation = [[BMKPointAnnotation alloc] init];
    
    [self setupNav];
    [self setUpHeaderView];
    [self setUpFooterView];
    [self setUpMapView];
    [self setupLocation];
}

#pragma mark - setupNav
- (void)setupNav{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    self.title = @"签到";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 100)];
    view.backgroundColor = kUIColorFromRGB(0xf16156);
    [self.view addSubview:view];
    
    UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(20, 10, ZQ_Device_Width - 40, CGRectGetHeight(view.frame) - 20)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 4;
    view1.layer.masksToBounds = YES;
    [view addSubview:view1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view1.frame), 20)];
    label.text = @"当前任务";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), CGRectGetWidth(view1.frame), 40)];
    label1.text = _model.projectName;
    label1.numberOfLines = 2;
    label1.textColor = kUIColorFromRGB(0x404040);
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label1];
}

- (void)setUpFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 64 - 120, ZQ_Device_Width, 120)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"position"]];
    imageV.frame = ZQ_RECT_CREATE(12, 25, 20, 20);
    [view addSubview:imageV];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(imageV.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(imageV.frame) - 52, 70)];
    _addressLabel.textColor = kUIColorFromRGB(0x404040);
    _addressLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:_addressLabel];

    UIButton *refreshButton = [[UIButton alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 32, CGRectGetMinY(imageV.frame), CGRectGetWidth(imageV.frame), CGRectGetHeight(imageV.frame))];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:refreshButton];
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    signInButton.frame = CGRectMake(12, 70, ZQ_Device_Width - 24, 40);
    signInButton.backgroundColor = kUIColorFromRGB(0xf16156);
    signInButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [signInButton addTarget:self action:@selector(signInButtonClick) forControlEvents:UIControlEventTouchUpInside];
    signInButton.layer.cornerRadius = 3;
    signInButton.layer.masksToBounds = YES;
    [signInButton setTitle:@"任务签到" forState:UIControlStateNormal];
    [signInButton setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [view addSubview:signInButton];
}

- (void)setUpMapView
{
    self.mapBackView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 100, ZQ_Device_Width, ZQ_Device_Height - 100 - 64 - 120)];
    _mapBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mapBackView];

    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, _mapBackView.frame.size.width, _mapBackView.frame.size.height)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:18];//设置缩放比
    [_mapBackView addSubview:_mapView];
}

#pragma mark 地图
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        newAnnotationView.frame = ZQ_RECT_CREATE(0, 0, 40, 40);
        newAnnotationView.backgroundColor = [UIColor clearColor];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.draggable = YES;//可拖动
        newAnnotationView.image = [UIImage imageNamed:@"mappoint.png"];
        return newAnnotationView;
    }
    return nil;
}

//大头针开始滑动
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    
    if (newState == BMKAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D coor;
        BMKPointAnnotation *annotation = view.annotation;
        coor = annotation.coordinate;
        NSString *longitude = [NSString stringWithFormat:@"%f",coor.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%f",coor.latitude];
        
    }
}

//刷新地址
- (void)refreshButtonClick:(UIButton *)button
{
    self.rotatNum = 0;
    [self rotating:button];
    
    [self.locaServer startUserLocationService];
}

//旋转
- (void)rotating:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        _rotatNum ++;
        view.transform = CGAffineTransformRotate(view.transform, M_PI);
    } completion:^(BOOL finished) {
        if (_rotatNum <= 3) {
            [self rotating:view];
        }
    }];
}

//签到
- (void)signInButtonClick{
    
    if ([self.localaddress isEqualToString:@""] || self.coor.longitude == 0 || self.coor.latitude == 0) {
        [self showHint:@"点击重新定位按钮"];
        return;
    }

        MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"uid"]=model.userID;
    parm[@"demandid"]=_model.projectId;
    parm[@"address"] = self.localaddress;
    parm[@"lat"] = @(self.coor.latitude);
    parm[@"lng"] = @(self.coor.longitude);
    
    [XKNetworkManager POSTToUrlString:TaskQianDao parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        if ([dict[@"errno"] integerValue] ==0) {
            //成功
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"签到成功"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     if (weakSelf.tiaoBlock) {
                         weakSelf.tiaoBlock();
                     }

                     [weakSelf leftBarButtonItem];
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

            
        }else{
            
            //失败
            [weakSelf showHint:dict[@"errmsg"]];
        }
        
        
    } failure:^(NSError *error) {
        
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
}


@end
