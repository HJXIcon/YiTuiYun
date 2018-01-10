//
//  ContactUsCell.m
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ContactUsCell.h"

@interface ContactUsCell ()

@end

@implementation ContactUsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"ContactUsCell";
    ContactUsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ContactUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.leftImage = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(15, 15, 20, 20)];
        _leftImage.clipsToBounds = YES;
        _leftImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_leftImage];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(50, 0, 120, 50)];
        _titleLabel.textColor = kUIColorFromRGB(0x404040);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        self.detaiLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_titleLabel.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_titleLabel.frame) - 45, 50)];
        _detaiLabel.textColor = kUIColorFromRGB(0x808080);
        _detaiLabel.textAlignment = NSTextAlignmentRight;
        _detaiLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_detaiLabel];

    }
    return self;
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
