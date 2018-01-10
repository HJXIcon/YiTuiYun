//
//  FXNeedsPublishController.h
//  yituiyun
//
//  Created by fx on 16/11/2.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
#import "CompanyNeedDesc.h"
@class CompanyNeedscontainer;

@protocol FXNeedsPublishControllerDelegate <NSObject>

- (void)publishSuccessReloadList;

@end
@interface FXNeedsPublishController : ZQ_ViewController

@property (nonatomic, assign) id<FXNeedsPublishControllerDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *titleStr;//题目

@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, copy) NSString *requireStr;//要求

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, copy) NSString *typeId;//项目选择的类型的id
@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, copy) NSString *moneyNum;//项目经费

@property (nonatomic, strong) UILabel *wageLabel;
@property (nonatomic, copy) NSString *wageId;//工资支付人的id
@property (nonatomic, copy) NSString *wageStr;

@property (nonatomic, strong) UILabel *proportionLabel;
@property (nonatomic, copy) NSString *proportionId;//比例的id
@property (nonatomic, copy) NSString *proportionStr;

@property (nonatomic, copy) NSString *needId;//需求id

@property (nonatomic, strong) NSMutableArray *dataArray;//区域

@property(nonatomic,strong) CompanyNeedscontainer * containVc;
@property(nonatomic,strong) CompanyNeedDesc * descModel;
@property(nonatomic,assign)BOOL  isCanEding;
@end
