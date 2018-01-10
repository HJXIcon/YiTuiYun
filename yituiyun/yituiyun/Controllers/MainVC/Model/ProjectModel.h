//
//  ProjectModel.h
//  yituiyun
//
//  Created by FX on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

/** id  */
@property (nonatomic, copy) NSString *projectId;
/** 项目发布人id  */
@property (nonatomic, copy) NSString *memberid;
/** 项目名称  */
@property (nonatomic, copy) NSString *projectName;
/** 项目描述  */ //新增
@property (nonatomic, copy) NSString *projectDesc;
/**目标客户 */
@property(nonatomic,strong) NSString * projectTarget_clients;
/**项目优势 */
@property(nonatomic,strong) NSString * project_advantage;
/**任务要求 */
@property(nonatomic,strong) NSString * project_explain;
/**所需要的物料 */
@property(nonatomic,strong) NSString * project_materials_needed;
/** 项目图片url  */
@property (nonatomic, copy) NSString *projectImage;
/** 项目钱  */
@property (nonatomic, copy) NSString *projectPrice;
/** 项目是否收藏  */
@property (nonatomic, copy) NSString *isCollection;
/** 项目是否已领取过  */
@property (nonatomic, copy) NSString *isget;
/** 标记  */
@property (nonatomic, copy) NSString *type;
/** 电话  */
@property (nonatomic, copy) NSString *projectPhone;
/** 群主  */
@property (nonatomic, copy) NSString *groupManager;
/** 群id  */
@property (nonatomic, copy) NSString *groupId;
/** 是否提交停止申请  */
@property (nonatomic, copy) NSString *applyStop;
/** 是否提交开始申请  */
@property (nonatomic, copy) NSString *applyQuest;
/** 是否资料完整  */
@property (nonatomic, copy) NSString *dataIntegrity;
/** 任务类型 1普通任务 2特殊任务  */
@property (nonatomic, copy) NSString *taskType;
/** 项目周期描述  */
@property (nonatomic, copy) NSString *projectTime;
/** 结算方式 1单 2天 */
@property (nonatomic, copy) NSString *payType;
/** 项目持续时间 一周7 俩周14 一个月30 三个月90 半年180 一年365 长期9999 */
@property (nonatomic, copy) NSString *timeType;
/** 项目开始时间  */
@property (nonatomic, copy) NSString *startTime;
/** 项目结束时间  */
@property (nonatomic, copy) NSString *endTime;
/** 是否是新项目  */
@property (nonatomic, copy) NSString *isNew;
/** 推广人数  */
@property (nonatomic, copy) NSString *number;
/** 累计成单  */
@property (nonatomic, copy) NSString *single;
/** 累计推广  */
@property (nonatomic, copy) NSString *promotion;
/** 当前执行中的项目ID  */
@property (nonatomic, copy) NSString *doingDemandid;
/** 当前执行中的项目名称  */
@property (nonatomic, copy) NSString *doingName;
/** 任务状态 0已领取 1执行中 2已完成 3已取消 5需求已完成 6任务执行中 7任务已停止 8任务已完成 */
@property (nonatomic, copy) NSString *status;
/** 任务状态 0已领取 1执行中 2已完成 3已取消 */
@property (nonatomic, copy) NSString *myTaskStatus;
/** 地址是否显示全  */
@property (nonatomic, copy) NSString *isAdress;
/** 标签  */
@property (nonatomic, strong) NSMutableArray *tagArray;
/** 职位描述  */
@property (nonatomic, strong) NSMutableArray *positionArray;
/** 人员要求  年龄不限区间 0-999 身高不限区间 0-999*/
@property (nonatomic, strong) NSMutableArray *personnelArray;
/** 项目活动地址  */
@property (nonatomic, strong) NSMutableArray *adressArray;
/** 文字  */
@property (nonatomic, strong) NSMutableArray *textArray;
/** 图片  */
@property (nonatomic, strong) NSMutableArray *imgsArray;
/**接单量 */
@property(nonatomic,strong) NSString * orderCount;
/**成单量 */
@property(nonatomic,strong) NSString * completeCount;

/**类型t_demandType */
@property(nonatomic,strong) NSString *t_demandTyp;

/**地址数组 */
@property(nonatomic,strong) NSArray * Cityarray;

@property(nonatomic,strong) NSString * pdfStr;
@property(nonatomic,strong) NSString * price;
@property(nonatomic,strong) NSString * pdfName;
@property(nonatomic,strong) NSString * demandid;
@end
