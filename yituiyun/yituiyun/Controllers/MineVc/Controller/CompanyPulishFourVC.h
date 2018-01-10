//
//  CompanyPulishFourVC.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedDesc.h"
@class CompanyNeedscontainer;
@class OrderPayVc;

@interface CompanyPulishFourVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property(nonatomic,strong) CompanyNeedscontainer * containVc;
@property(nonatomic,strong) CompanyNeedDesc * descModel;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property(nonatomic,assign)BOOL  isCanEding;
@end
