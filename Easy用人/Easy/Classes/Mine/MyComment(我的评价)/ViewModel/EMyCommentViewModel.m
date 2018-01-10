//
//  EMyCommentViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMyCommentViewModel.h"
#import "EUserModel.h"

@implementation EMyCommentViewModel
- (instancetype)init{
    if (self = [super init]) {
        self.totalPage = 1;
        self.currentPage = 1;
    }
    return self;
}

/**
 我的评价
 */
- (void)getMyCommentList:(void(^)(void))completion{
    
    if (self.currentPage > self.totalPage) {
        [self showHint:@"没有更多了哦~"];
        if (completion) {
            completion();
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"page"] = @(self.currentPage);
    params[@"pageSize"] = @(10);
    
    [PPNetworkHelper POST:E_ApiRequset(kMyComment) parameters:params success:^(NSDictionary *responseObject) {
        
        
        if ([responseObject[@"errno"] intValue] == 0) {
            
            self.totalPage = [responseObject[@"rst"][@"totalPage"]intValue];
            self.currentPage = [responseObject[@"rst"][@"currentPage"]intValue];
            if (self.currentPage > 1) {
                [self.myCommentList addObjectsFromArray:[EMyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]]];
            }else{
                self.myCommentList = [EMyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]];
            }
            if (completion) {
                completion();
            }
        }
        
    } failure:^(NSError *error) {
        
        [self showFailureMsg];
    }];
    
}
@end
