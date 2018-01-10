//
//  NormalBillVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyFaPiaoModel.h"
typedef void(^CallBack)();

@interface NormalBillVc : UIViewController
@property(nonatomic,strong) KaiFaPiaoModel * model;
@property(nonatomic,strong) NSMutableString * acount_id;
@property(nonatomic,strong) NSString * totalmoney;

@property(nonatomic,copy)CallBack  callback;
@end
