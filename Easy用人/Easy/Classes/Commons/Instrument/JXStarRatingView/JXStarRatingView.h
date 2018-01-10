//
//  JXStarRatingView.h
//  Easy
//
//  Created by yituiyun on 2017/11/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXStarRatingFinishBlock) (CGFloat);

typedef NS_ENUM(NSInteger, JXStarRatingStyle)
{
    JXStarRatingWholeStarStyle = 0, //整星评论
    JXStarRatingHalfStyle = 1,      //半星评论
    JXStarRatingIncompleteStyle = 2 //不完整星评论
};


@class JXStarRatingView;
@protocol JXStarRatingDelegate <NSObject>

- (void)starRatingView:(JXStarRatingView *_Nullable)starRatingView currentValue:(CGFloat)currentValue;

@end

@interface JXStarRatingView : UIView

@property (nonatomic, weak) id<JXStarRatingDelegate> _Nullable delegate;

// Default style is JXStarRatingWholeStarStyle
@property (nonatomic, assign) JXStarRatingStyle style;

/**
 Default is 5.0 .
 */
@property(nonatomic, assign) IBInspectable CGFloat starMargin;

/**
 Default 3. this value pinned to [0, 5].
 */
@property(nonatomic, assign) CGFloat progress;

/**
 Default is YES. if NO, ignores touch events.
 */
@property(nonatomic, assign) BOOL enabled;

/**
 用户拖拽回调
 */
@property(nonatomic, copy) JXStarRatingFinishBlock _Nullable finishBlock;

/**
 star background image.
 */
@property (nonatomic, strong) UIImage * _Nullable backgroundImage;

/**
  star foreground image.
 */
@property (nonatomic, strong) UIImage * _Nullable foregroundImage;

@end
