//
//  MyLogCell.m
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "MyLogCell.h"
#import "InformationModel.h"
#import "ZQImageAndLabelButton.h"

@interface MyLogCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ZQImageAndLabelButton *button;
@end

@implementation MyLogCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"MyLogCell";
    MyLogCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeView];
        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:headerLongPress];
    }
    return self;
}

- (void)makeView{
    
    self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 15, 15, 15)];
    _iconView.image = [UIImage imageNamed:@"logTag"];
    [self.contentView addSubview:_iconView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 30 - 80, 45)];
    _nameLabel.numberOfLines = 2;
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = kUIColorFromRGB(0x404040);
    [self.contentView addSubview:_nameLabel];
    
    self.button = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 12 - 80, 0, 80, 45)];
    _button.imageV.frame = ZQ_RECT_CREATE(0, 15, 15, 15);
    _button.imageV.image = [UIImage imageNamed:@"workTime"];
    _button.label.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_button.imageV.frame), 0, CGRectGetWidth(_button.frame) - CGRectGetMaxX(_button.imageV.frame), 45);
    _button.label.font = [UIFont systemFontOfSize:15];
    _button.label.textAlignment = NSTextAlignmentCenter;
    _button.label.textColor = kUIColorFromRGB(0xf16156);
    [self.contentView addSubview:_button];
    
    self.descLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - 24, 22)];
    _descLabel.font = [UIFont systemFontOfSize:15];
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = kUIColorFromRGB(0x808080);
    [self.contentView addSubview:_descLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, CGRectGetMaxY(_descLabel.frame), ZQ_Device_Width - 24, 22)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:_timeLabel];
}

- (void)setInfoModel:(InformationModel *)infoModel
{
    _infoModel = infoModel;
    
    _nameLabel.text = infoModel.title;
    
    _button.label.text = infoModel.jobDuration;
    
    _descLabel.text = infoModel.desc;
    CGSize describeSize = [_descLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ZQ_Device_Width - 24, MAXFLOAT)];
    _descLabel.frame = ZQ_RECT_CREATE(12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - 24, describeSize.height + 20);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //时间戳转换成时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[infoModel.time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    NSString *string = nil;
    if ([infoModel.field integerValue] == 1) {
        string = @"内勤";
    } else if ([infoModel.field integerValue] == 2) {
        string = @"外勤";
    }
    if ([ZQ_CommonTool isEmpty:string]) {
        _timeLabel.text = [NSString stringWithFormat:@"%@", confromTimespStr];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@    %@", string, confromTimespStr];
    }
    _timeLabel.frame = ZQ_RECT_CREATE(12, CGRectGetMaxY(_descLabel.frame), ZQ_Device_Width - 24, 22);
    
    _height = CGRectGetMaxY(_timeLabel.frame) + 10;

}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(longPressCellWithIndexPath:)])
        {
            [_delegate longPressCellWithIndexPath:self.indexPath];
        }
    }
}


@end
