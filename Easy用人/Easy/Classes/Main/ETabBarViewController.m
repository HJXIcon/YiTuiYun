//
//  ETabBarViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ETabBarViewController.h"
#import "ENavigationController.h"
#import "EHomeViewController.h"
#import "EMineViewController.h"


@interface ETabBarViewController ()

@end

@implementation ETabBarViewController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize{
    
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    
    dictSelected[NSForegroundColorAttributeName] = EThemeColor;
    
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildVc];
}

- (void)setUpAllChildVc
{
    [self setUpOneChildVcWithVc:[[EHomeViewController alloc]init] Image:@"shouye_unsel" selectedImage:@"shouye" title:@"首页"];
    [self setUpOneChildVcWithVc:[[EMineViewController alloc]init] Image:@"wode_unsel" selectedImage:@"wode" title:@"我的"];
}


#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    ENavigationController *nav = [[ENavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    
    [self addChildViewController:nav];
}




@end
