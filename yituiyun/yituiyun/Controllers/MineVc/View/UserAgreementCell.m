//
//  UserAgreementCell.m
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "UserAgreementCell.h"
#import "UserAgreementModel.h"

@interface UserAgreementCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation UserAgreementCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"UserAgreementCell";
    UserAgreementCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UserAgreementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 12.5, 15, 15)];
    _iconView.image = [UIImage imageNamed:@"userAgreement1"];
    [self.contentView addSubview:_iconView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 30 - 80, 40)];
    _nameLabel.numberOfLines = 2;
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = kUIColorFromRGB(0x404040);
    [self.contentView addSubview:_nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - 30 - 80, 20)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = kUIColorFromRGB(0x999999);
    [self.contentView addSubview:_timeLabel];
}

- (void)setUserAgreementModel:(UserAgreementModel *)userAgreementModel
{
    _userAgreementModel = userAgreementModel;
    
    _nameLabel.text = _userAgreementModel.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //时间戳转换成时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_userAgreementModel.time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@", confromTimespStr];
}

@end
