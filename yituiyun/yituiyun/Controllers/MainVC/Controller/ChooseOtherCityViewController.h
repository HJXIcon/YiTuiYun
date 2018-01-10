//
//  ChooseOtherCityViewController.h
//  yituiyun
//
//  Created by NIT on 16/9/2.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol ChooseOtherCityViewControllerDelegate;

@interface ChooseOtherCityViewController : ZQ_ViewController
@property (weak, nonatomic) id <ChooseOtherCityViewControllerDelegate> delegate;

- (instancetype)initWithCity:(NSDictionary *)dic;

@end

@protocol ChooseOtherCityViewControllerDelegate <NSObject>

- (void)seleOtherCity:(NSDictionary *)dic;

@end
