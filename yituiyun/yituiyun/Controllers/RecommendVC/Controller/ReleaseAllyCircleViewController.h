//
//  ReleaseAllyCircleViewController.h
//  yituiyun
//
//  Created by 张强 on 2017/2/7.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol ReleaseAllyCircleViewControllerDeleagete <NSObject>

- (void)gobackTableViewReload;


@end

@interface ReleaseAllyCircleViewController : ZQ_ViewController
- (instancetype)initWithWhere:(NSInteger)where;
@property (nonatomic, assign) id <ReleaseAllyCircleViewControllerDeleagete> deleagete;

@end
