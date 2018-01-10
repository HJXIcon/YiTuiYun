//
//  MoneyDetailsCell.m
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "MoneyDetailsCell.h"

@interface MoneyDetailsCell ()<UITextFieldDelegate>

@end

@implementation MoneyDetailsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MoneyDetailsCell";
    MoneyDetailsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MoneyDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, 0, 120, 50)];
    _nameLabel.textColor = kUIColorFromRGB(0x404040);
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_nameLabel.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_nameLabel.frame) - 20, 50)];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_detailLabel];
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
