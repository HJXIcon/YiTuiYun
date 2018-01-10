//
//  homeCollectionCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "homeCollectionCell.h"

@implementation homeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodIcon.backgroundColor = [UIColor clearColor];
    self.goodName.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        //选中时
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else{
        //非选中
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
