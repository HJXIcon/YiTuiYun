//
//  JXLocationTool.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/29.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXLocationTool.h"

@interface JXLocationTool ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIAlertViewDelegate>

/**地理编码*/
@property(nonatomic,strong) BMKGeoCodeSearch *searcher;
/**localServier */
@property(nonatomic,strong) BMKLocationService * localServer;
/** 成功*/
@property (nonatomic, copy) void(^sucBlock)(NSDictionary *dict);
@property (nonatomic, copy) void(^errorBlock)(BMKSearchErrorCode error);

/** 当前地址名称*/
@property (nonatomic, copy) void(^addressBlock)(NSString *address,CLLocationCoordinate2D location);
@end
@implementation JXLocationTool
#pragma mark--地址反编码-lazy
-(BMKGeoCodeSearch *)searcher{
    if (_searcher == nil) {
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}
-(BMKLocationService *)localServer{
    if (_localServer == nil) {
        _localServer = [[BMKLocationService alloc]init];
        _localServer.delegate = self;
    }
    return _localServer;
}


+ (JXLocationTool *)shareInstance{
    static JXLocationTool *tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[JXLocationTool alloc]init];
    });
    return tool;
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
            
        } else{
            
            
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alvertView show];
    }
    [self.localServer startUserLocationService];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}




#pragma mark location定位
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint =userLocation.location.coordinate;
    
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
    }else{// 失败
        
    }
    
    [self.localServer stopUserLocationService];
    
}

#pragma mark--- 地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"latitude"] = @(result.location.latitude);
    dicc[@"longitude"] = @(result.location.longitude);
    dicc[@"dataid"] = @(100);
    dicc[@"province"] = result.addressDetail.province;
    dicc[@"city"] = result.addressDetail.city;
    
//    NSDictionary *dicc = @{@"latitude":@(result.location.latitude), @"longitude":@(result.location.longitude),@"dataid":@(100),@"province":result.addressDetail.province,@"city":result.addressDetail.city};
    
//    NSLog(@"省 -- %@,市 -- %@,区 -- %@", result.addressDetail.province,result.addressDetail.city,result.addressDetail.district);
    /// 判断直辖市
    if ([result.addressDetail.province isEqualToString:result.addressDetail.city]) {
        dicc[@"province"] = result.addressDetail.city;
        dicc[@"city"] = result.addressDetail.district;
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {// 成功
        
        // 判断是不是在中国
        if (![self isLocationOutOfChina:CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude)]) {
            if (self.sucBlock) {
                self.sucBlock(dicc);
            }
            
            if (self.addressBlock) {
                self.addressBlock(result.address,result.location);
            }
        }
        
    }else { // 失败
        self.errorBlock(error);
    }
    
   
    
    
}



#pragma mark - Public Method
/**
 GPS定位获取当前位置
 
 @param success  成功
 @param errors 失败
 */
- (void)getCurrentLocations:(void(^)(NSDictionary *dict))success  error:(void(^)(BMKSearchErrorCode error))errors{
    
    [self setupLocation];
    
    //成功
    self.sucBlock = ^(NSDictionary *dict){
        success(dict);
    };
    
    //失败
    self.errorBlock = ^(BMKSearchErrorCode error){
        errors(error);
    };
    
}


/**
 判断是否已超过中国范围
 */
- (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location{
    
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}


/**
  GPS定位获取当前地址名称和经纬度
 
 @param success  成功
 @param errors 失败
 */
- (void)getCurrentAddress:(void(^)(NSString *address,CLLocationCoordinate2D location))addressBlock  error:(void(^)(BMKSearchErrorCode error))errors{
    
    [self setupLocation];
    
    //成功
    self.addressBlock = ^(NSString *address,CLLocationCoordinate2D location) {
        addressBlock(address,location);
    };
    
    
    //失败
    self.errorBlock = ^(BMKSearchErrorCode error){
        errors(error);
    };
    
}

+ (BOOL)isBD{
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    if ([model.identity isEqualToString:@"6"]){
        return YES;
    }else if ([model.identity isEqualToString:@"5"]){
        return NO;
    }
    return NO;
}


@end
