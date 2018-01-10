//
//  TaskNodeModel.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskNodeModel : NSObject
/** 任务id  */
@property (nonatomic, copy) NSString *taskId;
/** 任务名称  */
@property (nonatomic, copy) NSString *taskName;
/** 签到位置  */
@property (nonatomic, copy) NSString *signInAddress;
/** id  */
@property (nonatomic, copy) NSString *nodeId;
/** 节点名称  */
@property (nonatomic, copy) NSString *nodeName;
/** 节点状态  */
@property (nonatomic, copy) NSString *nodeState;//0未上传 1已审核 2已失效 3审核中 4审核失败
/** 任务状态  */
@property (nonatomic, copy) NSString *state;//0已领取 1执行中 2已完成 3已取消
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSMutableArray *audit_list;
@end

@interface SubTaskModel : NSObject
@property(nonatomic,strong) NSString * add_time;
@property(nonatomic,strong) NSString * remark;
@property(nonatomic,strong) NSString * title;
@end
