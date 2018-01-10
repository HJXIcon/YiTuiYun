//
//  EPartManagerHeaderView.h
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPartManagerHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^headerBlock)(void);
@end
