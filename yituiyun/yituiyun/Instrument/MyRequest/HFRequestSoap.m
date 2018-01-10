//
//  HFRequestSoap.m
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/8/4.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "HFRequestSoap.h"

@interface HFRequestSoap ()<NSURLConnectionDataDelegate,NSURLSessionDelegate>{
    NSInteger _dataLength;
    NSMutableData* _downloadData;
    NSInteger _totalSize;
}

@end

@implementation HFRequestSoap
//接收请求体时触发上传文件
-(void)setFileDetailData:(NSData *)fileDetailData{
    _fileDetailData = fileDetailData;
    //创建接收Data
    _downloadData = [NSMutableData new];
    //拼接url
    NSString *soapAction = self.soapAction;
    NSURL *url=[NSURL URLWithString:soapAction];
    NSMutableURLRequest *requst=[NSMutableURLRequest requestWithURL:url];
    //创建分隔符
    NSString* contentType = [@"multipart/form-data; boundary="stringByAppendingString:@"----------f1a9n9l2i1s1h2i7"];
    //告诉服务器是post请求
    [requst setHTTPMethod:@"POST"];
    [requst addValue:contentType forHTTPHeaderField:@"Content-Type"];
    //计算文件大小
    NSString *contentLength=[[NSString alloc]initWithFormat:@"%lu",(unsigned long)[self.soapMessage length]];
    [requst addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    //自己保存计算上传进度条
    _totalSize = fileDetailData.length;
    //创建请求体
    [requst setHTTPBody:fileDetailData];
    //设置超时
    [requst setTimeoutInterval:20];
    //在状态栏开始转圈
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    if ([self.target respondsToSelector:@selector(isStar:)]) {
    //        [self.target isStar:YES];
    //    }
    //类方法开始请求 设置代理为自己
    [NSURLConnection connectionWithRequest:requst delegate:self];
//    [[[NSURLSession sharedSession] downloadTaskWithRequest:requst] resume];
}
//接收请求体时触发请求
-(void)setSoapMessage:(NSString *)soapMessage{
    _soapMessage = soapMessage;
    
    _downloadData = [NSMutableData new];
    NSString *soapAction = self.soapAction;
    NSURL *url=[NSURL URLWithString:soapAction];
    NSMutableURLRequest *requst=[NSMutableURLRequest requestWithURL:url];
    //    NSString *contentType = @"text/json;charset=utf-8";
    NSString* contentType = @"application/x-www-form-urlencoded";
    NSString *contentLength=[[NSString alloc]initWithFormat:@"%lu",(unsigned long)[self.soapMessage length]];
    [requst setHTTPMethod:@"POST"];
    [requst addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [requst addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [requst setHTTPBody:[self.soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [requst setTimeoutInterval:20];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection connectionWithRequest:requst delegate:self];
//    [[[NSURLSession sharedSession] downloadTaskWithRequest:requst] resume];
}

//-(void)startRequest{
//    _downloadData = [[NSMutableData alloc] init];
//    NSString *soapAction = self.soapAction;
//    NSURL *url=[NSURL URLWithString:soapAction];
//    NSMutableURLRequest *requst=[NSMutableURLRequest requestWithURL:url];
//    NSString* contentType = @"application/x-www-form-urlencoded";
//    NSString *soapMessage = self.soapMessage;
//    NSString *contentLength=[[NSString alloc]initWithFormat:@"%lu",(unsigned long)[self.soapMessage length]];
//    [requst setHTTPMethod:@"POST"];
//    [requst addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [requst addValue:contentLength forHTTPHeaderField:@"Content-Length"];
//    [requst setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    [requst setTimeoutInterval:10];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [NSURLConnection connectionWithRequest:requst delegate:self];
//}



//请求开始代理
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //保存服务器返回值的总文件大小
//    _dataLength = response.expectedContentLength;
}
//请求体写入代理
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    //如果进度条block存在 返回值
    if (self.requestingBlock) {
        self.requestingBlock(_totalSize,totalBytesWritten);
    }
}
//接收返回数据中
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //数据接收中拼接data
    [_downloadData appendData:data];
}
//接收返回数据完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //停止状态栏转圈
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //请求成功回调与返回Data
    self.endBlock(_downloadData);
}
//请求错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //停止状态栏转圈
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    if ([self.target respondsToSelector:@selector(isStar:)]) {
//        [self.target isStar:NO];
//    }
    //错误回调 未返回错误值 没用到过
    self.errorBlock();
}


@end
