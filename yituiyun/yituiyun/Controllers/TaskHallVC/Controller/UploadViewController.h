//
//  UploadViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@class TaskNodeModel;

@interface UploadViewController : ZQ_ViewController
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithWhere:(NSInteger)where;
- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithTextDataArray:(NSArray *)textDataArray WithImageDataArray:(NSArray *)imageDataArray WithWhere:(NSInteger)where;
@end
