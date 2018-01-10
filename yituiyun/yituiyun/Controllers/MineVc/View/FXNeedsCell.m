//
//  FXNeedsCell.m
//  yituiyun
//
//  Created by fx on 16/11/1.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXNeedsCell.h"

@interface FXNeedsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end
@implementation FXNeedsCell

+ (instancetype)needsCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"FXNeedsCell";
    FXNeedsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FXNeedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth / 2, 40)];
        _titleLabel.textColor = kUIColorFromRGB(0x404040);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 5, ScreenWidth / 2, 20)];
        _timeLabel.textColor = kUIColorFromRGB(0xababab);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 200, 22.5, 190, 20)];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_statusLabel];
        
        
    }
    return self;
}

- (void)setNeedsModel:(FXNeedsModel *)needsModel{
    _needsModel = needsModel;
    
    _titleLabel.text = _needsModel.needsTitle;
    _timeLabel.text = _needsModel.needsTime;
    if ([needsModel.certificate isEqualToString:@""]) {
        if ([_needsModel.needsStatus isEqualToString:@"2"]) {
            _statusLabel.text = @"待上传付款凭证";
            _statusLabel.textColor = MainColor;
        }else if ([_needsModel.needsStatus isEqualToString:@"0"]){
            _statusLabel.text = @"需求审核中";
            _statusLabel.textColor = [UIColor colorWithR:112 G:190 B:142];
        }else if ([_needsModel.needsStatus isEqualToString:@"1"]){
            _statusLabel.text = @"需求未通过";
            _statusLabel.textColor = kUIColorFromRGB(0xababab);
        }else if ([_needsModel.needsStatus intValue] > 5){
            _statusLabel.text = @"待上传付款凭证";
            _statusLabel.textColor = MainColor;
        }
    }else if ([needsModel.certificate isEqualToString:@"3"]){
        _statusLabel.text = @"凭证审核中";
        _statusLabel.textColor = [UIColor colorWithR:112 G:190 B:142];
    }else if ([needsModel.certificate isEqualToString:@"4"]){
        _statusLabel.text = @"凭证未通过";
        _statusLabel.textColor = kUIColorFromRGB(0xababab);
    }else if ([needsModel.certificate isEqualToString:@"5"]){
        _statusLabel.text = @"已完成";
        _statusLabel.textColor = kUIColorFromRGB(0x404040);
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
