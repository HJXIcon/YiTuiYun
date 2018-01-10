//
//  UploadDetailViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@class TaskNodeModel;


@interface UploadDetailViewController : ZQ_ViewController
- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithDataArray:(NSArray *)dataArray WithWhere:(NSInteger)where;
@end
