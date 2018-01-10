//
//  EMyCommentViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"
#import "EMyCommentModel.h"

@interface EMyCommentViewModel : EBaseViewModel
/// 总的页数
@property (nonatomic, assign) int totalPage;
/// 当前页
@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray<EMyCommentModel *> *myCommentList;

/**
 我的评价
 */
- (void)getMyCommentList:(void(^)(void))completion;

@end
