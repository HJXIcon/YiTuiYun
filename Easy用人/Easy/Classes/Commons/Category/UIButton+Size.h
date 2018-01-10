//
//  UIButton+Size.h
//  Easy
//
//  Created by yituiyun on 2017/11/16.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Size)

- (CGSize)jx_sizeToFitWithHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical;
@end

@interface UILabel (Size)
- (CGSize)jx_sizeToFitWithHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical;
@end
