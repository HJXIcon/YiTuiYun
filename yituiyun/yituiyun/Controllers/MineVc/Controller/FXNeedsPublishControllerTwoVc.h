//
//  FXNeedsPublishControllerTwoVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedDesc.h"
@class CompanyNeedscontainer;

@interface FXNeedsPublishControllerTwoVc : UIViewController
@property(nonatomic,strong) CompanyNeedscontainer * containVc;
@property(nonatomic,strong) CompanyNeedDesc * descModel;
/**所有图片内容和文字信息 */
@property(nonatomic,strong) NSMutableArray * allDatas;
@property(nonatomic,assign)BOOL  isCanEding;
@end
