//
//  FXWorkPlaceCell.m
//  yituiyun
//
//  Created by fx on 16/10/29.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXWorkPlaceCell.h"

@interface FXWorkPlaceCell ()

@property (nonatomic, strong) UILabel *detailLabel;//最后一级地址
@property (nonatomic, strong) UILabel *buildLabel;//前缀地址
@property (nonatomic, strong) UIImageView *choseImgView;//选中图

@end
@implementation FXWorkPlaceCell

+ (instancetype)placeCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"FXWorkPlaceCell";
    FXWorkPlaceCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FXWorkPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth, 20)];
        _detailLabel.textColor = kUIColorFromRGB(0x404040);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_detailLabel];
        
        self.buildLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_detailLabel.frame), ScreenWidth, 20)];
        _buildLabel.textColor = kUIColorFromRGB(0xababab);
        _buildLabel.textAlignment = NSTextAlignmentLeft;
        _buildLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_buildLabel];
        
        self.choseImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 20, 20, 20)];
        _choseImgView.image = [UIImage imageNamed:@"chose.png"];
        [self.contentView addSubview:self.choseImgView];
        
    }
    return self;
}

- (void)setPlaceModel:(FXWorkPlaceModel *)placeModel{
    _placeModel = placeModel;
    
    _detailLabel.text = _placeModel.detailPlace;
    _buildLabel.text = _placeModel.buildPlace;
    
}

- (void)setIsChose:(BOOL)isChose{
    if (isChose) {
        _choseImgView.hidden = NO;
    }else{
        _choseImgView.hidden = YES;
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
