//
//  SignInViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

typedef void(^TiaoZhuanBlock)();
@class ProjectModel;

@interface SignInViewController : ZQ_ViewController
- (instancetype)initWithProjectModel:(ProjectModel *)projectModel;
@property(nonatomic,copy) TiaoZhuanBlock tiaoBlock;
@end
