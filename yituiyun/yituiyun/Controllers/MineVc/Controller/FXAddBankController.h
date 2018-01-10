//
//  FXAddBankController.h
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@class CardListModel;

@interface FXAddBankController : ZQ_ViewController
- (instancetype)initWithNumStr:(CardListModel *)takeMoneyModel WithWhere:(NSInteger)where;
@end
