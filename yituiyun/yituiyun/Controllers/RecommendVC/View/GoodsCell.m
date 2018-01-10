//
//  GoodsCell.m
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "GoodsCell.h"
#import "GoodsModel.h"

@interface GoodsCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *numsLabel;
@end

@implementation GoodsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"GoodsCell";
    GoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeView];
    }
    return self;
}

- (void)makeView{
    
    self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 15, 80, 80)];
    [self.contentView addSubview:_iconView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 15, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 50)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.numberOfLines = 2;
    _nameLabel.textColor = kUIColorFromRGB(0x404040);
    [self.contentView addSubview:_nameLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 30)];
    _priceLabel.font = [UIFont systemFontOfSize:18];
    _priceLabel.textColor = kUIColorFromRGB(0xf16156);
    [self.contentView addSubview:_priceLabel];
    
    self.originalPriceLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_priceLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 30)];
    _originalPriceLabel.font = [UIFont systemFontOfSize:14];
    _originalPriceLabel.textColor = kUIColorFromRGB(0x808080);
    [self.contentView addSubview:_originalPriceLabel];
    
    self.numsLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_originalPriceLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 30)];
    _numsLabel.font = [UIFont systemFontOfSize:12];
    _numsLabel.textColor = kUIColorFromRGB(0xABABAB);
    [self.contentView addSubview:_numsLabel];
}

- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:goodsModel.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    _nameLabel.text = goodsModel.title;
    
    NSString *priceString = [NSString stringWithFormat:@"¥%@", goodsModel.price];
    CGSize priceSize = [priceString sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, 30)];
    _priceLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), priceSize.width, 30);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = str;
    
    NSString *oldPriceString = [NSString stringWithFormat:@"¥%@", goodsModel.originalPrice];
    CGSize originalPriceSize = [oldPriceString sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 30)];
    _originalPriceLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_priceLabel.frame) + 10, CGRectGetMaxY(_nameLabel.frame)+2, originalPriceSize.width, 30);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldPriceString attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    if (![ZQ_CommonTool isEmpty:goodsModel.originalPrice]) {
        _originalPriceLabel.attributedText = string;
    }
    
    if (ZQ_Device_Width > 300) {
        _numsLabel.text = [NSString stringWithFormat:@"%@人已预定", goodsModel.nums];
        CGSize numSize = [_numsLabel.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 30)];
        _numsLabel.frame = ZQ_RECT_CREATE(ZQ_Device_Width - numSize.width - 12, CGRectGetMaxY(_nameLabel.frame)+4, numSize.width, 30);
    }
    
}

@end
