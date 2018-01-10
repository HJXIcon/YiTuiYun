//
//  NotificationMessageModel.h
//  yituiyun
//
//  Created by 张强 on 16/10/28.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationMessageModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 通知id */
@property (nonatomic, copy) NSString *messageId;
/** 描述 */
@property (nonatomic, copy) NSString *describe;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 类型  */
@property (nonatomic, copy) NSString *type;
/** 1是0否已读  */
@property (nonatomic, copy) NSString *isread;
/** 跳转id  */
@property (nonatomic, copy) NSString *dataId;
@end
