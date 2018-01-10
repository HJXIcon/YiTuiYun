//
//  FXMapDetailController.m
//  yituiyun
//
//  Created by fx on 16/11/30.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXMapDetailController.h"
#import "CCLocationManager.h"
#import "FXPersonDetailController.h"
#import "FXLongitudeLatitudeModel.h"

@interface FXMapDetailController ()<BMKMapViewDelegate>

@end

@implementation FXMapDetailController{
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
//    [self setupLocation];
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
    
    for (int i = 0; i < self.dataArray.count; i++) {
        FXLongitudeLatitudeModel *model = _dataArray[i];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.latitudeStr doubleValue];
        coor.longitude = [model.longitudeStr doubleValue];
        annotation.coordinate = coor;
        annotation.title = model.titleStr;
        [_mapView addAnnotation:annotation];
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
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    for (FXLongitudeLatitudeModel *model in self.dataArray) {
        CLLocationCoordinate2D coor = view.annotation.coordinate;
        if (([model.latitudeStr doubleValue] == coor.latitude) && ([model.longitudeStr doubleValue] == coor.longitude)) {
            FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:model.pointId];
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
