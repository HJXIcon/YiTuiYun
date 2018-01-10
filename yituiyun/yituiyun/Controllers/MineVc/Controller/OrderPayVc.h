//
//  OrderPayVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/17.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedListModel.h"

@interface OrderPayVc : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *wechatLabel;

@property (weak, nonatomic) IBOutlet UIImageView *yinlianLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qiyeqianbaoLabel;

@property (weak, nonatomic) IBOutlet UIView *zhifubaoPanView;
@property (weak, nonatomic) IBOutlet UIView *wechatPanView;

@property (weak, nonatomic) IBOutlet UIView *yilianPanView;

@property (weak, nonatomic) IBOutlet UILabel *yuerbuzuLabel;
@property (weak, nonatomic) IBOutlet UIButton *yuerbuzuDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *qianbaoPanView;

@property(nonatomic,strong) NSString * demanID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addorderConstant;
@property(nonatomic,assign) BOOL  isAddOrder;

//单价
@property(nonatomic,strong) NSString * addprice;
//项目名称
@property(nonatomic,strong) NSString * addProjectName;
@property(nonatomic,assign)BOOL  isModifyPrice;

//是否是招聘
@property(nonatomic,assign)BOOL  isZhaoPin;

@end
