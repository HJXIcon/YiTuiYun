//
//  ProjectDetailViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ProjectDetailViewController.h"
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
#import "CCLocationManager.h"
#import "FXLongitudeLatitudeModel.h"
#import "FXPersonDetailController.h"
#import "FXCompanyInfoController.h"
#import "ChatViewController.h"
#import "FXMapDetailController.h"
#import "TaskDetailViewController.h"
#import "ProjectDetailDescCell.h"
#import "FistProjectSectionView.h"
#import "CompanyPublishTwofortw0Cell.h"
#import "UploadImageModel.h"
#import "ShowImageViewController.h"
#import "LHKNearSellerViewController.h"
#import "LHKMapAnoModel.h"
#import "PdfTableCell.h"
#import "PdfShowVc.h"
#import "OrderPayVc.h"
#import "UIViewController+PhotoBrowser.h"


#define kButtonTag 30000

@interface ProjectDetailViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,FirstProjectOrTaskDetailCellDelegate,CompanyPublishTwofortw0CellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FirstProjectOrTaskDetailCell *firstDetailCell;
@property (nonatomic, strong) SecondProjectOrTaskDetailCell *secondDetailCell;
@property (nonatomic, copy) NSString *dataId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) ZQImageAndLabelButton *collectionButton;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, strong) NSMutableArray *pointArray;

@property(nonatomic,strong) FistProjectSectionView * headView;
@property (nonatomic, strong) NSMutableDictionary *locationDic;

@property (nonatomic, copy) NSString *myLon;
@property (nonatomic, copy) NSString *myLat;
/** */
@property(nonatomic,strong) BMKMapView * mapView;
@property(nonatomic,strong) NSMutableArray * stepArrays;

@property(nonatomic,strong) BMKLocationService * localserver;

@property(nonatomic,strong) NSMutableArray * datas;
@property(nonatomic,strong) NSString * status;
@property(nonatomic,strong) NSString * applyStop;

@property(nonatomic,assign)BOOL isbackToRootViewController;
@end

@implementation ProjectDetailViewController
{
    CLLocationManager *_manager;

}
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
    if (_stepArrays ==nil) {
        _stepArrays = [NSMutableArray array];
    }
    return _stepArrays;
}

-(BMKMapView *)mapView{
    if (_mapView == nil) {
      
        
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 250)];
        _mapView.delegate = self;
        [_mapView setZoomLevel:16];//设置缩放比
        _mapView.gesturesEnabled = NO;
        
//        _mapView.showMapScaleBar = YES;

    }
    return _mapView;
}
-(FistProjectSectionView *)headView{
    if (_headView == nil) {
        _headView = [FistProjectSectionView sectionView];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 195);
    }
    return _headView;
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
    [self dataArrayFromNetwork];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    
    if (self.isbackToRootViewController) {
        self.isbackToRootViewController = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dataArrayFromNetwork
{
    __weak ProjectDetailViewController *weakSelf = self;
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
            
            NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"rst"][@"status"]];
            weakSelf.status = status;
            
            NSString *stop = [NSString stringWithFormat:@"%@",responseObject[@"rst"][@"applyStop"]];
            self.applyStop = stop;
            
            [weakSelf setupTableView];
            NSDictionary *subDic = [responseObject objectForKey:@"rst"];
            
            
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
            
            
            
            
            
            
            
            
            if (![ZQ_CommonTool isEmptyDictionary:subDic]) {
                
                //lhkd第二次新增
                //名称
                weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@",subDic[@"projectName"]];
                //价格
                weakSelf.headView.priceLabel.text = [NSString stringWithFormat:@"%@",subDic[@"wn"]];
                //判断tags
                NSArray *tagsArrayNew = subDic[@"tags"];
                if (tagsArrayNew.count == 0) {
                    
                    weakSelf.headView.fenjieLabel.hidden = YES;
                    weakSelf.headView.timeLabel.hidden = YES;
                    weakSelf.headView.tagsLabel.hidden = YES;
                    weakSelf.headView.notagsTimeLabel.hidden = NO;
                    weakSelf.headView.notagsTimeLabel.text = [NSString stringWithFormat:@"截止至%@",subDic[@"endDate"]];
                    
                    
                    
                }else{
                    weakSelf.headView.fenjieLabel.hidden = NO;
                    weakSelf.headView.timeLabel.hidden = NO;
                    weakSelf.headView.tagsLabel.hidden = NO;
                    weakSelf.headView.notagsTimeLabel.hidden = YES;
                    
                    NSMutableString *tempstring = [NSMutableString string];
                    for (NSString *str in tagsArrayNew) {
                        [tempstring appendString:str];
                    }
                    
                    weakSelf.headView.tagsLabel.text = tempstring;
                    weakSelf.headView.timeLabel.text =[NSString stringWithFormat:@"截止%@",subDic[@"endDate"]];
                    
                }
                
                //价格
                _model.price = [NSString stringWithFormat:@"%@",subDic[@"price"]];
                
                //ID
                
                _model.demandid = [NSString stringWithFormat:@"%@",subDic[@"demandid"]];
                
                //剩余单量
                weakSelf.headView.shengyuLable.text = [NSString stringWithFormat:@"%@",subDic[@"surplus_single"]];
                
                //接单量
                weakSelf.headView.jiedanLabel.text = [NSString stringWithFormat:@"%@",subDic[@"count"]];
                
                //成单量
                weakSelf.headView.chengdanLabel.text = [NSString stringWithFormat:@"%@",subDic[@"complete_count"]];
                
                
                _model.projectId = [NSString stringWithFormat:@"%@", subDic[@"demandid"]];
                _model.memberid = [NSString stringWithFormat:@"%@", subDic[@"memberid"]];
                _model.projectName = [NSString stringWithFormat:@"%@", subDic[@"projectName"]];
                //lhk新增
                _model.projectDesc = [[NSString stringWithFormat:@"%@", subDic[@"desc"]] stringIsNull];
                
                _model.projectTarget_clients = [[NSString stringWithFormat:@"%@", subDic[@"taget_clients"]] stringIsNull];

                _model.project_advantage = [[NSString stringWithFormat:@"%@", subDic[@"project_advantage"] ] stringIsNull];
                
                
                _model.project_materials_needed = [[NSString stringWithFormat:@"%@", subDic[@"materials_needed"]] stringIsNull];
                
                
                _model.project_explain = [[NSString stringWithFormat:@"%@", subDic[@"explain"]] stringIsNull];
                _model.Cityarray = subDic[@"citysArr"];
                
                _model.projectTime = [NSString stringWithFormat:@"%@", subDic[@"timeTypeStr"]];
                _model.projectPrice = [NSString stringWithFormat:@"%@", subDic[@"wn"]];
                _model.isCollection = [NSString stringWithFormat:@"%@", subDic[@"isCollect"]];
                _model.projectPhone = [NSString stringWithFormat:@"%@", subDic[@"mobile"]];
                _model.isget = [NSString stringWithFormat:@"%@", subDic[@"isget"]];
                _model.timeType = [NSString stringWithFormat:@"%@", subDic[@"timeType"]];
                _model.single = [NSString stringWithFormat:@"%@", subDic[@"okNum"]];
                _model.number = [NSString stringWithFormat:@"%@", subDic[@"getNum"]];
                _model.promotion = [NSString stringWithFormat:@"%@", subDic[@"num"]];
                _model.taskType = [NSString stringWithFormat:@"%@", subDic[@"t"]];
                _model.myTaskStatus = [NSString stringWithFormat:@"%@", subDic[@"myTastStatus"]];
                _model.isAdress = @"1";
                _model.tagArray = [NSMutableArray array];
                [_model.tagArray addObjectsFromArray:subDic[@"tags"]];
                _model.positionArray = [NSMutableArray array];
                [_model.positionArray addObjectsFromArray:subDic[@"setting"]];
                _model.adressArray = [NSMutableArray array];
                [_model.adressArray addObjectsFromArray:subDic[@"citysArr"]];
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
                
                
                [weakSelf setFooterView];
                
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
//
#ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//            [_manager requestWhenInUseAuthorization];
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
    self.mapView.centerCoordinate = myCoor;//设置此位置为中心点
    [self.mapView addAnnotation:myAnnotation];
    
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

- (void)GetPointArrayData:(NSDictionary *)dic
{
    __weak ProjectDetailViewController *weakSelf = self;
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
    
        
    [self setUpNavigation];
//    [self setupTableView];
    
    self.model = [[ProjectModel alloc] init];
    [self setupLocation];
    self.view.backgroundColor =UIColorFromRGBString(@"0xededed");

}



#pragma mark - setUpNavigation
- (void)setUpNavigation{
    
    self.title = @"项目详情";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"ic03" selectedImage:@"ic03" target:self action:@selector(rightBarButtonItemClick:)];
//    
    UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
        
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    [rightbtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightbtn setImage:[UIImage imageNamed:@"ic03"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:UIColorFromRGBString(@"0xf16156")]];
    
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
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemClick:(UIButton *)button
{
    [self showHudInView:self.view hint:@"加载中..."];
    __weak ProjectDetailViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"share";
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=data.config"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
      
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        model.shareTitle = [NSString stringWithFormat:@"%@", responseObject[@"shareTitle"]];
        model.shareDescription = [NSString stringWithFormat:@"%@", responseObject[@"shareDescription"]];
        model.shareImg = [NSString stringWithFormat:@"%@%@", kHost, responseObject[@"shareImg"]];
        model.shareUrl = [NSString stringWithFormat:@"%@index.php?m=default.download", kHost];
        [ZQ_AppCache save:model];
        [weakSelf share:button];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)share:(UIButton *)button{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [SSUIShareActionSheetStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    [SSUIShareActionSheetStyle setActionSheetColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setItemNameColor:kUIColorFromRGB(0x777777)];
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:11]];
    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setCancelButtonLabelColor:kUIColorFromRGB(0x666666)];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:model.shareDescription
                                     images:@[model.shareImg]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.shareUrl]]
                                      title:model.shareTitle
                                       type:SSDKContentTypeAuto];
    
    
    [shareParams SSDKSetupQQParamsByText:model.shareDescription
                                   title:model.shareTitle
                                     url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.shareUrl]]
                              thumbImage:[NSURL URLWithString:model.shareImg]
                                   image:nil
                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatFav),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
    //2、分享
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:button
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

- (void)setupTableView{
    
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64 - 44) style:UITableViewStyleGrouped];
            [self.tableView setDelegate:(id<UITableViewDelegate>) self];
            [self.tableView setDataSource:(id<UITableViewDataSource>) self];
            [self.tableView setShowsVerticalScrollIndicator:NO];
            self.tableView.backgroundColor = [UIColor clearColor];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.tableHeaderView = self.headView;
        
            //注册
            [self.tableView registerNib:[UINib nibWithNibName:@"ProjectDetailDescCell" bundle:nil] forCellReuseIdentifier:@"desc"];
        
            [self.tableView registerNib:[UINib nibWithNibName:@"CompanyPublishTwofortw0Cell" bundle:nil] forCellReuseIdentifier:@"CompanyPublishTwofortw0Cell"];
            self.tableView.estimatedRowHeight = 100;
        
        
        [self.tableView registerNib:[UINib nibWithNibName:@"PdfTableCell" bundle:nil] forCellReuseIdentifier:@"PdfTableCell"];

    }
    return _tableView;
}


#pragma mark - footView

- (void)setFooterView
{
    [self.footerView removeAllSubviews];
    [self.footerView removeFromSuperview];
    self.collectionButton = nil;
    self.operationButton = nil;
    self.footerView = nil;
    
    switch ([_type integerValue]) {
        case 6:
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.collectionButton = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, 100, 44)];
            if ([_model.isCollection isEqualToString:@"1"]) {
                _collectionButton.imageV.image = [UIImage imageNamed:@"project_shoucang_yes"];
                _collectionButton.label.text = @"已收藏";
                _collectionButton.label.textColor = kUIColorFromRGB(0xffaf31);
            } else {
                _collectionButton.imageV.image = [UIImage imageNamed:@"project_shoucang_no"];
                _collectionButton.label.text = @"收藏";
                _collectionButton.label.textColor = kUIColorFromRGB(0x808080);
            }
            _collectionButton.imageV.frame = ZQ_RECT_CREATE(15, 9, 20, 20);
            _collectionButton.label.font = [UIFont systemFontOfSize:15];
            _collectionButton.label.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_collectionButton.imageV.frame) + 10, 0, CGRectGetWidth(_collectionButton.frame) - CGRectGetMaxX(_collectionButton.imageV.frame) - 10, 44);
            [_collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_footerView addSubview:_collectionButton];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_collectionButton.frame), 0, ZQ_Device_Width - CGRectGetMaxX(_collectionButton.frame) , 44);
            _operationButton.tag = kButtonTag + [_type integerValue];
//            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            if ([_model.isget integerValue] == 1) {
//                if ([_model.taskType integerValue] == 2) {
                    _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
                    [_operationButton setTitle:@"去接单" forState:UIControlStateNormal];
                    _operationButton.userInteractionEnabled = YES;
                    [_operationButton addTarget:self action:@selector(continueClick) forControlEvents:(UIControlEventTouchUpInside)];
//                } else {
//                    _operationButton.backgroundColor = kUIColorFromRGB(0xcccccc);
//                    [_operationButton setTitle:@"任务已领取" forState:UIControlStateNormal];
//                    _operationButton.userInteractionEnabled = NO;
//                }
            } else {
                _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
                [_operationButton setTitle:@"领取任务" forState:UIControlStateNormal];
                _operationButton.userInteractionEnabled = YES;
                [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            [_footerView addSubview:_operationButton];
        }
            break;
        case 5:
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            self.collectionButton = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, 100, 44)];
            if ([_model.isCollection isEqualToString:@"1"]) {
                _collectionButton.imageV.image = [UIImage imageNamed:@"project_shoucang_yes"];
                _collectionButton.label.text = @"已收藏";
                _collectionButton.label.textColor = kUIColorFromRGB(0xffaf31);
            } else {
                _collectionButton.imageV.image = [UIImage imageNamed:@"project_shoucang_no"];
                _collectionButton.label.text = @"收藏";
                _collectionButton.label.textColor = kUIColorFromRGB(0x808080);
            }
            _collectionButton.imageV.frame = ZQ_RECT_CREATE(15, 9, 20, 20);
            _collectionButton.label.font = [UIFont systemFontOfSize:15];
            _collectionButton.label.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_collectionButton.imageV.frame) + 10, 0, CGRectGetWidth(_collectionButton.frame) - CGRectGetMaxX(_collectionButton.imageV.frame) - 10, 44);
            [_collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_footerView addSubview:_collectionButton];
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_collectionButton.frame), 0, ZQ_Device_Width - CGRectGetMaxX(_collectionButton.frame) , 44);
            _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
            _operationButton.tag = kButtonTag + [_type integerValue];
//            _operationButton.layer.cornerRadius = 4;
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_operationButton setTitle:@"企业合作" forState:UIControlStateNormal];
            [_operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_footerView addSubview:_operationButton];
        }
            break;
            
            case 11: //企业发布的需求
        {
            self.footerView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 108, ZQ_Device_Width, 44)];
            _footerView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_footerView];
            
            
            self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _operationButton.frame = CGRectMake(0, 0, ScreenWidth , 44);
            _operationButton.backgroundColor = kUIColorFromRGB(0xf16156);
           
            
            _operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_operationButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
         
            if([self.status isEqualToString:@"7"]){
                
            [_operationButton setTitle:@"重新开始" forState:UIControlStateNormal];
                 _footerView.hidden = NO;
                
                [_operationButton addTarget:self action:@selector(startNeeds) forControlEvents:(UIControlEventTouchUpInside)];
                [_footerView addSubview:_operationButton];
                
            }else if ([self.status isEqualToString:@"8"]){
                [_operationButton setTitle:@"重新开始" forState:UIControlStateNormal];
                _footerView.hidden = NO;
                [_operationButton addTarget:self action:@selector(startNeeds) forControlEvents:(UIControlEventTouchUpInside)];
                [_footerView addSubview:_operationButton];

                
            } else if ([self.applyStop isEqualToString:@"1"]) {
                [_operationButton setTitle:@"申请停止中" forState:UIControlStateNormal];
                _operationButton.userInteractionEnabled = NO;
                _operationButton.backgroundColor =[UIColor lightGrayColor];
                 [_footerView addSubview:_operationButton];
                
                
            }
            else if ([self.status isEqualToString:@"6"]) {
                [_operationButton setTitle:@"停止需求" forState:UIControlStateNormal];
                
                [_operationButton addTarget:self action:@selector(taskNeedClick:) forControlEvents:(UIControlEventTouchUpInside)];
                [_footerView addSubview:_operationButton];

            }
            
            
            
        }

        
            break;
            
        default:
            break;
    }
}

#pragma mark -开始
-(void)startNeeds{
   
    
    OrderPayVc *addvc = [[OrderPayVc alloc]init];
    
    addvc.addprice = _model.price;
    addvc.addProjectName = _model.projectName;
    addvc.demanID = _model.demandid;
    addvc.isAddOrder = YES;
    addvc.isModifyPrice = YES;
    addvc.navigationItem.title = @"添加单量";
    self.isbackToRootViewController = YES;
    [self.navigationController pushViewController:addvc animated:YES];


    
}

-(void)taskNeedClick:(UIButton *)btn{
    
    MJWeakSelf
    LHKAlterView *myalterview = [LHKAlterView alterViewWithTitle:@"停止需求" andDesc:@"是否停止需求" WithCancelBlock:^(LHKAlterView *alterView) {
        
        [alterView removeFromSuperview];
    } WithMakeSure:^(LHKAlterView *alterView) {
        [weakSelf stopNeeds];
        [alterView removeFromSuperview];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:myalterview];
    
    
}

-(void)stopNeeds{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"demandid"] = self.dataId;
    dict[@"applyStop"] = @"1";
    [XKNetworkManager POSTToUrlString:CompanyNeedStop parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        
        if([code isEqualToString:@"0"]) {
            [self showHint:@"取消成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:@"取消失败失败"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showHint:error.localizedDescription];
    }];

    
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

#pragma mark - CompanyPublishTwofortw0CellDelegate
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
    MJWeakSelf
    
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
//            if (indexPath.row == 0) {
//                cell1.nameLabel.text = @"人员要求：";
//                cell1.iconImageView.image = [UIImage imageNamed:@"project_yaoqiu"];
//                [cell1.listArray removeAllObjects];
//                [cell1.listArray addObjectsFromArray:self.model.personnelArray];
//                [cell1 btnLayOut];
//            }
//        } else {
            if (indexPath.row == 0) {
                ProjectDetailDescCell *celllhk = [self.tableView dequeueReusableCellWithIdentifier:@"desc"];
                
                celllhk.targetLabel.text = self.model.projectTarget_clients;
                celllhk.descLabel.text = self.model.projectDesc;
                celllhk.advantageLabel.text = self.model.project_advantage;
                celllhk.needsLabel.text = self.model.project_materials_needed;
                celllhk.explainLabel.text = self.model.project_explain;
                celllhk.selectionStyle = UITableViewCellSelectionStyleNone;

                return celllhk;
                
                
            }
            else if (indexPath.row == 1) {
                cell1.nameLabel.text = @"人员要求：";
                [cell1.listArray removeAllObjects];
                [cell1.listArray addObjectsFromArray:self.model.personnelArray];
                [cell1 btnLayOut];
            }
//        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.accessoryType = UITableViewCellAccessoryNone;
        return cell1;
    }else if (indexPath.section == 2){
        PdfTableCell *pdfcell = [self.tableView dequeueReusableCellWithIdentifier:@"PdfTableCell"];
        pdfcell.selectionStyle = UITableViewCellSelectionStyleNone;

        pdfcell.shareblock = ^{
            
            if ([NSURL URLWithString:_model.pdfStr] == nil) {
                 [weakSelf showHint:@"服务器返回的url不正确"];
            }else{
                
                [self shareWithpdf:_model.pdfStr andPdfname:_model.pdfName];
                    
            }
            
            
        };
        pdfcell.readblock = ^{
            
           
            
            NSURL *cleanURL = [NSURL URLWithString:_model.pdfStr];
            
            if (cleanURL == nil) {
                [weakSelf showHint:@"服务器返回的url不正确"];
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
        twoCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        return twoCell;
        
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectDetailViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectDetailViewController"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.contentView addSubview:self.mapView];
    
    
    
    
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
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ProjectDetail"];
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
    //    NSLog(@"-----地图停止滑动了-----");
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
    //设置动画速率
    NSArray *array = @[kCAMediaTimingFunctionLinear,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionEaseInEaseOut,kCAMediaTimingFunctionDefault];
    //设置动画的运动方式
    ani.timingFunction = [CAMediaTimingFunction functionWithName:array[0]];
    
    //动画出现方向
    NSArray *array1 = @[kCATransitionFromLeft,kCATransitionFromRight,kCATransitionFromTop,kCATransitionFromBottom];
    NSArray *array2 = @[@"90cw",@"90ccw",@"180cw",@"180ccw"];
    
    //设置动画从哪个方向出现
    ani.subtype = array1[1];
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
    return 0.0001;
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
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _firstDetailCell.cellHight;
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return UITableViewAutomaticDimension;
        }else{

            
            return _secondDetailCell.cellHight;
        }
        
    }else if (indexPath.section == 2){
        return 44;
    }else if (indexPath.section == 3){
        return UITableViewAutomaticDimension;
    }
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 3 || section == 4) {
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
            imageV.image = [UIImage imageNamed:@"project_workdesc"];
        } else if (section == 4) {
//            label.text = @"地推地图";
            label.text = @"已推广商家";
            imageV.image = [UIImage imageNamed:@"project_dituiditu"];
        }else if (section ==3 ){
            label.text = @"任务步骤";
            imageV.image = [UIImage imageNamed:@"company_renwubuzhou"];
        }
        
        return view;
    }
    return nil;
}

//操作点击
- (void)operationButtonClick:(UIButton *)button{
    switch (button.tag - kButtonTag) {
        case 6:
        {
            if ([_model.isget integerValue] == 1) {
                [ZQ_UIAlertView showMessage:@"此任务已经领取过了" cancelTitle:@"知道了"];
            } else {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"您要领取此项目？"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1) {
                         [self judgeInfoStatus:1];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            }
        }
            
            break;
        case 5:
        {
            UserInfoModel *model = [ZQ_AppCache userInfoVo];
            if ([_model.memberid integerValue] == [model.userID integerValue]) {
                [ZQ_UIAlertView showMessage:@"不能跟企业自己进行合作" cancelTitle:@"知道了"];
            } else {
                [WCAlertView showAlertWithTitle:@"企业合作"
                                        message:[NSString stringWithFormat:@"简单沟通后再打电话，更容易促成合作哦！", _model.projectPhone]
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1) {
                         [self getUserInfo];
                     } else if (buttonIndex == 2) {
                         [self judgeInfoStatus:2];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"沟通一下", @"打电话", nil];
            }
        }
            
            break;
            
        default:
            break;
    }
}

- (void)getUserInfo{
    __weak ProjectDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uids"] = _model.memberid;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.avatars"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *rst = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:rst]) {
                NSDictionary *dic = rst[_model.memberid];
                RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:_model.memberid conversationType:EMConversationTypeChat];

//                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_model.memberid conversationType:EMConversationTypeChat];
                chatController.title = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
                chatController.avatarURLPath = [NSString stringWithFormat:@"%@", dic[@"avatar"]];
                [self.navigationController pushViewController:chatController animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

//收藏点击
- (void)collectionButtonClick:(ZQImageAndLabelButton *)button{
    __weak ProjectDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"did"] = _model.projectId;
    params[@"uid"] = model.userID;
    params[@"type"] = @"3";
    if ([_model.isCollection isEqualToString:@"1"]) {
        params[@"status"] = @"0";
    } else {
        params[@"status"] = @"1";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.collect"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            if ([_model.isCollection isEqualToString:@"1"]) {
                _model.isCollection = @"0";
                _collectionButton.imageV.image = [UIImage imageNamed:@"project_shoucang_no"];
                _collectionButton.label.text = @"收藏";
                [weakSelf showHint:@"已取消"];
                _collectionButton.label.textColor = kUIColorFromRGB(0x808080);
            } else {
                _model.isCollection = @"1";
                _collectionButton.imageV.image = [UIImage imageNamed:@"project_shoucang_yes"];
                _collectionButton.label.text = @"已收藏";
                [weakSelf showHint:@"已收藏"];
                _collectionButton.label.textColor = kUIColorFromRGB(0xffaf31);
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)judgeInfoStatus:(NSInteger)infoStatus
{
    if (infoStatus == 1) {
        [self getTask];//BD领取任务
    } else {
        [self businessCooperation];
    }
}

//去执行
- (void)continueClick
{
    TaskDetailViewController *vc = [[TaskDetailViewController alloc] initWithDataId:_model.projectId WithType:_model.myTaskStatus WithWhere:3];
    pushToControllerWithAnimated(vc)
}

#pragma mark - 领取任务

- (void)getTask
{
    __weak ProjectDetailViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([_model.isget integerValue] == 0) {
        params[@"t"] = @"0";
    } else if ([_model.isget integerValue] == 2) {
        params[@"t"] = @"1";
    }
    params[@"demandid"] = _model.projectId;
    params[@"memberid"] = model.userID;
    params[@"demandType"] = _model.taskType;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.addTask"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [MobClick event:@"getTaskNums"];
//            self.tabBarController.selectedIndex = 1;
//            [self.navigationController popToRootViewControllerAnimated:YES];
 [weakSelf dataArrayFromNetwork];
        
        } else if ([responseObject[@"errno"] intValue] == 2) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"您领取的任务数量已达到上限，如果您想要领取此任务，需要到任务大厅取消已领取的任务"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     self.tabBarController.selectedIndex = 1;
                     [self.navigationController popToRootViewControllerAnimated:YES];

                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"去大厅", nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

//企业合作
- (void)businessCooperation{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _model.projectPhone]]];
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
