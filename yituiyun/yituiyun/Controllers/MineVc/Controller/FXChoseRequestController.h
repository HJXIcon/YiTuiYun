//
//  FXChoseRequestController.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXChoseRequestControllerDelegate <NSObject>

- (void)choseRequestWithArray:(NSMutableArray *)requestArray;

@end
@interface FXChoseRequestController : ZQ_ViewController

@property (nonatomic, assign) id<FXChoseRequestControllerDelegate> delegate;

@end
