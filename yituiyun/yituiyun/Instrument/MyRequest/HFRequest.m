//
//  HFRequest.m
//  EasyRepair
//
//  Created by joyman04 on 15/12/29.
//  Copyright © 2015年 HF. All rights reserved.
//

#import "HFRequest.h"

@implementation HFRequest

+ (void)requestWithUrl:(NSString *)url
            parameters:(id)parameters
               success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
               failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure{
    [HFRequest requestWithUrl:url parameters:parameters constructingBodyWithBlock:nil progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
        NSMutableDictionary *dictjson = JSonDictionary;
        
        success(task,dictjson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        if (failure) {
            failure(task,error);
        }
    }];
}
+ (void)uploadFileWithImage:(UIImage*)image
                    success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
                    failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure{
    NSString* url = [kHost stringByAppendingString:@"kindeditor/php/uploadApi.php?mode=1"];
    [HFRequest requestWithUrl:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data1 = UIImageJPEGRepresentation(image, 0.3);
        NSString* type = @"image/*";
        [formData appendPartWithFileData:data1 name:@"imgFile" fileName:@"image.png" mimeType:type];
    } progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
        NSDictionary *dictjson = JSonDictionary;
        success(task,dictjson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        failure(task,error);
    }];
}

+ (void)requestWithUrl:(NSString *)url
            parameters:(id)parameters
constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
              progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
               success:(void (^)(NSURLSessionDataTask * _Nullable , id _Nullable))success
               failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", nil];
    manager.requestSerializer.timeoutInterval = 10.0f;

    [manager POST:url parameters:parameters constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        failure(task,error);
            }];
}
@end
