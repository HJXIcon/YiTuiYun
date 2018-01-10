//
//  ChooseCityViewController.h
//  同门艺人
//
//  Created by NIT on 16/9/2.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol ChooseCityViewControllerDelegate;

@interface ChooseCityViewController : ZQ_ViewController
@property (weak, nonatomic) id <ChooseCityViewControllerDelegate> delegate;

- (instancetype)initWithPositioningString:(NSString *)positioningString WithWhere:(NSInteger)where;


@end

@protocol ChooseCityViewControllerDelegate <NSObject>

- (void)seleCity:(NSDictionary *)dic;
- (void)defaultCitySelect;


@end
