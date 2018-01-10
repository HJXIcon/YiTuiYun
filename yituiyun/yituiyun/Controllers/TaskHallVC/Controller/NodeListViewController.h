//
//  NodeListViewController.h
//  yituiyun
//
//  Created by 张强 on 2017/2/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@class ProjectModel;


@interface NodeListViewController : ZQ_ViewController

- (instancetype)initWith:(NSInteger)where WithProjectModel:(ProjectModel *)model;
@end
