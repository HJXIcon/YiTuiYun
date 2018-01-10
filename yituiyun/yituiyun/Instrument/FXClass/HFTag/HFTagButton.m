//
//  HFTagButton.m
//  ChangeClothes
//
//  Created by joyman04 on 15/10/23.
//  Copyright © 2015年 BFHD. All rights reserved.
//

#import "HFTagButton.h"

@implementation HFTagButton

+(id)creatWithFram:(CGRect)frame withBackColor:(UIColor*)backColor{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = backColor;
    button.layer.cornerRadius = 9;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width - 14, 0, 14, 9)];
    icon.image = [UIImage imageNamed:@"TagButton-TopLeft.png"];
    [button addSubview:icon];
    
    return button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
