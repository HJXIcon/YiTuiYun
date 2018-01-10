//
//  JianZhiSecondupCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiSecondupCell.h"

@implementation JianZhiSecondupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.delegate = self;
    
    
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入描述信息(1-1000字)";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    self.textView.font = [UIFont systemFontOfSize:14.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length >1000) {
        [SVProgressHUD showErrorWithStatus:@"输入文字应小于1000个"];
        textView.text = [textView.text substringToIndex:900];
    }
    
    if (self.texviewblock) {
        self.texviewblock(textView.text);
    }
}
@end
