//
//  ContactUsModel.h
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactUsModel : NSObject

/** 电话  */
@property (nonatomic, copy) NSString *serviceHotline;
/** 邮箱  */
@property (nonatomic, copy) NSString *serviceEmail;
/** 时间  */
@property (nonatomic, copy) NSString *serviceTime;

@end
