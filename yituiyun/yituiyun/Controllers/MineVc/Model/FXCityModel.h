//
//  FXCityModel.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXCityModel : NSObject

/** 通用选择项model  */

/** 城市id (或 数据id)  */
@property (nonatomic, copy) NSString *cityId;
/** 城市名 （或 数据名） */
@property (nonatomic, copy) NSString *cityName;
/** 图  */
@property (nonatomic, copy) NSString *itemImg;

@end

@interface ChinaBankModel : NSObject
@property(nonatomic,strong) NSString * bank_code;
@property(nonatomic,strong) NSString * bank_name;

@end
