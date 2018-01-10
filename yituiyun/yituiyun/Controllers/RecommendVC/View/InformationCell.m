//
//  InformationCell.m
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "InformationCell.h"
#import "InformationModel.h"

@interface InformationCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation InformationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"InformationCell";
    InformationCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[InformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 15, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 36)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.numberOfLines = 2;
    _nameLabel.textColor = kUIColorFromRGB(0x404040);
    [self.contentView addSubview:_nameLabel];
    
    self.descLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 22)];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.textColor = kUIColorFromRGB(0x808080);
    [self.contentView addSubview:_descLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_descLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 22)];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = kUIColorFromRGB(0x808080);
    [self.contentView addSubview:_timeLabel];
}

- (void)setInfoModel:(InformationModel *)infoModel
{
    _infoModel = infoModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:infoModel.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    _nameLabel.text = infoModel.title;
    
    _descLabel.text = infoModel.desc;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //时间戳转换成时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[infoModel.time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    _timeLabel.text = confromTimespStr;
}

@end
