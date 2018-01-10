//
//  KNButton.m
//  社区快线
//
//  Created by LUKHA_Lu on 15/11/2.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "KNButton.h"

@implementation KNButton

- (void)setHighlighted:(BOOL)highlighted{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (void)setup{
    [self setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
}

@end
