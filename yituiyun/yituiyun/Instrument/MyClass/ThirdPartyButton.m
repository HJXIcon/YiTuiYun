//
//  ThirdPartyButton.m
//  荣坤
//
//  Created by 张强 on 16/4/25.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ThirdPartyButton.h"

@implementation ThirdPartyButton
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    
    self.iconView = [[UIImageView alloc] init];
    _iconView.frame = ZQ_RECT_CREATE(10, 0, self.frame.size.width-20, self.frame.size.width-20);
    [self addSubview:_iconView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(_iconView.frame) + 5, self.frame.size.width, self.frame.size.height-self.frame.size.width+20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = kUIColorFromRGB(0x666666);
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_nameLabel];
    
}

@end
