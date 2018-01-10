//
//  LHKNavController.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/18.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKNavController.h"

@interface LHKNavController ()<UIGestureRecognizerDelegate>

@end

@implementation LHKNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interactivePopGestureRecognizer.delegate = self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count>0) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];

        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [btn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        viewController.hidesBottomBarWhenPushed = YES;
    
    }
    

    
    [super pushViewController:viewController animated:animated];
}
-(void)backTo{
    [self popViewControllerAnimated:YES];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count>1;
}

@end
