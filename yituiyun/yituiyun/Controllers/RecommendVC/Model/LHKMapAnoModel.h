//
//  LHKMapAnoModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LHKMapAnoModel : NSObject

/**经纬度 */
/**
    id = 20,
	industry = 3400,
	realName = 侯谦,
	uid = 313,
	mobile = 13580306076,
	dist = 521,
	lat = 23.15021570,
	address = 广东省广州市天河区龙口东路363号,
	avatar = /var/upload/image/2017/05/2017052316364191348_177x177.jpg,
	lng = 113.34702142,
	nickname = 这是测试,
	add_time = 1495528687
 
 */
@property(nonatomic,strong) NSString * address;
@property(nonatomic,strong) NSString * industry;
@property(nonatomic,strong) NSString * add_time;
@property(nonatomic,strong) NSString * uid;
@property(nonatomic,strong) NSString * dist;
@property(nonatomic,strong) NSString * mobile;
@property(nonatomic,strong) NSString * nickname;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,assign) double  lng;
@property(nonatomic,assign) double  lat;
@property(nonatomic,strong) NSString * pid;
@property(nonatomic,strong) NSString * realName;





@end
