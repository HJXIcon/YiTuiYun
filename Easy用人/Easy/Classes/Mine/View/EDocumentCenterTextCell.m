
//
//  EDocumentCenterTextCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EDocumentCenterTextCell.h"

@implementation EDocumentCenterTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.leftLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"身份证号:" textAlignment:0];
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(E_RealWidth(10));
        make.width.mas_equalTo(ceil([NSString sizeWithString:@"身份证号:" andFont:[UIFont systemFontOfSize:E_FontRadio(16)] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width));
    }];
    
    
    self.rightTextF = [[UITextField alloc]init];
    self.rightTextF.placeholder = @"请填写你的真实姓名";
    self.rightTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    [self.contentView addSubview:self.rightTextF];
    [self.rightTextF addTarget:self action:@selector(rightTextDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.rightTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(E_RealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-E_RealWidth(10));
    }];
    
}

- (void)rightTextDidChangeAction:(UITextField *)textF{
    if (self.rightTextDidChangeBlock) {
        self.rightTextDidChangeBlock(textF.text);
    }
}

- (void)setMaxLength:(NSInteger)maxLength{
    _maxLength = maxLength;
    if (maxLength > 0) {
        self.rightTextF.delegate = self;
    }else{
        self.rightTextF.delegate = nil;
    }
}

#pragma mark - *** UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.rightTextF) {
        if (range.location >= self.maxLength) return NO;
    }
    
    return YES;
    
}

@end
