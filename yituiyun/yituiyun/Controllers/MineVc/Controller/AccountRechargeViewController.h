//
//  AccountRechargeViewController.h
//  yituiyun
//
//  Created by 张强 on 2017/2/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
typedef void(^CallBack) ();

@interface AccountRechargeViewController : ZQ_ViewController
@property(nonatomic,copy)CallBack  callback;
@end
