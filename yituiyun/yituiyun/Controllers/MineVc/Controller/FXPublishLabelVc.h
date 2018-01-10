//
//  FXPublishLabelVc.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DataBlock)(NSArray *datas);
@interface FXPublishLabelVc : UIViewController

@property(nonatomic,copy)DataBlock  block;

@property(nonatomic,strong) NSMutableArray * qianmianDatas;
@end
