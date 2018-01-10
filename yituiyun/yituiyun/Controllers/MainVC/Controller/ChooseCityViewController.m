//
//  ChooseCityViewController.m
//  同门艺人
//
//  Created by NIT on 16/8/26.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "ChooseOtherCityViewController.h"
#import "CCLocationManager.h"
#import "ChooseCityCell.h"


@interface ChooseCityViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,ChooseOtherCityViewControllerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIAlertViewDelegate>
{
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *GPSArray;
@property (nonatomic, strong) ChooseCityCell *cityCell;
@property (nonatomic, copy) NSString *positioningString;
@property (nonatomic, assign) NSInteger where;

/**地理编码*/
@property(nonatomic,strong) BMKGeoCodeSearch *searcher;
/**location */
@property(nonatomic,strong) BMKLocationService * locaserver;


@end

@implementation ChooseCityViewController

- (id)initWithPositioningString:(NSString *)positioningString WithWhere:(NSInteger)where
{
    self = [super init];
    if (self) {
        self.positioningString = positioningString;
        self.dataArray = [NSMutableArray array];
        self.GPSArray = [NSMutableArray array];
        self.where = where;
    }
    return self;
}

#pragma mark---lazy

-(BMKGeoCodeSearch *)searcher{
    if (_searcher == nil) {
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}

-(BMKLocationService *)locaserver{
    if (_locaserver == nil) {
        _locaserver =[[BMKLocationService alloc]init];
        _locaserver.delegate = self;
    }
    return _locaserver;
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
            
            [self.locaserver startUserLocationService];
        } else{
            NSDictionary *dicc = @{@"latitude":@"0.0", @"longitude":@"0.0",@"province":@"无法定位当前城市",@"city":@""};
            [_GPSArray removeAllObjects];
            [_GPSArray addObject:dicc];
            [_tableView reloadData];
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        NSDictionary *dicc = @{@"latitude":@"0.0", @"longitude":@"0.0",@"province":@"无法定位当前城市",@"city":@""};
        [_GPSArray removeAllObjects];
        [_GPSArray addObject:dicc];
        [_tableView reloadData];
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
  
}

#pragma mark BMKLocationDelegate

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //发起反向地理编码检索
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint =userLocation.location.coordinate;
//        reverseGeoCodeSearchOption.reverseGeoPoint =CLLocationCoordinate2DMake(39.898032,116.403616 );
    
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        
    }
    
    [self.locaserver stopUserLocationService];
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        NSString *resuProvic= @"";
        NSString *resuCity = @"";

        NSString *province = result.addressDetail.province;
        NSString *city = result.addressDetail.city;
        NSString *disct = result.addressDetail.district;
        
        if ([province isEqualToString:city]) {
            resuProvic = city;
            resuCity = disct;
        }else{
            resuProvic = province;
            resuCity = city;
        }
        
        NSDictionary *dicc = @{@"latitude":@(result.location.latitude), @"longitude":@(result.location.longitude),@"dataid":@(100),@"province":resuProvic,@"city":resuCity};
        
        
        [_GPSArray removeAllObjects];
        [_GPSArray addObject:dicc];
        [_tableView reloadData];

        
    }
    else {
        
        [self showHint:@"定位城市失败"];
        
        
    }
    
   
    
}




//获取数据
- (void)sendRequestGet
{
    __weak ChooseCityViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyid"] = @"1";
    params[@"parentid"] = @"0";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=linkage.get"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        NSArray *array = responseObject;
        if (![ZQ_CommonTool isEmptyArray:array]) {
            for (NSDictionary *dic in array) {
                [_dataArray addObject:dic];
                
                
            }
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败,请重试" yOffset:-200];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    
    if (_where == 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"×_icon" selectedImage:@"×_icon" target:self action:@selector(leftBarButtonItem)];
    }
    
    [self setupTableView];
    [self sendRequestGet];
    [self setupLocation];
}

- (void)leftBarButtonItem{
    if ([self.delegate respondsToSelector:@selector(defaultCitySelect)]) {
        [self.delegate defaultCitySelect];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _GPSArray.count;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChooseCityCell";
    ChooseCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChooseCityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    NSString *string = nil;
    if (indexPath.section == 0) {
        NSDictionary *dic = _GPSArray[indexPath.row];
        string = [NSString stringWithFormat:@"%@%@",dic[@"province"],dic[@"city"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        

    } else if (indexPath.section == 1) {
        NSDictionary *dic = _dataArray[indexPath.row];
        string = dic[@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.cityNameLabel.text = string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 40)];
    view.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ZQ_Device_Width - 24, 40)];
    label.textColor = kUIColorFromRGB(0x888888);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"GPS定位城市";
    } else if (section == 1) {
        label.text = @"其他省市";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *dic = _GPSArray[indexPath.row];
        NSString *string = [NSString stringWithFormat:@"%@%@",dic[@"province"],dic[@"city"]];
        if ([string isEqualToString:@"无法定位当前城市"]) {
            [self setupLocation];
        } else {
            [self getCityCode:dic];
        }
    } else {
        NSDictionary *dic = _dataArray[indexPath.row];
        ChooseOtherCityViewController *vc = [[ChooseOtherCityViewController alloc] initWithCity:dic];
        vc.delegate = self;
        pushToControllerWithAnimated(vc)
    }
    [self.view endEditing:YES];
}

- (void)getCityCode:(NSDictionary *)dic
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    __weak ChooseCityViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"prov"] = dic[@"province"];
    params[@"city"] = dic[@"city"];
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.getCityID"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *subDic = responseObject[@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:subDic]) {
                NSDictionary *dicc = @{@"provinceId":[NSString stringWithFormat:@"%@", subDic[@"provid"]], @"cityId":[NSString stringWithFormat:@"%@", subDic[@"cityid"]],@"province":dic[@"province"],@"city":dic[@"city"]};
                [USERDEFALUTS setObject:dicc forKey:@"location"];
                [USERDEFALUTS synchronize];
                
                if (_delegate && [_delegate respondsToSelector:@selector(seleCity:)]){
                    [_delegate seleCity:dicc];
                    [self leftBarButtonItem];
                }
            }
        } else {
//            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
            [weakSelf showHint:@"请手动选择其他城市"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)seleOtherCity:(NSDictionary *)dic
{
    if (_delegate && [_delegate respondsToSelector:@selector(seleCity:)]){
        [_delegate seleCity:dic];
        [self leftBarButtonItem];
    }
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searcher.delegate = nil;
    
}


@end
