//
//  EStatisticalTableModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EStatisticalTableModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *hotel_id;
@property (nonatomic, strong) NSString *demand_price_id;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *job_type_id;
@property (nonatomic, strong) NSString *duration;
/// #工时或者房间房间号
@property (nonatomic, strong) NSString *room_num;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *demand_id;
@property (nonatomic, strong) NSString *price;
/// # 招聘名称
@property (nonatomic, strong) NSString *demand_title;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *prov;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *area;
/// #职位
@property (nonatomic, strong) NSString *jobName;
@property (nonatomic, strong) NSString *address;
/// #金额（元）
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, strong) NSString *prov_id;
@property (nonatomic, strong) NSString *lng;
/// 结束时间
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *is_on;
/// #部门
@property (nonatomic, strong) NSString *dept_name;
/// #酒店名称
@property (nonatomic, strong) NSString *hotel_name;
/// #开始时间
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *dept_id;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *city_id;
@end
