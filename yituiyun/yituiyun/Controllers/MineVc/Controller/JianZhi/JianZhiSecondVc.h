//
//  JianZhiSecondVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedDesc.h"
@class JianZhiContainerVC;


@interface JianZhiSecondVc : UIViewController
@property(nonatomic,strong) JianZhiContainerVC * containerVc;
@property(nonatomic,strong) JianZhiModelDetail * detailmodel;
@property(nonatomic,assign) BOOL ismodfiy;
@end
