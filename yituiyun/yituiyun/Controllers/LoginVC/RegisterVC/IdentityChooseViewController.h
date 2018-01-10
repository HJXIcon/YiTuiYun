//
//  IdentityChooseViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/17.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface IdentityChooseViewController : ZQ_ViewController
- (instancetype)initWithWhere:(NSInteger)where;
- (instancetype)initWithWhere:(NSInteger)where WithOpenId:(NSString *)openId WithNickname:(NSString *)nickname WithAvatar:(NSString *)avatar WithLoginType:(NSString *)loginType;
@end
