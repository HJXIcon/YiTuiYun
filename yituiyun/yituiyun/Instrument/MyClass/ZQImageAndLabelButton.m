//
//  ZQImageAndLabelButton.m
//  宝力优佳
//
//  Created by 张强 on 16/1/11.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQImageAndLabelButton.h"

@implementation ZQImageAndLabelButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    
    self.imageV = [[UIImageView alloc] init];
    _imageV.frame = ZQ_RECT_CREATE(0, 5, 10, 10);
    [self addSubview:_imageV];
    
    self.label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(18, 0, CGRectGetWidth(self.frame) - 18, 20)];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.font = [UIFont systemFontOfSize:13];
    [self addSubview:_label];
}
@end
