//
//  ZQLabelAndImageButton.m
//  yituiyun
//
//  Created by 张强 on 16/1/11.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQLabelAndImageButton.h"

@implementation ZQLabelAndImageButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.textColor = kUIColorFromRGB(0x404040);
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
        
        self.imageV = [[UIImageView alloc] init];
        _imageV.frame = ZQ_RECT_CREATE(CGRectGetWidth(self.frame) - 30, 5, 20, 20);
        [self addSubview:_imageV];
    }
    return self;
}

- (void)isShowImage:(NSInteger)isImage
{
    if (isImage == 2) {
        _label.frame = ZQ_RECT_CREATE(10, 0, CGRectGetWidth(self.frame) - 45, self.frame.size.height);
        _imageV.hidden = NO;
    } else {
        _label.frame = ZQ_RECT_CREATE(10, 0, CGRectGetWidth(self.frame) - 20, self.frame.size.height);
        _imageV.hidden = YES;
    }
}

@end
