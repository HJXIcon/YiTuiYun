//
//  EGuideCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EGuideCell.h"

@implementation EGuideCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}
@end
