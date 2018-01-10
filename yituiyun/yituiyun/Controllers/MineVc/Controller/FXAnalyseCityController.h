//
//  FXAnalyseCityController.h
//  yituiyun
//
//  Created by fx on 16/11/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXAnalyseCityControllerDelegate <NSObject>

- (void)choseCityWithArray:(NSMutableArray *)cityArray;

@end
@interface FXAnalyseCityController : ZQ_ViewController

@property (nonatomic, assign) id<FXAnalyseCityControllerDelegate> delegate;

@end
