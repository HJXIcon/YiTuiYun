//
//  CompanyNeedListModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/17.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyNeedListModel : NSObject
@property(nonatomic,strong) NSString * status;
@property(nonatomic,strong) NSString * certificate;
@property(nonatomic,strong) NSString * demandid;
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSString * projectName;
@property(nonatomic,strong) NSString * margin_amount;
@end


@interface CompanyJianZhiModel : NSObject
@property(nonatomic,strong) NSString * jobid;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * inputtime;
@property(nonatomic,strong) NSString * status;
@property(nonatomic,strong) NSString * person_number;
@property(nonatomic,strong) NSString * unit;
@property(nonatomic,strong) NSString * work_area;
@property(nonatomic,strong) NSString * logo;
@property(nonatomic,strong) NSString * salary;
@property(nonatomic,strong) NSString * start_date;
@property(nonatomic,strong) NSString * end_date;
@property(nonatomic,strong) NSString * settlement;
@property(nonatomic,strong) NSString * apply_status;
// 报名数
@property(nonatomic,strong) NSString * enrollment_number;
// 录取数
@property(nonatomic,strong) NSString * employment_number;
@property(nonatomic,strong) NSString * margin_amount;
@property(nonatomic,strong) NSString * applyStop;
/** 价格*/
@property(nonatomic,strong) NSString *wn;
@end
