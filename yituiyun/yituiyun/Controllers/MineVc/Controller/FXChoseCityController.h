//
//  FXChoseCityController.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
#import "FXCityModel.h"

@protocol FXChoseCityControllerDelegate <NSObject>

- (void)choseCityWithModel:(NSArray *)cityArray;

@end
@interface FXChoseCityController : ZQ_ViewController

@property (nonatomic, strong) FXCityModel *pModel;

@property (nonatomic, assign) id<FXChoseCityControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *compareArray;

@end
