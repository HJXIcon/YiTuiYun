

//
//  NotificationMessageCell.m
//  yituiyun
//
//  Created by LUKHA_Lu on 16/2/17.
//  Copyright © 2016年 KNKane. All rights reserved.
//

#import "NotificationMessageCell.h"
#import "NotificationMessageModel.h"

@interface NotificationMessageCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *nestView;
@end

@implementation NotificationMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *const identifier = @"NotificationMessageCell";
    NotificationMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NotificationMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        [self makeView];
    }
    return self;
}

- (void)makeView
{
    self.timeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(0, 10, ZQ_Device_Width, 25)];
    _timeLabel.textColor = kUIColorFromRGB(0x808080);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLabel];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame), ZQ_Device_Width, 1)];
    _backView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.contentView addSubview:_backView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, 0, ZQ_Device_Width - 44, 50)];
    _titleLabel.textColor = kUIColorFromRGB(0x404040);
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_backView addSubview:_titleLabel];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, CGRectGetMaxY(_titleLabel.frame), ZQ_Device_Width - 44, 20)];
    _describeLabel.textColor = kUIColorFromRGB(0x808080);
    _describeLabel.numberOfLines = 0;
    _describeLabel.font = [UIFont systemFontOfSize:14];
    [_backView addSubview:_describeLabel];
    
    self.nestView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_arrows_right"]];
    [_backView addSubview:_nestView];
}

- (void)setMessageModel:(NotificationMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //时间戳转换成时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[messageModel.time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    _timeLabel.text = confromTimespStr;
    
    _titleLabel.text = messageModel.title;
    
    _describeLabel.text = [NSString stringWithFormat:@"%@", messageModel.describe];
    CGSize describeSize = [_describeLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 44 - 25, MAXFLOAT)];
    _describeLabel.frame = ZQ_RECT_CREATE(12, CGRectGetMaxY(_titleLabel.frame), ZQ_Device_Width - 44 - 25, describeSize.height);
    
    _nestView.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 30, CGRectGetMaxY(_describeLabel.frame) - CGRectGetHeight(_describeLabel.frame)/2 - 6.5, 8, 13);
    
    _backView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_timeLabel.frame), ZQ_Device_Width, CGRectGetMaxY(_describeLabel.frame) + 10);
    
    NSInteger key = [messageModel.type integerValue];
    if (key == 2) {
        _nestView.hidden = YES;
    } else {
        _nestView.hidden = NO;
    }
    
    _height = CGRectGetMaxY(_backView.frame);
}
@end
