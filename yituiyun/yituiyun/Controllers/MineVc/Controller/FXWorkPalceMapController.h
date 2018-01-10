//
//  FXWorkPalceMapController.h
//  yituiyun
//
//  Created by fx on 16/10/24.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXWorkPalceMapControllerDelegate <NSObject>

- (void)setWorkPlaceWith:(NSString *)workplaceStr WithLng:(NSString *)lng WithLat:(NSString *)lat;

@end
@interface FXWorkPalceMapController : ZQ_ViewController

@property (nonatomic, assign) id<FXWorkPalceMapControllerDelegate> delegate;

@end
