//
//  UserInfoModel.m
//  社区快线
//
//  Created by 张强 on 15/12/8.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "UserInfoModel.h"
#import "MJExtension.h"

@implementation UserInfoModel
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
