//
//  CompanyFaPiaoModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/25.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyFaPiaoModel : NSObject

@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString * projectName;
@property(nonatomic,strong) NSString * total_price;
@property(nonatomic,strong) NSString * starttime;
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,assign)BOOL  isSelect;

@end



@interface KaiFaPiaoModel : NSObject
@property(nonatomic,strong) NSString * main_acountName;
@property(nonatomic,strong) NSString * main_suihao;
@property(nonatomic,strong) NSString * main_totalMoney;
/***********/
@property(nonatomic,strong) NSString * main_pro_acount;
@property(nonatomic,strong) NSString * main_pro_bankName;


@property(nonatomic,strong) NSString * company_acountName;
@property(nonatomic,strong) NSString * company_acount;
@property(nonatomic,strong) NSString * company_acountAddress;


@property(nonatomic,strong) NSString * person_acountName;
@property(nonatomic,strong) NSString * person_acount;
@property(nonatomic,strong) NSString * person_acountAddress;
@property(nonatomic,strong) NSString * person_shengfenID;



@property(nonatomic,strong) NSString * alipay_acountName;
@property(nonatomic,strong) NSString * alipay_acount;


@end


@interface HistroyFapiaoListModel : NSObject
@property(nonatomic,strong) NSString * applyid;
@property(nonatomic,strong) NSString * primary_name;
@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSString * status;
@property(nonatomic,strong) NSString * total_price;
@property(nonatomic,strong) NSString * inputtime;
@end


@interface HistroyFapiaoDetailListModel : NSObject
@property(nonatomic,strong) NSString * projectName;
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSString * total_price;
@property(nonatomic,strong) NSString * starttime;

@end



