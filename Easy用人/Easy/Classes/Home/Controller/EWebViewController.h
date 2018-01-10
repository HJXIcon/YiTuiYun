//
//  EWebViewController.h
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewController.h"

@interface EWebViewController : EBaseViewController

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isShowURLWhenFail;

@end
