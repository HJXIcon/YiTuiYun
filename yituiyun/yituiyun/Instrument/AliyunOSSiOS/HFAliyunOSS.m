
//
//  HFAliyunOSS.m
//  MeiX
//
//  Created by joyman04 on 2017/1/16.
//  Copyright © 2017年 wangyuqian. All rights reserved.
//

#import "HFAliyunOSS.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>

@interface HFAliyunOSS ()

@property (nonatomic,strong) NSMutableArray* dfdd;

@property (nonatomic,strong) OSSClient* client;

@end

@implementation HFAliyunOSS

static HFAliyunOSS *single = nil;
+ (instancetype)sharInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        single = [[HFAliyunOSS alloc] init];
    });
    return single;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        AccessKeyID：LTAI3yoYMu5SL16g AccessKeySecret：4JUtJ3CGoiEgGsOeKED7hX4HOWtLkz
//        AssumeRole：
//    RoleArn: acs:ram::30859919:role/aliyunosstokengeneratorrole
//    RoleSessionName: external-username
//    DurationSeconds: 3600
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIVIk0xvsKN7r7"
                                                                                                                secretKey:@"JKAczFvCHnkpo8oE9k52bVEncgIrER"];
        OSSClientConfiguration* config = [[OSSClientConfiguration alloc] init];
        config.maxConcurrentRequestCount = 5;
        config.maxRetryCount = 1;
        config.timeoutIntervalForRequest = 10;
        self.client = [[OSSClient alloc] initWithEndpoint:@"http://oss-cn-shanghai.aliyuncs.com"
                                       credentialProvider:credential
                                      clientConfiguration:config];
    }
    return self;
}

- (void)uploadOSSPutObjectFilePath:(NSString*)filePath progress:(void (^) (int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(void (^) (NSString* fileUrl,NSError* error))finish {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"yituiyun";
//    put.bucketName = @"nit-bj";
    NSDate* data = [NSDate date];
    NSTimeInterval timeSince = [data timeIntervalSince1970];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSString* fileName = [NSString stringWithFormat:@"i_%zd%@.mp4",(int)timeSince,infoModel.userID];
    NSString* uploadFilePath = [@"video/" stringByAppendingString:fileName];//上传保存路径
    put.objectKey = uploadFilePath;
//    put.objectKey = fileName;
    if ([filePath hasPrefix:@"file:"]) {
        put.uploadingFileURL = [NSURL URLWithString:filePath];
    } else {
        put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    }
    // put.uploadingData = <NSData *>; // 直接上传NSData
    // 设置回调参数
//    put.callbackParam = @{@"callbackUrl": @"<your server callback address>",
//                          @"callbackBody": @"<your callback body>"};
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            progress(bytesSent,totalByteSent,totalBytesExpectedToSend);
        });
        
    };
    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    // put.contentType = @"";
    // put.contentMd5 = @"";
    // put.contentEncoding = @"";
    // put.contentDisposition = @"";
    // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        OSSPutObjectResult *aaa;
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(fileName,task.error);
        });
        return nil;
    }];
    // [putTask waitUntilFinished];
    // [put cancel];
}

- (void)uploadOSSPutObjectData:(NSData *)objectData progress:(void (^) (int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(void (^) (NSString* fileUrl,NSError* error))finish {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"yituiyun";
    //    put.bucketName = @"nit-bj";
    NSDate* data = [NSDate date];
    NSTimeInterval timeSince = [data timeIntervalSince1970];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSString* fileName = [NSString stringWithFormat:@"i_%zd%@.mp4",(int)timeSince,infoModel.userID];
    NSString* uploadFilePath = [@"video/" stringByAppendingString:fileName];//上传保存路径
//    put.objectKey = uploadFilePath;
    //    put.objectKey = fileName;
//    if ([filePath hasPrefix:@"file:"]) {
//        put.uploadingFileURL = [NSURL URLWithString:filePath];
//    } else {
//        put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
//    }
     put.uploadingData = objectData; // 直接上传NSData
    // 设置回调参数
    //    put.callbackParam = @{@"callbackUrl": @"<your server callback address>",
    //                          @"callbackBody": @"<your callback body>"};
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            progress(bytesSent,totalByteSent,totalBytesExpectedToSend);
        });
        
    };
    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    // put.contentType = @"";
    // put.contentMd5 = @"";
    // put.contentEncoding = @"";
    // put.contentDisposition = @"";
    // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(fileName,task.error);
        });
        return nil;
    }];
    // [putTask waitUntilFinished];
    // [put cancel];
}

@end
