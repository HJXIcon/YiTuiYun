//
//  FXChoseTityCell.m
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXChoseTityCell.h"

@interface FXChoseTityCell ()

@property (nonatomic, strong) UILabel *titleLabel;     //名
@property (nonatomic, strong) UIImageView *itemView; //图

@property (nonatomic, strong) UIImageView *selectView; //选中图

@end
@implementation FXChoseTityCell

+ (instancetype)choseCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"FXChoseTityCell";
    FXChoseTityCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FXChoseTityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 44)];
        _titleLabel.textColor = kUIColorFromRGB(0x404040);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        self.itemView = [[UIImageView alloc]init];
        [self.contentView addSubview:_itemView];
        
        self.selectView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, 12, 20, 20)];
        _selectView.image = [UIImage imageNamed:@"unchose.png"];
        [self.contentView addSubview:_selectView];
    }
    return self;
}
- (void)setCityModel:(FXCityModel *)cityModel{
    _cityModel = cityModel;
    CGSize titleSize = [_cityModel.cityName sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, 44)];
    _titleLabel.frame = CGRectMake(10, 0, titleSize.width, 44);
    _itemView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 5, 13, 18, 18);
    _titleLabel.text = _cityModel.cityName;
    _itemView.image = [UIImage imageNamed:_cityModel.itemImg];
    
}
- (void)setIsSelect:(BOOL)isSelect {
    if (isSelect) {
        _selectView.image = [UIImage imageNamed:@"chose.png"];
    } else {
        _selectView.image = [UIImage imageNamed:@"unchose.png"];
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
