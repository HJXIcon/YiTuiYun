//
//  PdfTableCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/25.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "PdfTableCell.h"

@implementation PdfTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shareBtn.layer.cornerRadius = 5;
    self.shareBtn.clipsToBounds = YES;
}


- (IBAction)readClick:(UIButton *)sender {
    
    
    if (self.readblock) {
        self.readblock();
    }
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    if (self.shareblock) {
        self.shareblock();
    }
}

@end
