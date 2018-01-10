//
//  ChoseProportionController.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol ChoseProportionControllerDelegate <NSObject>

- (void)choseProportionWithDictionary:(NSDictionary *)proportionDic;

@end

@interface ChoseProportionController : ZQ_ViewController

@property (nonatomic, assign) id<ChoseProportionControllerDelegate> delegate;

@end
