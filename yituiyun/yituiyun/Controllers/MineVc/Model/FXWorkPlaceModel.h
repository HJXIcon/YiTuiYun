//
//  FXWorkPlaceModel.h
//  yituiyun
//
//  Created by fx on 16/10/29.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXWorkPlaceModel : NSObject

/** 前缀地名  */
@property (nonatomic, copy) NSString *buildPlace;
/** z最后一级地址  */
@property (nonatomic, copy) NSString *detailPlace;
/** 经度  */
@property (nonatomic, copy) NSString *lngStr;
/** 纬度  */
@property (nonatomic, copy) NSString *latStr;


@end
