//
//  EHomeListModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHomeListModel : NSObject
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *hotel_id;
@property (nonatomic, strong) NSString *demand_price_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *duration;
/// 房间号
@property (nonatomic, strong) NSString *room_num;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *demand_id;
@property (nonatomic, strong) NSString *price;
/// 职位
@property (nonatomic, strong) NSString *demand_title;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *prov;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *address;
/// 金额
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, strong) NSString *prov_id;
@property (nonatomic, strong) NSString *lng;
/// 结束时间
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *is_on;
@property (nonatomic, strong) NSString *dept_name;
@property (nonatomic, strong) NSString *hotel_name;
/// 开始时间
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *dept_id;
/// 日期
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *city_id;
@end
