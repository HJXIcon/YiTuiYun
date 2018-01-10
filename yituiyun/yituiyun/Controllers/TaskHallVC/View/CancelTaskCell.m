//
//  CancelTaskCell.m
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "CancelTaskCell.h"

@interface CancelTaskCell ()<UITextFieldDelegate>

@end

@implementation CancelTaskCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString* identifier = @"CancelTaskCell";
    CancelTaskCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CancelTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeView];
    }
    return self;
}

- (void)makeView
{
    
//    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, 0, 120, 44)];
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = kUIColorFromRGB(0x5e5e5e);

    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
//    self.textField = [[UITextField alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_nameLabel.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_nameLabel.frame) - 20, 44)];
    self.textField = [[UITextField alloc]init];
    
    _textField.textColor = kUIColorFromRGB(0x2c2c2c);
    [_textField setUserInteractionEnabled:YES];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:15];
    [_textField addTarget:self action:@selector(nodeTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    
    self.lineView = [[UIView alloc]init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@(1));
    }];
}

-(void)nodeTextChange:(UITextField *)textField{
    if (self.nodetextBlock) {
        self.nodetextBlock(textField.text);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
