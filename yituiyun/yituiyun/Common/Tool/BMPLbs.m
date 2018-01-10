//
//  BMPLbs.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/24.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BMPLbs.h"
#import "CCLocationManager.h"

@interface BMPLbs ()<BMKLocationServiceDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) BMKLocationService * localServer;

@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@end

@implementation BMPLbs

+(instancetype)shareManger{
    static BMPLbs *lbs;
    static dispatch_once_t onceToken;
   
    dispatch_once(&onceToken, ^{
        lbs = [[BMPLbs alloc]init];
    });
    

    return lbs;
    
}

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

-(void)startLocation:(LBSBLOCK)lbsblock{
    
    [SVProgressHUD showWithStatus:@"定位中"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
#ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            
        }
#endif
        if ([CLLocationManager locationServicesEnabled]) {
            self.lbsblock = lbsblock;
            [self.localServer startUserLocationService];
            
        } else{
            
            
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alvertView show];
    }
    
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint =userLocation.location.coordinate;
    
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
    }
    else
    {
        
    }
    
    [self.localServer stopUserLocationService];
    
}
#pragma mark--- 地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
    }
    else {
        
        
        
        
    }
    
    if (self.lbsblock) {
        self.lbsblock(result);
    }
    
//    NSDictionary *dicc = @{@"latitude":@(result.location.latitude), @"longitude":@(result.location.longitude),@"dataid":@(100),@"province":result.addressDetail.province,@"city":result.addressDetail.city};
    
    
}



@end
