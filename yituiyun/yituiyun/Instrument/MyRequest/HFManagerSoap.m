//
//  HFManagerSoap.m
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/8/4.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#define BOUNDARY @"----------f1a9n9l2i1s1h2i7"

#import "HFManagerSoap.h"

@implementation FileDetail
//创建文件 文件名 文件data流
+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data {
    FileDetail *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    return file;
}
@end

@implementation HFManagerSoap

+(void)requestWithUrl:(NSString*)url params:(NSDictionary*)params EndBlock:(EndRequestBlock)endBlock ErrorBlock:(ErrorRequestBlock)errorBlock{
    HFRequestSoap* request = [[HFRequestSoap alloc] init];
    request.soapAction = url;
    request.endBlock = endBlock;
    request.errorBlock = errorBlock;
    request.soapMessage = [HFManagerSoap getStrParamsWith:params];
}

+(void)requestFileDetailWithUrl:(NSString*)url params:(NSDictionary *)params EndBlock:(EndRequestBlock)endBlock RequestingBlock:(RequestingBlock)requestBlock ErrorBlock:(ErrorRequestBlock)errorBlock{
    HFRequestSoap* request = [[HFRequestSoap alloc] init];
    request.soapAction = url;
    request.endBlock = endBlock;
    request.errorBlock = errorBlock;
    request.requestingBlock = requestBlock;
    request.fileDetailData = [HFManagerSoap getDataWithParams:params];
}

+(NSData*)getDataWithParams:(NSDictionary*)params{
    NSMutableData *body = [NSMutableData new];
    //循环字典创建请求体
    for(NSString *key in params) {
        id content = [params objectForKey:key];
        //如果是字符串或数字 以参数拼接
        if([content isKindOfClass:[NSString class]] || [content isKindOfClass:[NSNumber class]]) {
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",BOUNDARY,key,content,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
        //如果是文件 以间隔拼接
        } else if([content isKindOfClass:[FileDetail class]]) {
            FileDetail *file = (FileDetail *)content;
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,key,file.name,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:file.data];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    //拼接结束间隔
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

+(NSMutableString*)getStrParamsWith:(NSDictionary*)params{
    NSMutableString* str = [NSMutableString new];
    if (params) {
        for (NSString* dicKey in [params allKeys]) {
            if ([params[dicKey] isKindOfClass:[NSArray class]]) {
                for (NSString* param in params[dicKey]) {
                    NSString* tempStr = [NSString stringWithFormat:@"%@[]=%@",dicKey,param];
                    [str appendFormat:@"&%@",tempStr];
                }
            }else if ([[params objectForKey:dicKey] isKindOfClass:[NSString class]]){
                NSString* tempStr = [NSString stringWithFormat:@"%@=%@",dicKey,[params objectForKey:dicKey]];
                [str appendFormat:@"&%@",tempStr];
            }
            
        }
    }else{
        [str setString:@""];
    }
    return str;
}
@end
