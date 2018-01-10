//
//  FXLongitudeLatitudeModel.h
//  yituiyun
//
//  Created by fx on 16/10/31.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXLongitudeLatitudeModel : NSObject

/** 经度  */
@property (nonatomic, copy) NSString *longitudeStr;
/** 纬度  */
@property (nonatomic, copy) NSString *latitudeStr;
/** title  */
@property (nonatomic, copy) NSString *titleStr;
/** 时间  */
@property (nonatomic, copy) NSString *inputtime;
/** 数据id  */
@property (nonatomic, copy) NSString *pointId;

@end
