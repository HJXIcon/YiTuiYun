//
//  ENotiCenterModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/12.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 通知中心列表model
@interface ENotiCenterModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *dataId;


@end
