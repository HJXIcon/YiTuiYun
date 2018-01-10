//
//  UserAgreementModel.h
//  yituiyun
//
//  Created by fx on 16/12/2.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAgreementModel : NSObject

/** 协议名  */
@property (nonatomic, copy) NSString *name;
/** 时间  */
@property (nonatomic, copy) NSString *time;
/** pdf地址  */
@property (nonatomic, copy) NSString *link;
@property(nonatomic,strong) NSString * recordid;
@end
