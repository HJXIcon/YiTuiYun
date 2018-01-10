//
//  LHKSellerWriteCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKSellerWriteCell.h"

@implementation LHKSellerWriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    
    [self.descLabel addTarget:self action:@selector(desctextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    


}
-(void)desctextFieldChange:(UITextField *)textfiled{
    
//    NSLog(@"--------%@------",textfiled.text);
    if (self.textBlock) {
        self.textBlock(textfiled.text);
    }
}
- (IBAction)againBtnClick:(id)sender {
    //定位
    if (self.aginBlock) {
        self.aginBlock();
    }
}

- (IBAction)fieldBtnClick:(id)sender {
    if (self.fieldBlock) {
        self.fieldBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
