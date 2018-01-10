//
//  HFRequestSoap.h
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/8/4.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EndRequestBlock) (NSData* data);
//typedef void (^EndRequestBlock) (NSString* data);
typedef void (^ErrorRequestBlock) ();
typedef void (^RequestingBlock) (NSInteger expectedSize, NSInteger writSize);

@interface HFRequestSoap : NSObject

@property (nonatomic,copy) NSString* soapAction;//服务器接口
@property (nonatomic,copy) NSString* soapMessage;//请求内容
@property (nonatomic,copy) NSData* fileDetailData;//上传的文件
@property (nonatomic,copy) EndRequestBlock endBlock;//成功接收回调
@property (nonatomic,copy) ErrorRequestBlock errorBlock;//错误回调
@property (nonatomic,copy) RequestingBlock requestingBlock;//上传中回调

//-(void)startRequest;

@end
