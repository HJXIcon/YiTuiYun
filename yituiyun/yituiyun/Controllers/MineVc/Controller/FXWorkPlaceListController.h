//
//  FXWorkPlaceListController.h
//  yituiyun
//
//  Created by fx on 16/10/29.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXWorkPlaceListControllerDelegate <NSObject>

- (void)detailPlaceWith:(NSString *)detailPlace WithLng:(NSString *)lng WithLat:(NSString *)lat;

@end
@interface FXWorkPlaceListController : ZQ_ViewController

@property (nonatomic, assign) id<FXWorkPlaceListControllerDelegate> delegate;
@property (nonatomic, copy) NSString *longitudeStr;//定位地点经度
@property (nonatomic, copy) NSString *latitude;//定位地点纬度


@end
