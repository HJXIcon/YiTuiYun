//
//  BillProNormalTableViewCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BillProNormalTableViewCell.h"

@implementation BillProNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)textFieldChangeMethod:(UITextField *)sender {
    
    
    if (self.textfieldblock) {
        self.textfieldblock(sender.text);
    }
}

@end
