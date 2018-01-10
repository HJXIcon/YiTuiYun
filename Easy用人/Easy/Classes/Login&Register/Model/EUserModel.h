//
//  EUserModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EUserModel : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *age;
/// 0:女，1:男
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *birthday;
/// 0: 小时工，1:领队
@property (nonatomic, strong) NSString *type;

@end
