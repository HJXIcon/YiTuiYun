//
//  LogoutAlterView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LogoutBlock)();

@interface LogoutAlterView : UIView
+(instancetype)alterView;
@property(nonatomic,copy)LogoutBlock l_block;
@end
