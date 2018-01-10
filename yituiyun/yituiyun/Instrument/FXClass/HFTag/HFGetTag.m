//
//  HFGetTag.m
//  EasyRepair
//
//  Created by joyman04 on 16/2/16.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "HFGetTag.h"
#import "HFRequest.h"

@implementation HFGetTag

+ (void)getTagWithKeyId:(NSString *)keyId
            parentId:(NSString *)parentId
                getType:(HFGetTagStyle)style
               success:(void (^)(NSArray* _Nullable))success{
    NSString* tableName = [NSString stringWithFormat:@"HFTag%@%@",keyId,parentId];
    
    [[HFDataBase sharInstance] createNewTableWithTableName:tableName andColumn:@"linkageid,parentid,name,img"];
    
    NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"linkageid,parentid,name,img" andCondition:@[[NSString stringWithFormat:@"parentid=%@",parentId]]];
    if (tempArr.count) {
        if (style == OnleOnce) {
            success(tempArr);
            return;
        }
        if (style == EveryReload) {
            success(tempArr);
        }
    }
    
    NSDictionary* parameters = @{@"keyid":keyId,
                                 @"parentid":parentId};
    [HFRequest requestWithUrl:GetTagUrl parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        BOOL isReload = NO;
        if ([responseObject count] == 0) {
            isReload = YES;
        }
        for (NSDictionary* tempDic in responseObject) {
            NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"linkageid,parentid,name,img" andCondition:@[[NSString stringWithFormat:@"linkageid=%@",tempDic[@"linkageid"]]]];
            if (tempArr.count == 0) {
                isReload = YES;
            }
            [[HFDataBase sharInstance] upDataFromeTableName:tableName andColumn:@[@"linkageid",@"parentid",@"name",@"img"] andParameter:@[tempDic[@"linkageid"],tempDic[@"parentid"],tempDic[@"name"],tempDic[@"img"]] andCondition:@[[NSString stringWithFormat:@"linkageid=%@",tempDic[@"linkageid"]]]];
        }
        if (style == EveryReload && !isReload) {
            return;
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

@end
