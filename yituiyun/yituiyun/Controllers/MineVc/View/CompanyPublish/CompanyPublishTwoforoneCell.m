//
//  CompanyPublishTwoforoneCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyPublishTwoforoneCell.h"
#import "NeedDataModel.h"

@interface CompanyPublishTwoforoneCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation CompanyPublishTwoforoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.textView.layer.borderColor = UIColorFromRGBString(@"0xecefef").CGColor;
    self.textView.layer.borderWidth = 1;

    }

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>1000) {
        self.textView.text = [textView.text substringToIndex:999];
        return ;
    }
    
    [NeedDataModel shareInstance].taskDesc = textView.text;
    if (textView.text.length>0) {
        self.textPlacLabel.hidden = YES;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld个字",1000-textView.text.length];
    }else{
        self.textPlacLabel.hidden = NO;
        self.numberLabel.text = @"1000个字";
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textPlacLabel.hidden = YES;
}
@end
