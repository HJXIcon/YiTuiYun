//
//  JianZhiModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JianZhiModel : NSObject
+(instancetype)shareInstance;
//职位名称
@property(nonatomic,strong) NSString * title;
//薪水
@property(nonatomic,strong) NSString * salary;
//单位
@property(nonatomic,strong) NSString * unit;
//结算方式
@property(nonatomic,strong) NSString * settlement;
//招聘人数
@property(nonatomic,strong) NSString * person_number;
//开始时间
@property(nonatomic,strong) NSString * start_date;
//截止时间
@property(nonatomic,strong) NSString * end_date;
//联系人
@property(nonatomic,strong) NSString * contact;
//联系方式
@property(nonatomic,strong) NSString * phone;
//联系邮箱
@property(nonatomic,strong) NSString * email;

//工作地址
@property(nonatomic,strong) NSString * province;
@property(nonatomic,strong) NSString * city;
@property(nonatomic,strong) NSString * area;

@property(nonatomic,strong) NSString * address;
//工作详情
@property(nonatomic,strong) NSString * describe;

//年龄
@property(nonatomic,strong) NSString * ageMin;
@property(nonatomic,strong) NSString * ageMax;

//高度
@property(nonatomic,strong) NSString * heightMin;
@property(nonatomic,strong) NSString * heightMax;

//性别
@property(nonatomic,strong) NSString * sex;
@property(nonatomic,strong) NSString * jobType;

-(void)cleanData;

@end
