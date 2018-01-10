//
//  MoneyDetailContentVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyDetailModel.h"
@interface MoneyDetailContentVc : UIViewController
@property(nonatomic,strong) MoneyDetailModel * model;
@property(nonatomic,assign)NSInteger  type;
@property(nonatomic,strong) TixianListModel * tixianModel;

@property(nonatomic,strong) ChangeOrjiyi * fistDataModel;
@property(nonatomic,strong) TixianOrTuiKuan * secondDataModel;

@end
