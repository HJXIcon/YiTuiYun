//
//  TaskHallEnterpriseDetailFootView.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShouCangBlock)(UIButton *btn);
typedef void(^BaoMingBlock)(UIButton *btn);

@interface TaskHallEnterpriseDetailFootView : UIView
+(instancetype)footView;
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;
@property (weak, nonatomic) IBOutlet UIButton *baomingBtn;

@property(nonatomic,copy) ShouCangBlock  shoucangblock;
@property(nonatomic,copy) BaoMingBlock    baomingblock;

@end
