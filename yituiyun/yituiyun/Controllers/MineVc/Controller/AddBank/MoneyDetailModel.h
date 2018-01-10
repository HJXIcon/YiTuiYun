//
//  MoneyDetailModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyDetailModel : NSObject

@property(nonatomic,strong) NSString * add_time;
@property(nonatomic,strong) NSString * money;
@property(nonatomic,strong) NSString * adid;
@property(nonatomic,strong) NSString *t;
@property(nonatomic,strong) NSString * intro;
@end



@interface TixianListModel : NSObject
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSString * money;
@property(nonatomic,strong) NSString * status_str;
@property(nonatomic,strong) NSString * t_str;
@property(nonatomic,strong) NSString * did;
@property(nonatomic,strong) NSString * t;
@end


@interface ChangeOrjiyi : NSObject


@property(nonatomic,strong) NSString * intro;
@property(nonatomic,strong) NSString * money;
@property(nonatomic,strong) NSString * add_time;
@property(nonatomic,strong) NSString * remark;
@property(nonatomic,strong) NSString * projectName;
@property(nonatomic,strong) NSString * nickname;
@property(nonatomic,strong) NSString * t;
@property(nonatomic,strong) NSString * payment;
@property(nonatomic,strong) NSString * orderno;

@end

@interface TixianOrTuiKuan : NSObject
@property(nonatomic,strong) NSString * money;
@property(nonatomic,strong) NSString * status_str;
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSString * t_str;
@property(nonatomic,strong) NSString * t;
@property(nonatomic,strong) NSString * reason;
@property(nonatomic,strong) NSString * orderno;
@property(nonatomic,strong) NSString * intro;

@end
