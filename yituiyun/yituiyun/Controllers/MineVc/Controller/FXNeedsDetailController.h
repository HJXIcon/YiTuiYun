//
//  FXNeedsDetailController.h
//  yituiyun
//
//  Created by fx on 16/11/1.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXNeedsDetailControllerDelegate <NSObject>

- (void)detailChangeStatus;

@end
@interface FXNeedsDetailController : ZQ_ViewController

@property (nonatomic, copy) NSString *needsId;
@property (nonatomic, assign) id<FXNeedsDetailControllerDelegate> delegate;

@end
