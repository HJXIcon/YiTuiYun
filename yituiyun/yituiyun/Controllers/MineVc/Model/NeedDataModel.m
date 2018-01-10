//
//  NeedDataModel.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/16.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NeedDataModel.h"

@implementation NeedDataModel

+(instancetype)shareInstance{
   
    static NeedDataModel *dataMode;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataMode = [[NeedDataModel alloc]init];
        dataMode.taskSetpArray = [NSMutableArray array];
        dataMode.taskrequireArray = [NSMutableArray array];
        dataMode.taskZone = [NSMutableArray array];
        dataMode.taskType = @"";
        dataMode.tasksingle = @"";
        
        dataMode.taskNumber = @"";
        dataMode.taskTime = @"";
        
        dataMode.taskDesc = @"";
        dataMode.taskName = @"";
        dataMode.totalFee = 0.0f;
        dataMode.logoImageurl = @"";
    });
    return dataMode;
}

-(NSString *)description{
    
    NSString *str = [NSString stringWithFormat:@"--%@--%@--%@--%@--%@-%@-%@-%@-%@-%@",self.taskName,self.taskType,self.tasksingle,self.taskNumber,self.taskTime,self.taskZone,self.taskZone,self.taskDesc,self.taskSetpArray,self.taskrequireArray];
    return str;

}

-(void)cleanData{
   self.taskName = @"";
self.taskType = @"";
self.tasksingle = @"";
  
    self.taskNumber = @"";
    self.taskTime = @"";
    [self.taskZone removeAllObjects];

    self.taskDesc = @"";
    [self.taskSetpArray removeAllObjects];
    [self.taskrequireArray removeAllObjects];
    self.totalFee = 0.0f;
    self.logoImageurl = @"";
    self.demandID = @"";

   


}

@end
