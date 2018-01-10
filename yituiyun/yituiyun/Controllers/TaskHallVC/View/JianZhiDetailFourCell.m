//
//  JianZhiDetailFourCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiDetailFourCell.h"

@implementation JianZhiDetailFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)telBtnClick:(UIButton *)sender {
    if (self.telblock) {
        self.telblock(sender);
    }
}

@end
