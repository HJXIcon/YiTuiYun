//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//

#import "UIView+MJExtension.h"

@implementation UIView (MJExtension)
- (void)setMj_x:(CGFloat)mj_x
{
    CGRect frame = self.frame;
    frame.origin.x = mj_x;
    self.frame = frame;
}

- (CGFloat)mj_x
{
    return self.frame.origin.x;
}

- (void)setMj_y:(CGFloat)mj_y
{
    CGRect frame = self.frame;
    frame.origin.y = mj_y;
    self.frame = frame;
}

- (CGFloat)mj_y
{
    return self.frame.origin.y;
}

- (void)setMj_w:(CGFloat)mj_w
{
    CGRect frame = self.frame;
    frame.size.width = mj_w;
    self.frame = frame;
}

- (CGFloat)mj_w
{
    return self.frame.size.width;
}

- (void)setMj_h:(CGFloat)mj_h
{
    CGRect frame = self.frame;
    frame.size.height = mj_h;
    self.frame = frame;
}

- (CGFloat)mj_h
{
    return self.frame.size.height;
}

- (void)setMj_size:(CGSize)mj_size
{
    CGRect frame = self.frame;
    frame.size = mj_size;
    self.frame = frame;
}

- (CGSize)mj_size
{
    return self.frame.size;
}

- (void)setMj_origin:(CGPoint)mj_origin
{
    CGRect frame = self.frame;
    frame.origin = mj_origin;
    self.frame = frame;
}

- (CGPoint)mj_origin
{
    return self.frame.origin;
}

-(void)setMj_centerX:(CGFloat)mj_centerX{
    CGPoint oldCenter = self.center;
    oldCenter.x = mj_centerX;
    self.center = oldCenter;
}
-(CGFloat)mj_centerX{
    return self.center.x;
}

-(void)setMj_centerY:(CGFloat)mj_centerY{
    CGPoint oldCenter = self.center;
    oldCenter.y = mj_centerY;
    self.center = oldCenter;
}
-(CGFloat)mj_centerY{
    return self.center.y;
}
@end
