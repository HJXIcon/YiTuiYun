//
//  JXPunchClockListModel.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPunchClockListModel.h"

@implementation JXPunchClockListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{
             @"audit_list" : [SubTaskModel class]
             };
}

@end

@implementation JXPunchClockDetailModel

@end
