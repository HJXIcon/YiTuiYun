//
//  LHKSellerWriteViewController.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHKMapAnoModel.h"

@interface LHKSellerWriteViewController : UIViewController
- (instancetype)initWith:(NSInteger)where;

@property(nonatomic,assign)NSInteger where;//1 表示 商家录入  2表示 商家详情

/**model */
@property(nonatomic,strong) LHKMapAnoModel * model;

@end
