//
//  LHKCustomPickView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXListModel.h"
@class LHKCustomPickView;
typedef void(^LCancelBlock)(LHKCustomPickView *pick,FXListModel *fixmodel);
typedef void(^LMakesureBlock)(LHKCustomPickView *pick,FXListModel *fixmodel);

@interface LHKCustomPickView : UIView


+(instancetype)pickView;
@property(nonatomic,strong) NSMutableArray * datas;

@property(nonatomic,copy) LCancelBlock cancelblock;
@property(nonatomic,copy) LMakesureBlock   makesureblock;

@end
