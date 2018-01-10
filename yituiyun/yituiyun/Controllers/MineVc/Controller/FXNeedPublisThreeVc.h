//
//  FXNeedPublisThreeVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedDesc.h"
#import "NeedDataModel.h"

@class CompanyNeedscontainer;


@interface FXNeedPublisThreeVc : UIViewController
/**标签数组 */
@property(nonatomic,strong)NSMutableArray * datalabels;
@property(nonatomic,strong) CompanyNeedscontainer * contavC;
@property(nonatomic,strong) CompanyNeedDesc * descModel;
@property(nonatomic,assign)BOOL  isCanEding;
@end
