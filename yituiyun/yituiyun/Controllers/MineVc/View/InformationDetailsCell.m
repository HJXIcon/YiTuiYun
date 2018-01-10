//
//  InformationDetailsCell.m
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "InformationDetailsCell.h"

@interface InformationDetailsCell ()<UITextFieldDelegate>

@end

@implementation InformationDetailsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"InformationDetailsCell";
    InformationDetailsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[InformationDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(15, 0, 80, 44)];
    _nameLabel.textColor = kUIColorFromRGB(0x808080);
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_nameLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_nameLabel.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_nameLabel.frame) - 30, 44)];
    _detailLabel.textColor = kUIColorFromRGB(0x404040);
    _detailLabel.numberOfLines = 0;
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.font = [UIFont systemFontOfSize:14];
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
