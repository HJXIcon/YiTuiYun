//
//  NotificationMessageModel.m
//  yituiyun
//
//  Created by 张强 on 16/10/28.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "NotificationMessageModel.h"

#import "MJExtension.h"

@implementation NotificationMessageModel
+ (instancetype)accountWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

MJCodingImplementation

@end
