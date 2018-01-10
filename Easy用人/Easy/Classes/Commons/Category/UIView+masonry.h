//
//  UIView+masonry.h
//  BYBStore
//
//  Created by 晓梦影 on 2017/9/27.
//  Copyright © 2017年 BYBStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (masonry)
/**
 等间距水平布局  需要先设置size
 */
- (void) masonry_distributeSpacingHorizontallyWith:(NSArray*)views;
/**
 等间距垂直布局  需要先设置size
 */
- (void) masonry_distributeSpacingVerticallyWith:(NSArray*)views;
@end
