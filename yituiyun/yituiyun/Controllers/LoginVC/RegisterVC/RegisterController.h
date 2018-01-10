//
//  RegisterController.h
//  yituiyun
//
//  Created by Messi on 14-6-10.
//  Copyright (c) 2014年 xiaoyu-ys. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface RegisterController : ZQ_ViewController
- (instancetype)initWithWhere:(NSInteger)where WithIdentity:(NSString *)identity;
- (instancetype)initWithWhere:(NSInteger)where WithOpenId:(NSString *)openId WithNickname:(NSString *)nickname WithAvatar:(NSString *)avatar WithLoginType:(NSString *)loginType WithIdentity:(NSString *)identity;

@property(nonatomic,assign)BOOL isQiyeRegister;
@end
