//
//  HFManagerSoap.h
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/8/4.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFRequestSoap.h"

@interface FileDetail : NSObject
//文件名
@property(strong,nonatomic) NSString *name;
//文件data流
@property(strong,nonatomic) NSData *data;
//创建文件
+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data;

@end

@interface HFManagerSoap : NSObject
//普通请求
+(void)requestWithUrl:(NSString*)url params:(NSDictionary*)params EndBlock:(EndRequestBlock)endBlock ErrorBlock:(ErrorRequestBlock)errorBlock;
//上传文件
+(void)requestFileDetailWithUrl:(NSString*)url params:(NSDictionary *)params EndBlock:(EndRequestBlock)endBlock RequestingBlock:(RequestingBlock)requestBlock ErrorBlock:(ErrorRequestBlock)errorBlock;
@end

