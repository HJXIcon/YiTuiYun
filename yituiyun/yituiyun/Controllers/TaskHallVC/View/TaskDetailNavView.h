//
//  TaskDetailNavView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NavBlock) (NSInteger index);

@interface TaskDetailNavView : UIView
+(instancetype)navView;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
/**<#type#> */
@property(nonatomic,copy)NavBlock  nav_block;
- (IBAction)TaskDetailNav:(UIButton *)sender;
@end
