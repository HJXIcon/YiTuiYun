//
//  FXTodayTaskMapDetailController.m
//  yituiyun
//
//  Created by fx on 16/12/6.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXTodayTaskMapDetailController.h"
#import "CCLocationManager.h"
#import "FXLongitudeLatitudeModel.h"

@interface FXTodayTaskMapDetailController ()<BMKMapViewDelegate>

@end

@implementation FXTodayTaskMapDetailController{
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地推地图";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self setUpViews];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpViews{
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64)];
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
    
    if (![ZQ_CommonTool isEmptyArray:self.dataArray]) {
        CLLocationCoordinate2D coords[self.dataArray.count];
        
        for (int j = 0; j < self.dataArray.count; j++) {
            FXLongitudeLatitudeModel *model = _dataArray[j];
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
        for (NSInteger i = 0; i < _dataArray.count; i++) {
            [textureIndex addObject:[NSNumber numberWithInteger:i]];
        }
        BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coords count:_dataArray.count textureIndex:textureIndex];
        [_mapView addOverlay:polyline];
    }
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
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapDetail"];
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
//点击大头针 弹出或收起气泡
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //    NSLog(@"点击了大头针");
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
