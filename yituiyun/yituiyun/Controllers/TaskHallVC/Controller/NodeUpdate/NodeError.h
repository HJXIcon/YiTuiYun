//
//  NodeError.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/3.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskNodeModel;

@interface NodeError : ZQ_ViewController
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
/**节点任务状态 */
@property(nonatomic,strong) NSString * nodeStatus;
/**文字信息临时存储 */
@property(nonatomic,strong) NSMutableArray * titleInfoArray;

/**节点时间 */
@property(nonatomic,strong) NSDictionary * timeDict;

- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithWhere:(NSInteger)where;
- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithTextDataArray:(NSArray *)textDataArray WithImageDataArray:(NSArray *)imageDataArray WithWhere:(NSInteger)where;
@end
