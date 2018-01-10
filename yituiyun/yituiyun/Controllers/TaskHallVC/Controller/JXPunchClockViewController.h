//
//  JXPunchClockViewController.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 打卡详情vc
 */
@interface JXPunchClockViewController : UIViewController

/** 节点ID*/
@property (nonatomic, strong) NSString *node_id;
/** job_id*/
@property (nonatomic, strong) NSString *job_id;
/** -1：上班打卡 0：下班打卡 */
@property (nonatomic, strong) NSString *node_status;
/** 打卡成功回调*/
@property (nonatomic, copy) void(^punchClockSuccessBlock)();
@end
