//
//  EPerfectInfoViewController.h
//  Easy
//
//  Created by yituiyun on 2017/11/16.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,EPerfectInfoStatus) {
    
    EPerfectInfoNormalStatus = 0,   /// 平常
    EPerfectInfoAfterResisterStatus /// 注册之后完善资料
};

@class EUserModel;
/**
 完善资料
 */
@interface EPerfectInfoViewController : UITableViewController
@property (nonatomic, assign) EPerfectInfoStatus status;
@end
