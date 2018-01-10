//
//  JianZhiWorkDetailModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/9/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JianZhiWorkDetailModel : NSObject

//@"nickname"];
//        //tel
//        weakSelf.tel =  resultDict[@"rst"][@"node"][@"mobile"];


@property(nonatomic,strong) NSString * nickname;
@property(nonatomic,strong) NSString * mobile;

@property(nonatomic,strong) NSString * inputtime; //上班时间
@property(nonatomic,strong) NSString * address;  //上班地址

@property(nonatomic,strong) NSString * update_time; //下班时间
@property(nonatomic,strong) NSString * end_address;

@end
