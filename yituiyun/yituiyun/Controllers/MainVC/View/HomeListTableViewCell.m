//
//  HomeListTableViewCell.m
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "HomeListTableViewCell.h"
#import "ZQImageAndLabelButton.h"
#import "ProjectModel.h"

@interface HomeListTableViewCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) ZQImageAndLabelButton *adressLabel;
@property (nonatomic, strong) ZQImageAndLabelButton *timeLabel;
/**接单量Lable */
@property(nonatomic,strong) UILabel * orderLabel;
/**成单量Lable */
@property(nonatomic,strong) UILabel * completeLabel;
@end

@implementation HomeListTableViewCell

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
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = kUIColorFromRGB(0x404040);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        //价钱
        self.priceLabel= [[UILabel alloc]initWithFrame:CGRectMake(ZQ_Device_Width - 82, 10, 70, 30)];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = kUIColorFromRGB(0xf16156);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
        
        //标签
        self.tagLabel= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 8, 14, 45, 20)];
        _tagLabel.font = [UIFont systemFontOfSize:11];
        _tagLabel.text = @"新项目";
        _tagLabel.backgroundColor = kUIColorFromRGB(0xf16156);
        _tagLabel.textColor = kUIColorFromRGB(0xffffff);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_tagLabel];
        
        //标签
        self.adressLabel = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 5, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - 60 - 24, 20)];
        _adressLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - 24 - 60, 20);
        _adressLabel.imageV.image = [UIImage imageNamed:@"tagsGreen"];
        [_adressLabel setUserInteractionEnabled:NO];
        _adressLabel.label.textColor = kUIColorFromRGB(0x808080);
        [self.contentView addSubview:_adressLabel];
        
        //时间
        self.timeLabel = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 5, CGRectGetMaxY(_adressLabel.frame), ZQ_Device_Width - 60 - 24, 20)];
        _timeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_adressLabel.frame), ZQ_Device_Width - 60 - 24, 20);
        _timeLabel.imageV.image = [UIImage imageNamed:@"timeGreen"];
        [_timeLabel setUserInteractionEnabled:NO];
        _timeLabel.label.textColor = kUIColorFromRGB(0x808080);
        [self.contentView addSubview:_timeLabel];
        
        
        _orderLabel = [[UILabel alloc]init];
        _orderLabel.textColor = kUIColorFromRGB(0x808080);
        _orderLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_orderLabel];
        
        
        _completeLabel = [[UILabel alloc]init];
        _completeLabel.textColor = kUIColorFromRGB(0x808080);
         _completeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_completeLabel];
    }
    
    return self;
}

- (void)setModel:(ProjectModel *)model
{
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.projectImage] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    if (![ZQ_CommonTool isEmpty:model.projectPrice]) {
        _priceLabel.text = [NSString stringWithFormat:@"%@",model.projectPrice];
    }
    CGSize priceSize = [_priceLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 30)];
    _priceLabel.frame = ZQ_RECT_CREATE(ZQ_Device_Width - priceSize.width - 12, 10, priceSize.width, 30);
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.projectName];
    CGSize nameSize = [_nameLabel.text sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 30)];
    if ([model.isNew integerValue] == 1) {
        _tagLabel.hidden = NO;
        if (nameSize.width > (ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24 - CGRectGetWidth(_priceLabel.frame) - 50)) {
            _nameLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 10, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24 - CGRectGetWidth(_priceLabel.frame) - 50, 30);
            _tagLabel.frame = ZQ_RECT_CREATE(ZQ_Device_Width - CGRectGetWidth(_priceLabel.frame) - 12 - 48, 16.5, 45, 15);
        } else {
            _nameLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 10, nameSize.width, 30);
            _tagLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_nameLabel.frame) + 2, 16.5, 45, 15);
        }
    } else {
        _tagLabel.hidden = YES;
        _nameLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 10, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24 - CGRectGetWidth(_priceLabel.frame) - 4, 30);
    }
    
    NSString *string;
    if (![ZQ_CommonTool isEmptyArray:model.tagArray]) {
        for (NSString *str in model.tagArray) {
            if ([ZQ_CommonTool isEmpty:string]) {
                string = str;
            } else {
                string = [NSString stringWithFormat:@"%@、%@", string, str];
            }
        }
    }
    _adressLabel.label.text = string;
    
    _timeLabel.label.text = [NSString stringWithFormat:@"%@", model.projectTime];
    
    _orderLabel.text = model.orderCount;
    _completeLabel.text = model.completeCount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.adressLabel.mas_centerY);
        make.right.mas_equalTo(self.priceLabel.mas_right);
    }];
    
    [self.completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.right.mas_equalTo(self.priceLabel.mas_right);
    }];

}

@end
