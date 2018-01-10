//
//  FXChoseProvinceController.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
#import "FXCityModel.h"

@protocol FXChoseProvinceControllerDelegate <NSObject>

- (void)choseProviceWithProvince:(FXCityModel *)provinceModel andWithCityArray:(NSArray *)cityArray;

@end
@interface FXChoseProvinceController : ZQ_ViewController

@property (nonatomic, assign) id<FXChoseProvinceControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *compareArray;

@end
