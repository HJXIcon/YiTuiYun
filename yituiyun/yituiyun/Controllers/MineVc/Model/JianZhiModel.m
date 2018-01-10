//
//  JianZhiModel.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiModel.h"

@implementation JianZhiModel
+(instancetype)shareInstance{
    static JianZhiModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JianZhiModel alloc]init];
    });
    return model;
}

-(void)cleanData{
    self.title= @"";
    self.salary = @"";
    self.unit = @"";
    self.settlement = @"";
    self.person_number = @"";
    self.start_date = @"";
    self.end_date = @"";
    self.contact = @"";
    self.phone = @"";
    self.email = @"";
    self.province = @"";
    self.city = @"";
    self.area = @"";
    self.describe = @"";
    self.ageMin = @"";
    self.ageMax = @"";
    self.heightMax = @"";
    self.heightMin = @"";
    self.sex = @"";
    self.jobType = @"";
    self.address = @"";
    
}
@end
