//
//  EPartManagerViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPartManagerViewModel.h"
#import "EUserModel.h"

@implementation EPartManagerViewModel


- (NSMutableArray<EPartManagerModel *> *)partManagerLists{
    if (_partManagerLists == nil) {
        _partManagerLists = [NSMutableArray array];
    }
    return _partManagerLists;
}

- (instancetype)init{
    if (self = [super init]) {
        self.currentPage = 1;
        self.totalPage = 1;
    }
    return self;
}

/**
 兼职管理列表
 */
- (void)getPartManagerListData:(void(^)(void))completion{
    
    if (self.currentPage > self.totalPage) {
        [self  showHint:@"没有更多了~"];
        if (completion) completion();
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"pageNum"] = @(self.currentPage);
    params[@"pageSize"] = @(10);
    
    [PPNetworkHelper POST:E_ApiRequset(kUserGetDemand) parameters:params success:^(NSDictionary *responseObject) {
    
        if ([responseObject[@"errno"] intValue] != 0) {
            return ;
        }
        self.partManagerLists = [EPartManagerModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]];
        
        self.currentPage = [responseObject[@"rst"][@"currentPage"] intValue];
        self.totalPage = [responseObject[@"rst"][@"totalPage"] intValue];
        self.dataCount = [responseObject[@"rst"][@"dataCount"] intValue];
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
       
        [self showFailureMsg];
    }];
}

@end
