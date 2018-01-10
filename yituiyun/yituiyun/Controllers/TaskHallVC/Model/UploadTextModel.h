//
//  UploadTextModel.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadTextModel : NSObject
/** id  */
@property (nonatomic, copy) NSString *taskId;
/** 任务名称  */
@property (nonatomic, copy) NSString *taskName;
/** 任务字段  */
@property (nonatomic, copy) NSString *taskField;
/** 任务文字  */
@property (nonatomic, copy) NSString *taskText;

@end
