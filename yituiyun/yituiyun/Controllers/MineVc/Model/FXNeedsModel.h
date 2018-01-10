//
//  FXNeedsModel.h
//  yituiyun
//
//  Created by fx on 16/11/1.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXNeedsModel : NSObject

/** 需求id  */
@property (nonatomic, copy) NSString *needsId;
/** 需求名称  */
@property (nonatomic, copy) NSString *needsTitle;
/** 需求时间  */
@property (nonatomic, copy) NSString *needsTime;
/** 0需求待审核 1需求未通过 2需求已通过 6任务执行中 7任务已停止 8任务已完成  */
@property (nonatomic, copy) NSString *needsStatus;
/** 凭证审核 3凭证待审核 4凭证未通过 5凭证审核通过  */
@property (nonatomic, copy) NSString *certificate;

@end
