//
//  FXWorkPlaceDetailController.h
//  yituiyun
//
//  Created by fx on 16/10/31.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXWorkPlaceDetailControllerDelegate <NSObject>

- (void)detailPlaceWith:(NSString *)detailPlace WithLng:(NSString *)lng WithLat:(NSString *)lat;

@end
@interface FXWorkPlaceDetailController : ZQ_ViewController

@property (nonatomic, copy) NSString *placeString;//填写的详细地址
@property (nonatomic, copy) NSString *longitudeStr;//定位地点经度
@property (nonatomic, copy) NSString *latitude;//定位地点纬度

@property (nonatomic, assign) id<FXWorkPlaceDetailControllerDelegate> delegate;

@end
