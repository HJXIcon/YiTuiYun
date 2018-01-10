//
//  HFAliyunOSS.h
//  MeiX
//
//  Created by joyman04 on 2017/1/16.
//  Copyright © 2017年 wangyuqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFAliyunOSS : NSObject

+ (instancetype)sharInstance;

- (void)uploadOSSPutObjectFilePath:(NSString*)filePath progress:(void (^) (int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(void (^) (NSString* fileUrl,NSError* error))finish;
- (void)uploadOSSPutObjectData:(NSData *)objectData progress:(void (^) (int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(void (^) (NSString* fileUrl,NSError* error))finish;

@property  (nonatomic,strong,readonly) NSArray* requests;

@end
