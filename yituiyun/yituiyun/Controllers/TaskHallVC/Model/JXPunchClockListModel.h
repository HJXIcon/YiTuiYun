//
//  JXPunchClockListModel.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskNodeModel.h"
/**
 打卡列表Model
 */
@interface JXPunchClockListModel : NSObject

/** 节点id*/
@property (nonatomic, strong) NSString *nodeid;
@property (nonatomic, strong) NSString *address;
// #0 待打下班卡  #1审核完成;2已失效;3审核中;4审核不通过
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *update_time;
// #签到时间 单位秒
@property (nonatomic, strong) NSString *inputtime;

@property(nonatomic,strong) NSArray <SubTaskModel *>*audit_list;

@end

@interface JXPunchClockDetailModel : NSObject
/** 节点id*/
@property (nonatomic, strong) NSString *node_id;
/** 上班地点*/
@property (nonatomic, strong) NSString *address;
/** 下班地址*/
@property (nonatomic, strong) NSString *end_address;
/** 上班时间*/
@property (nonatomic, strong) NSString *inputtime;
/** 下班时间*/
@property (nonatomic, strong) NSString *update_time;
/** 审核时间*/
@property (nonatomic, strong) NSString *last_time;
/** 0:待打下班卡,3:审核中，2:已失效，4:审核失败，1:审核完成*/
@property (nonatomic, strong) NSString *status;
@end
