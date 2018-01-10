//
//  TaskHallEnterpriseCell.m
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "TaskHallEnterpriseCell.h"
#import "ZQImageAndLabelButton.h"
#import "ProjectModel.h"

@interface TaskHallEnterpriseCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) ZQImageAndLabelButton *adressLabel;
@property (nonatomic, strong) ZQImageAndLabelButton *timeLabel;
@end

@implementation TaskHallEnterpriseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 15, 60, 60)];
        [[_iconView layer] setCornerRadius:3];
        [[_iconView layer] setMasksToBounds:YES];
        [_iconView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_iconView];
        
        //标题
        self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 14, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 36 - 60 - 50, 22)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = kUIColorFromRGB(0x404040);
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 77, 30, 65, 30);
        _button.backgroundColor = kUIColorFromRGB(0xffffff);
        _button.layer.cornerRadius = 4;
        _button.layer.borderWidth = 1;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_button];
        
        //标签
        self.adressLabel = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 65 - 24, 20)];
        _adressLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24 - 65, 20);
        [_adressLabel setUserInteractionEnabled:NO];
        _adressLabel.imageV.image = [UIImage imageNamed:@"tagsGreen"];
        _adressLabel.label.textColor = kUIColorFromRGB(0x808080);
        [self.contentView addSubview:_adressLabel];
        
        //时间
        self.timeLabel = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_adressLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 65 - 24, 20)];
        _timeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_adressLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 65 - 24, 20);
        [_timeLabel setUserInteractionEnabled:NO];
        _timeLabel.imageV.image = [UIImage imageNamed:@"timeGreen"];
        _timeLabel.label.textColor = kUIColorFromRGB(0x808080);
        [self.contentView addSubview:_timeLabel];
    }
    
    return self;
}

- (void)setModel:(ProjectModel *)model
{
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.projectImage] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.projectName];
    if ([model.status integerValue] == 7 || [model.status integerValue] == 8) {
        _button.hidden = YES;
        _nameLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 10, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 30);
    } else {
        _button.hidden = NO;
        _nameLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 10, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24 - 69, 20);
        _button.layer.borderColor = kUIColorFromRGB(0xf16156).CGColor;
        [_button setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([model.status integerValue] == 2) {
            [_button setTitle:@"开始任务" forState:UIControlStateNormal];
            _button.tag = 1041;
        } else if ([model.status integerValue] == 6) {
            [_button setTitle:@"停止任务" forState:UIControlStateNormal];
            _button.tag = 1043;
        }
    }
    
    if (![ZQ_CommonTool isEmptyArray:model.tagArray]) {
        NSString *string = nil;
        for (NSString *str in model.tagArray) {
            if ([ZQ_CommonTool isEmpty:string]) {
                string = str;
            } else {
                string = [NSString stringWithFormat:@"%@、%@", string, str];
            }
        }
        _adressLabel.label.text = string;
    }
    
    _timeLabel.label.text = [NSString stringWithFormat:@"%@",model.projectTime];
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag == 1041) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startButtonClickWithIndex:WithState:)]) {
            [self.delegate startButtonClickWithIndex:_indexPath WithState:@"0"];
        }
    } else if (button.tag == 1043) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopButtonClickWithIndex:)]) {
            [self.delegate stopButtonClickWithIndex:_indexPath];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
