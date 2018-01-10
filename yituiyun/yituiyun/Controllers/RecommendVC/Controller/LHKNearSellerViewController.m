//
//  LHKNearSellerViewController.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKNearSellerViewController.h"
#import "LHKMapAnnotation.h"
#import "LHKAnnotatiView.h"
#import "LHKMapAnoModel.h"
#import "LHKSellerWriteViewController.h"
#import "JXPopView.h"

@interface LHKNearSellerViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,LHKMapPopViewDelegate>

@property(nonatomic,assign)NSInteger where;

/**百度地图View */
@property(nonatomic,strong) BMKMapView * mapView;

/**定位locationView */
@property(nonatomic,strong) BMKLocationService * locservice;

/**重新定位的标志 */
@property(nonatomic,strong) UIButton *aginLocation;
/**返回原来的位置的经纬度*/
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;


/** 旋转角度 */
@property(nonatomic,assign)CGFloat currentAngle ;

/**数据源用来存放 商家信息的 */
@property(nonatomic,strong) NSMutableArray<LHKMapAnoModel*> * dataAray;

@property(nonatomic,assign)BOOL hasLocationRequest;

//上一次的lastCoor
@property(nonatomic,assign)CLLocationCoordinate2D lastCoor;


//上一次的lastCoor
@property(nonatomic,assign)BOOL isAgainBtnClick;





@end

@implementation LHKNearSellerViewController

-(NSMutableArray *)dataAray{
    if (_dataAray == nil) {
        _dataAray = [NSMutableArray array];
    }
    return _dataAray;
}
- (void)viewDidLoad {
    self.hasLocationRequest = NO;
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    
    [MobClick event:@"NearbymerchantsNums"];
}



- (instancetype)initWith:(NSInteger)where
{
    if (self = [super init]) {
    self.where = where;
    }
    return self;
}

- (IBAction)reloadNetwork:(id)sender {
}

#pragma lazy
-(BMKMapView *)mapView{
    if (_mapView == nil) {

        _mapView = [[BMKMapView alloc]init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;//先关闭显示的定位图层
        _mapView.minZoomLevel = 15;
        _mapView.maxZoomLevel = 19;
        
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
       
        
        
        BMKLocationViewDisplayParam *parm = [[BMKLocationViewDisplayParam alloc]init];
        parm.locationViewImgName = @"location_lhk";
        
        
        parm.isRotateAngleValid =YES;
        parm.isAccuracyCircleShow =NO;
        
        parm.locationViewOffsetX =0;
        parm.locationViewOffsetY =0;
        
        [_mapView updateLocationViewWithParam:parm];
        _mapView.showsUserLocation = YES;
        

        
    }
    return _mapView;
}

-(BMKLocationService *)locservice{
    if (_locservice == nil) {
        _locservice = [[BMKLocationService alloc]init];
        _locservice.distanceFilter =kCLLocationAccuracyHundredMeters;
        _locservice.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        
        _locservice.delegate = self;
        
    }
    
    
    return _locservice;
}

-(UIButton *)aginLocation{
    if(_aginLocation == nil){
        _aginLocation = [[UIButton alloc]initWithFrame:CGRectMake(5, ScreenHeight-80-64, 50, 50)];
        [_aginLocation setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateNormal];
        [_aginLocation setImage:[UIImage imageNamed:@"map_helight"] forState:UIControlStateHighlighted];
        [_aginLocation addTarget:self action:@selector(aginLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _aginLocation;

        
}

#pragma mark---aginLocation再次点击回到中心的方法
-(void)aginLocationBtnClick{
    
    self.isAgainBtnClick = YES;
    
   
        
    [self.mapView setCenterCoordinate:self.coordinate animated:YES];
        BMKCoordinateRegion region = BMKCoordinateRegionMake(self.coordinate, BMKCoordinateSpanMake(0.02, 0.02));
    [self getAnoimationFromServer:self.coordinate];
    [_mapView setRegion:region animated:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hasLocationRequest = NO;
    [self.locservice startUserLocationService];
}
#pragma mark--加载试图setupView

-(void)setupView{
    
    
    if ([XKNetworkManager networkStateChange]) {
        
         [self.view addSubview:self.mapView];
         [self.locservice startUserLocationService];
         [self.view addSubview:self.aginLocation];
      
    }else{
        
        [self showHint:@"网络不见了"];
    }

    
}

#pragma cllocation的代理方法

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    if (!self.hasLocationRequest) {
        
        //第一次的经纬度
        self.coordinate = userLocation.location.coordinate;

        

        [self getAnoimationFromServer:userLocation.location.coordinate];
        
        BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.05, 0.05));
        
        [self.mapView setRegion:region animated:YES];
        
        self.lastCoor = userLocation.location.coordinate;

    }

    
    
    [self.mapView updateLocationData:userLocation];
    
  

    

}

#pragma mark---处理服务器的地图标注数据
-(void)getAnoimationFromServer:(CLLocationCoordinate2D )coor{
    
    [_locservice startUserLocationService];

    [SVProgressHUD showWithStatus:@"寻找附近的商家.."];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        MJWeakSelf
        
        dict[@"lng"] =@(coor.longitude);
        dict[@"lat"] = @(coor.latitude);
        dict[@"t"] = @(2);
        
        
        
        [XKNetworkManager POSTToUrlString:GetNearySellerURL parameters:dict progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            
            weakSelf.dataAray = [LHKMapAnoModel objectArrayWithKeyValuesArray:dict[@"rst"]];
            
//            NSLog(@"%@--%ld",dict,weakSelf.dataAray.count);
            
            if (weakSelf.dataAray.count> 0) {
                
                NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
                [weakSelf.mapView removeAnnotations:array];
                [SVProgressHUD dismiss];

            }else{
                [SVProgressHUD dismiss];
                [weakSelf showHint:@"附近无商家"];
                return ;
                 }
            NSString *desc = [NSString stringWithFormat:@"附近有%ld家商家",weakSelf.dataAray.count];
            [weakSelf showHint:desc];
            
            [weakSelf.dataAray enumerateObjectsUsingBlock:^(LHKMapAnoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
              
                LHKMapAnnotation* annotation = [[LHKMapAnnotation alloc]init];
                annotation.dataModel = obj;
                annotation.coordinate = CLLocationCoordinate2DMake(obj.lat, obj.lng);
                annotation.title = obj.nickname;
                annotation.address = obj.address;
                annotation.tel = obj.mobile;
                annotation.imagePath = obj.avatar;
                
                [weakSelf.mapView addAnnotation:annotation];
                
            }];
            
            self.hasLocationRequest = YES;
            
            
        } failure:^(NSError *error) {
            
            [weakSelf showHint:error.localizedDescription];
            weakSelf.hasLocationRequest = NO;
            [SVProgressHUD dismiss];
        }];
        
        
    

    
}
#pragma mark--处理地位转向的问题

- (void)mapView:(BMKMapView*)mapView onDrawMapFrame:(BMKMapStatus*)status{
   
    [self setLocationViewAngle:_currentAngle];
    
    
}


#pragma mark用户方向更新调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation*)userLocation
{
    [_mapView updateLocationData:userLocation];
    CGFloat angle = userLocation.heading.magneticHeading*M_PI/180;
    _currentAngle= angle;
    [self setLocationViewAngle:_currentAngle];
}
#pragma mark设置定位图标的旋转角度
- (void)setLocationViewAngle:(CGFloat)angle{
    BMKAnnotationView*locationView = [_mapView valueForKey:@"_locationView"];
    if(locationView){
        locationView.transform=CGAffineTransformMakeRotation(_currentAngle);
    }
}
#pragma mark--mapView的代理方法 用来定义annotationView
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    
    if ([annotation isKindOfClass:[LHKMapAnnotation class]]) {
        
        LHKAnnotatiView *anoView = [LHKAnnotatiView annotationViewMapView:mapView withAnnotation:annotation];
        anoView.delegate = self;
     
        return anoView;
    }
    
    
    
    return nil;

}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    

    
    if (![XKNetworkManager networkStateChange]) {
        return;
    }
    
    if (self.isAgainBtnClick) {
        self.isAgainBtnClick = NO;
        return;
    }

    
    if (self.hasLocationRequest==NO) {
        return;
    }else{
        [_locservice stopUserLocationService];
    }
    
    CGFloat lat = fabs(self.lastCoor.latitude-self.mapView.region.center.latitude);
    CGFloat lnt = fabs(self.lastCoor.longitude - self.mapView.region.center.longitude);
    
    if (lat>0.04 || lnt>0.04) {

        [_locservice stopUserLocationService];

        [self getAnoimationFromServer:CLLocationCoordinate2DMake(self.mapView.region.center.latitude, self.mapView.region.center.longitude)];
        
        
    }
    self.lastCoor = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude);
  

}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    if ([view isKindOfClass:NSClassFromString(@"LocationView")]) {
        return;
    }
    LHKAnnotatiView  *anoview = (BMKAnnotationView *)view;
    view.image = [UIImage imageNamed:@"1"];
    
    
}
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    if ([view isKindOfClass:NSClassFromString(@"LocationView")]) {
        return;
    }
    
    LHKAnnotatiView  *anoview = (BMKAnnotationView *)view;
    
    
    view.image = [UIImage imageNamed:@"2"];

}
- (void)setupNav{
    self.title = @"已推广商家";
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemChangeLocationWithImage:@"shaixuan" title:@"筛选" target:self action:@selector(rightAction:)];

}

- (void)rightAction:(UIBarButtonItem *)sender{
    
    JXPopView *popView = [[JXPopView alloc]init];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:3];
    [popView showToPoint:CGPointMake(ScreenWidth - 60,  64) withTitles:@[@"dehihdai",@"dheihei",@"dheihei",@"dheihei",@"dheihei"] selectIndexSet:indexSet completion:^(NSMutableIndexSet *idxSet) {
        
        [idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop)
         {
             NSLog(@"%lu", (unsigned long)idx);
         }];
    }];
}

- (void)leftBarButtonItem{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewWillLayoutSubviews{
    
//    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    self.mapView.frame = self.view.bounds;
    
    

    
}
                     
//                              -(void)viewWillAppear:(BOOL)animated {
//                                  [_mapView viewWillAppear];
//                                  _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//                                  _locservice.delegate = self;
//                              }
//                              
//                              -(void)viewWillDisappear:(BOOL)animated {
//                                  [_mapView viewWillDisappear];
//                                  _mapView.delegate = nil; // 不用时，置nil
//                                  _locservice.delegate = nil;
//                              }


#pragma mark---MapPopViewDelegate

-(void)mapPopViewBtnClick:(LHKMapAnnotation *)model{
    
//    NSLog(@"------%@-----%@--%lf-%lf",model.title,model.address,model.dataModel.lat,model.dataModel.lng);
    LHKSellerWriteViewController *sellerVc = [[LHKSellerWriteViewController alloc]initWith:2];
    sellerVc.model = model.dataModel;
    
    [self.navigationController pushViewController:sellerVc animated:YES];
}


@end
