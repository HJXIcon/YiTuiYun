//
//  CompanyNeedscontainer.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/16.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedDesc.h"

@interface CompanyNeedscontainer : UIViewController
@property(nonatomic,strong) CompanyNeedDesc * model;
@property(nonatomic,assign)BOOL  isCanEditing;


@end
