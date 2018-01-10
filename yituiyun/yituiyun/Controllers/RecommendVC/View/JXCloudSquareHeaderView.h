//
//  JXCloudSquareHeaderView.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 云广场顶部切换View
 */
@interface JXCloudSquareHeaderView : UIView

@property (nonatomic, copy) void(^selectBlock)(NSInteger);
#pragma mark - Public Method
- (void)leftAction;
@end
