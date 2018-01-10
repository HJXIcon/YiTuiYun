//
//  CompanyNeedModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/16.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface CompanyNeedModel : NSObject
//t = 2,
//id = 32,
//fid = 251,
//name_en = bankCard,
//name_zh = 银行开户许可证

@property(nonatomic,strong) NSString * fid;
@property(nonatomic,strong) NSString * name_zh;

@property(nonatomic,assign)NSInteger isShow;

@property(nonatomic,strong) NSString * ID;
@end
