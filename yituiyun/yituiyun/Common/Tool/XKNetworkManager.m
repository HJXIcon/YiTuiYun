//
//  XKNetworkManager.m
//  Minshuku
//
//  Created by Nicholas on 16/5/10.
//  Copyright © 2016年 Nicholas. All rights reserved.
//

#import "XKNetworkManager.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
//#import "progre"

@interface XKNetworkManager ()

@property (nonatomic,strong)NSMutableArray *modelArray;

@end

@implementation XKNetworkManager

#pragma mark- 判断定位服务是否开启
+ (BOOL)locationServicesEnabled {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        return YES;
        
    }else {
        
        return NO;
    }
    
}


#pragma mark - post

+ (void)POSTToUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    //https
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    // 是否允许,NO-- 不允许无效的证书
//    [securityPolicy setAllowInvalidCertificates:YES];
//    [securityPolicy setValidatesDomainName:NO];
    // 设置证书
//    [securityPolicy setPinnedCertificates:certSet];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy = securityPolicy;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", nil];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
//    [manager POST:urlString parameters:parameters constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        //上传进度
//        
//        if (progress) {
//            progress(uploadProgress.fractionCompleted);
//        }
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if (success) {
//            success(responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        if (failure) {
//            failure(error);
//        }
//    }];
//    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }

    }];
}

#pragma mark - 上传视频

+ (void)POSTVideoToUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters videoName:(NSString *)videoName videoPath:(NSString *)videoPath imageName:(NSString *)imageName imagePath:(NSString *)imagePath progress:(void (^)(CGFloat))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
        
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.上传文件
    //    NSDictionary *dict = @{@"member_id":@"160",@"homestay_id":@"399"};
    //    NSString *urlString = @"http://192.168.1.147/msk/web/apiVideoPost";
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:videoPath] name:@"videofile" fileName:videoName mimeType:@"video/mp4"];
        
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:imagePath] name:@"imgesfile" fileName:imageName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - GET 获取数据

+ (void)GETDataFromUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
//    //https
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    // 是否允许,NO-- 不允许无效的证书
//    [securityPolicy setAllowInvalidCertificates:NO];
//    // 设置证书
//    [securityPolicy setPinnedCertificates:certSet];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", nil];
    manager.requestSerializer.timeoutInterval = 10.0f;

    
    
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //上传进度
        if (progress) {
            progress(downloadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark - 上传图片
+ (void)xk_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy = securityPolicy;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", nil];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:videoPath] name:@"videofile" fileName:videoName mimeType:@"video/mp4"];
        
        for (int i = 0; i < images.count; i++) {
            
            UIImage *image = [images objectAtIndex:i];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            
            [formData appendPartWithFileData:imageData name:@"imgFile" fileName:@"image.png" mimeType:@"image/*"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        if (failure) {
            failure(error);
        }
    }];
    
   
}

// 处理网络状态改变
+ (BOOL)networkStateChange
{
    BOOL result = NO;
    
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable)
    { // 有wifi
        result = YES;
        
    } else if ([conn currentReachabilityStatus] != NotReachable)
    { // 没有使用wifi, 使用手机自带网络进行上网
        
        result = YES;
    } else
    { // 没有网络
        result = NO;
    }
    
    return result;
    

}




/*********************************************图片*******************/



@end






























