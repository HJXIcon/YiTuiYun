//
//  EPartManagerViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"
#import "EPartManagerModel.h"

@interface EPartManagerViewModel : EBaseViewModel

@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int dataCount;
/// 兼职管理列表
@property (nonatomic, strong) NSMutableArray <EPartManagerModel *>*partManagerLists;

/**
 兼职管理列表
 */
- (void)getPartManagerListData:(void(^)(void))completion;

@end
