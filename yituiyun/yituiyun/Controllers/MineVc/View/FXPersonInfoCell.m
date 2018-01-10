//
//  FXPersonInfoCell.m
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXPersonInfoCell.h"

@interface FXPersonInfoCell ()

@end
@implementation FXPersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
        _titleLabel.textColor = kUIColorFromRGB(0x808080);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 0, ScreenWidth - _titleLabel.frame.size.width - 20, 40)];
        _detailLabel.textColor = kUIColorFromRGB(0x808080);
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_detailLabel];
        
        CGSize telSize = [@"更换绑定手机号" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, 20)];
        self.telNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - telSize.width - 10 - 150 - 10, 10, 150, 20)];
        _telNumLabel.textColor = kUIColorFromRGB(0x404040);
        _telNumLabel.textAlignment = NSTextAlignmentRight;
        _telNumLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_telNumLabel];

        self.changeTelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeTelBtn.frame = CGRectMake(ScreenWidth - telSize.width - 10, 10, telSize.width, 20);
        [_changeTelBtn setTitle:@"更换绑定手机号" forState:UIControlStateNormal];
        [_changeTelBtn setTitleColor:MainColor forState:UIControlStateNormal];
//        [_changeTelBtn addTarget:self action:@selector(changeTelClick) forControlEvents:UIControlEventTouchUpInside];
        _changeTelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_changeTelBtn];
        
        self.heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 10, 110, 20)];
        _heightLabel.textColor = kUIColorFromRGB(0x808080);
        _heightLabel.textAlignment = NSTextAlignmentRight;
        _heightLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_heightLabel];
        
        self.cmLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 10, 30, 20)];
        _cmLabel.text = @"cm";
        _cmLabel.textColor = kUIColorFromRGB(0x666666);
        _cmLabel.textAlignment = NSTextAlignmentCenter;
        _cmLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_cmLabel];
        
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
