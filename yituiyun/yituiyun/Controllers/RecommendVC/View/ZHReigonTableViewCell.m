//
//  ZHReigonTableViewCell.m
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/12/16.
//  Copyright © 2016年 ganruihao. All rights reserved.
//

#import "ZHReigonTableViewCell.h"
#import "CommentsModel.h"

@interface ZHReigonTableViewCell ()


@end
@implementation ZHReigonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 时间
        self.timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = kUIColorFromRGB(0x888888);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        self.deleateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleateBtn setTitleColor:kUIColorFromRGB(0x216fc6) forState:UIControlStateNormal];
        [_deleateBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _deleateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _deleateBtn.tag = 1000;
        [_deleateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleateBtn];
        
        //出现的btnView
        self.btnView = [[UIView alloc] init];
        _btnView.hidden = true;
        _btnView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:_btnView];
        
//        // 定位的button
//        self.reginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.contentView addSubview:_reginButton];
//        
//        self.reginImage = [[UIImageView alloc] init];
//        [_reginButton addSubview:_reginImage];
//        
//        self.reginLabel = [[UILabel alloc] init];
//        _reginLabel.numberOfLines = 0;
//        [_reginButton addSubview:_reginLabel];
        
        // 出现更多的View
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.tag = 1004;
        [self.contentView addSubview:_moreButton];
        
        self.moreImage = [[UIImageView alloc] init];
        _moreImage.image = [UIImage imageNamed:@"more_comment"];
        [_moreButton addSubview:_moreImage];
        // 九张图片的背景View
    }
    return self;
}

- (void)setCommentsModel:(CommentsModel *)commentsModel{
    
//    if (![ZQ_CommonTool isEmpty:commentsModel.region]) {
//        _reginLabel.text = commentsModel.region;//地区
//        CGSize nameSize = [ _reginLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 13 - 12 - 51, MAXFLOAT)];
//        _reginLabel.frame = CGRectMake(13 + 5 + 51, 10,  ZQ_Device_Width - 13 - 12 - 51, nameSize.height);
//        _reginLabel.textColor = kUIColorFromRGB(0x858585);
//        _reginLabel.font = [UIFont systemFontOfSize:13];
//        _reginImage.image = [UIImage imageNamed:@"lc_icon"];
//        _reginImage.frame = CGRectMake(51, CGRectGetMinY(_reginLabel.frame) + 2, 16*2/3, 22*2/3);
//        _reginImage.centerY = _reginLabel.centerY;
//    } else {
//        _reginImage.image = [UIImage imageNamed:@""];
//        _reginLabel.text = @"";
//        _reginImage.frame = CGRectMake(51, 10, 13, 22*13/18);
//        _reginLabel.frame = CGRectMake(CGRectGetMaxX(_reginImage.frame) + 5, 10, ZQ_Device_Width - CGRectGetMaxX(_reginImage.frame) - 12, 0);
//    }
    
    CGFloat shortTime = 10.0;
    
    //时间
    NSString *string = [NSDate distanceTimeWithBeforeTime:commentsModel.evaluationTime.doubleValue];
    _timeLabel.text = string;
    CGSize dateSize = [_timeLabel.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 25)];
    
    _timeLabel.frame = CGRectMake(12 + 27 + 12, 10, dateSize.width, 25);
    
    _deleateBtn.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame) + 20, shortTime, 60, 25);
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    if ([commentsModel.evaluationId integerValue] == [infoModel.userID integerValue]) {
        _deleateBtn.hidden = NO;
    } else {
        _deleateBtn.hidden = YES;
    }
    
    //点击出现更多的View
    self.moreButton.frame = CGRectMake(ZQ_Device_Width - 59, shortTime - 5, 49, 32);
    _moreImage.frame = CGRectMake(49/2 - 49/4, (32 - 32/2)/2, 49/2, 32/2);
    
    commentsModel.reginHeight = CGRectGetMaxY(_moreButton.frame) + 10;
    

    /** 收藏与关注的三个按钮的tag值 */
    for (UIView *view in _btnView.subviews) {
        [view removeFromSuperview];
    }
    
    if ([commentsModel.isEditMore isEqualToString:@"0"]) {
        _btnView.hidden = true;
    } else if ([commentsModel.isEditMore isEqualToString:@"1"]) {
        _btnView.hidden = false;
    }
    _btnView.backgroundColor = MainColor;
    _btnView.frame = CGRectMake(CGRectGetMinX(_moreButton.frame) - 34 - 20*3 - 25*2, CGRectGetMidY(_moreButton.frame) - 20, 34 + 20*3 + 25*2, 40);
    _btnView.layer.cornerRadius = 2;
    _btnView.layer.borderWidth = 1.0;
    _btnView.layer.borderColor = kUIColorFromRGB(0xe0e0e0).CGColor;
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_btnView.width/3*i, 0, _btnView.width/3, 40);
        button.tag = 1001 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_btnView addSubview:button];

        UIImageView *imageV = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(_btnView.width/3/2-10, 10, 20, 20)];
        //判断点赞
        if (i == 0) {
            if ([commentsModel.isPrise isEqualToString:@"1"]) {
                imageV.image = [UIImage imageNamed:@"zan_icon_pro"];
            } else {
                imageV.image = [UIImage imageNamed:@"zan_icon_nor"];
            }
        }
        if (i == 1) {
            imageV.image = [UIImage imageNamed:@"cmt_icon1"];
        }
        if (i == 2) {
            imageV.image = [UIImage imageNamed:@"share"];
        }
        [button addSubview:imageV];
    }
}


//- (void)setCommentsModel:(CommentsModel *)commentsModel{
//
//    if (![ZQ_CommonTool isEmpty:commentsModel.region]) {
//        _reginImage.image = [UIImage imageNamed:@"lc_icon"];
//        _reginImage.frame = CGRectMake(51, 10, 13, 22*13/18);
//        _reginLabel.textColor = kUIColorFromRGB(0x858585);
//        _reginLabel.font = [UIFont systemFontOfSize:13];
//        _reginLabel.text = commentsModel.region;//地区
//        CGSize nameSize = [_reginLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - CGRectGetMaxX(_reginImage.frame) - 12, MAXFLOAT)];
//        _reginLabel.frame = CGRectMake(CGRectGetMaxX(_reginImage.frame) + 5, 10, ZQ_Device_Width - CGRectGetMaxX(_reginImage.frame) - 12, nameSize.height);
//
//    } else {
//        _reginImage.image = [UIImage imageNamed:@""];
//        _reginLabel.text = @"";
//        self.reginButton.frame = CGRectMake(12 + 27 + 12, 5, ZQ_Device_Width, 1);
//    }
//    // 时间
//    NSString *string = [NSDate distanceTimeWithBeforeTime: commentsModel.evaluationTime.doubleValue];
//    _timeLabel.text = string;
//    CGSize dateSize = [_timeLabel.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 25)];
//    _timeLabel.frame = CGRectMake(12 + 27 + 12, CGRectGetMaxY(_reginButton.frame), dateSize.width, 25);
//
//    _deleateBtn.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame) + 20, CGRectGetMaxY(_reginButton.frame), 60, 25);
//
//    // 点击出现更多的View
//    self.moreButton.frame = CGRectMake(ZQ_Device_Width - 59, CGRectGetMaxY(_reginButton.frame) - 5, 49, 32);
//    _moreImage.frame = CGRectMake((49 - 32/2)/2, (32 - 32/2)/2, 49/2, 32/2);
//
//    commentsModel.reginHeight = CGRectGetMaxY(_moreButton.frame) + 5;
//
//    /** 收藏与关注的三个按钮的tag值 */
//    for (UIView *view in _btnView.subviews) {
//        [view removeFromSuperview];
//    }
//
//    if ([commentsModel.isEditMore isEqualToString:@"0"]) {
//        _btnView.hidden = true;
//    } else if ([commentsModel.isEditMore isEqualToString:@"1"]) {
//        _btnView.hidden = false;
//    }
//    for (NSInteger i = 0; i < 2; i ++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(5 + 23*i + 20*i, 5, 23, 23);
//        button.layer.cornerRadius = button.width/2;
//        button.tag = 1001 + i;
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        //判断收藏与关注
//        if (i == 0) {
//            if ([commentsModel.isPrise isEqualToString:@"1"]) {
//                [button setBackgroundImage:[UIImage imageNamed:@"zan_icon_pro"] forState:UIControlStateNormal];
//            } else {
//                [button setBackgroundImage:[UIImage imageNamed:@"zan_icon_nor"] forState:UIControlStateNormal];
//            }
//        }
//        if (i == 1) {
//            [button setBackgroundImage:[UIImage imageNamed:@"cmt_icon"] forState:UIControlStateNormal];
//        }
//        if (i == 2) {
//            if ([commentsModel.isCollection isEqualToString:@"1"]) {
//                [button setBackgroundImage:[UIImage imageNamed:@"cet_icon_press"] forState:UIControlStateNormal];
//            } else {
//                [button setBackgroundImage:[UIImage imageNamed:@"collectionNO"] forState:UIControlStateNormal];
//            }
//        }
//        [_btnView addSubview:button];
//        _btnView.backgroundColor = kUIColorFromRGB(0xf5f5f5);
//        _btnView.frame = CGRectMake(CGRectGetMinX(_moreButton.frame) - 23*2 - 40 , CGRectGetMaxY(_reginButton.frame) - 5, 23*2 + 20*2, 33);
//        _btnView.layer.cornerRadius = 3;
//        _btnView.layer.borderWidth = 1.0;
//        _btnView.layer.borderColor = kUIColorFromRGB(0xe0e0e0).CGColor;
//    }
//}
//图片点击以及
- (void)buttonClick:(UIButton *)button{
    // 这个进入的赞的人
    if (_delegete && _indexPath && [_delegete respondsToSelector:@selector(btnPersonShowButtonClickWithIndex:WithBtnTag:)]) {
        [_delegete btnPersonShowButtonClickWithIndex:self.indexPath WithBtnTag:button];
    }
}
@end
