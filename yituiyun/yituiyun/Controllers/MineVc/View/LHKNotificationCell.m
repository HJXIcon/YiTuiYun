//
//  LHKNotificationCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/28.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKNotificationCell.h"

@implementation LHKNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame{
    
    CGRect old = frame;
    old.origin.x =10;
    old.size.width-=20;
    frame = old;
    [super setFrame:frame];
}
@end
