//
//  CompanyNeedDesc.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/18.
//  Copyright © 2017年 张强. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SetpModel.h"

@interface CompanyNeedDesc : NSObject
//任务名称
@property(nonatomic,strong) NSString * projectName;
//任务类型
@property(nonatomic,strong) NSString * typeStr;
@property(nonatomic,strong) NSString * typeID;
//任务单价
@property(nonatomic,strong) NSString * price;
//任务数量
@property(nonatomic,strong) NSString * total_single;
//截止时间
@property(nonatomic,strong) NSString * endDate;
//任务介绍
@property(nonatomic,strong) NSString * desc;
//任务步骤
@property(nonatomic,strong) NSArray * execute_step;
//任务要求
@property(nonatomic,strong) NSArray * citysArr;
@property(nonatomic,strong) NSString * citys;

@property(nonatomic,strong) NSArray * setting;

@property(nonatomic,strong) NSString * logoImageUrl;
@end



@interface JianZhiModelDetail : NSObject

@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSString * detail_area;
@property(nonatomic,strong) NSString * work_area;
@property(nonatomic,strong) NSString * address;
@property(nonatomic,strong) NSString * contact;
@property(nonatomic,strong) NSString * listorder;
@property(nonatomic,strong) NSString * ontop;
@property(nonatomic,strong) NSString * salary;
@property(nonatomic,strong) NSString * unit;
@property(nonatomic,strong) NSString * person_number;
@property(nonatomic,strong) NSString * heightMax;
@property(nonatomic,strong) NSString * start_date;
@property(nonatomic,strong) NSString * end_date;
@property(nonatomic,strong) NSString * email;
@property(nonatomic,strong) NSString * area;
@property(nonatomic,strong) NSString * style;
@property(nonatomic,strong) NSString * heightMin;
@property(nonatomic,strong) NSString * settlement;
@property(nonatomic,strong) NSString * sex;
// 1：已报名，2：被拒绝，3：被录取，4：取消报名
@property(nonatomic,strong) NSString * apply_status;
@property(nonatomic,strong) NSString * city;
@property(nonatomic,strong) NSString * status;
@property(nonatomic,strong) NSString * recommend;
@property(nonatomic,strong) NSString * province;
@property(nonatomic,strong) NSString * describe;
@property(nonatomic,strong) NSString * ageMax;
@property(nonatomic,strong) NSString * ageMin;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * updatetime;
@property(nonatomic,strong) NSString * phone;
@property(nonatomic,strong) NSString * jobType;
@property(nonatomic,strong) NSString * jobid;
@property(nonatomic,strong) NSString * isCollect;
@property(nonatomic,strong) NSString * days;
@property(nonatomic,strong) NSString * wn;


//-1打上班卡，0打下班卡
@property(nonatomic,strong) NSString *node_status;
/** 节点id*/
@property (nonatomic, strong) NSString *node_id;

@end
