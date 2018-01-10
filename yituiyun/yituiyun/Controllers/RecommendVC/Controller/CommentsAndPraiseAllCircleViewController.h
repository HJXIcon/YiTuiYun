//
//  CommentsAndPraiseAllCircleViewController.h
//  yituiyun
//
//  Created by 张强 on 2017/2/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol CommentsAndPraiseAllCircleViewControllerDeleagete <NSObject>

- (void)gobackTableViewReload;


@end

@interface CommentsAndPraiseAllCircleViewController : ZQ_ViewController
@property (nonatomic, assign) id <CommentsAndPraiseAllCircleViewControllerDeleagete> deleagete;

@end
