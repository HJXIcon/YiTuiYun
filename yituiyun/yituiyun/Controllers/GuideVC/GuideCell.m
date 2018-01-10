//
//  GuideCell.m
//  yituiyun
//
//  Created by 张强 on 2016/12/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "GuideCell.h"

@implementation GuideCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.hidden = YES;
        _button.frame = CGRectMake(ZQ_Device_Width / 4, ZQ_Device_Height * 0.8, ZQ_Device_Width / 2, ZQ_Device_Height * 0.2);
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        
        
    }
    return self;
}

- (void)login:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClick)]) {
        [self.delegate buttonClick];
    }
}


@end
