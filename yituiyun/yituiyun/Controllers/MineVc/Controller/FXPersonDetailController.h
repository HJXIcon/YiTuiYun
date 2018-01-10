//
//  FXPersonDetailController.h
//  yituiyun
//
//  Created by fx on 16/11/15.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface FXPersonDetailController : ZQ_ViewController
- (instancetype)initPersonId:(NSString *)personId;
@property (nonatomic, copy) NSString *where;
@end
