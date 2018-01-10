//
//  JXPopAllSelectView.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXPopAllSelectView : UIView
/** 点击 */
@property (nonatomic, copy) void(^tapBlock)(BOOL);
@property (nonatomic, assign) BOOL isSelectAll;
@end
