//
//  ZHPriseTableViewCell.m
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/9/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZHPriseTableViewCell.h"
#import "CommentsModel.h"
#import "CollectModel.h"

@interface ZHPriseTableViewCell ()
@property (nonatomic, strong) UIImageView *replyBackgroundView;
@property (nonatomic, assign) CGFloat replayBtnY;


@end

@implementation ZHPriseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.replyBackgroundView = [[ UIImageView alloc] init];
        _replyBackgroundView.clipsToBounds = true;
        _replyBackgroundView.userInteractionEnabled = true;
        [self.contentView addSubview:_replyBackgroundView];
        
        self.lineView = [[UIView alloc] init];
        _lineView.hidden = true;
        _lineView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)setModel:(CommentsModel *)model{
    _model = model;
    
    for (UIView *view in _replyBackgroundView.subviews) {
        [view removeFromSuperview];
    }
    if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
        NSInteger j = 0.0;
        NSInteger k = 0.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"thumbUp"];
        [_replyBackgroundView addSubview:imageView];
        
        for (int i = 0; i < model.praiseArray.count; i ++) {
            CollectModel *collModel = model.praiseArray[i];
            NSString *string = collModel.collectHeadtrid;
            UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (30 * j + 30 <= (ZQ_Device_Width - 59 + 36.75 - 51 - CGRectGetMaxX(imageView.frame))) {
                Button.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 12 + 30 * j,  30 * k + 10, 20, 20);
                j ++;
            } else {
                j = 0.0;
                k ++;
                Button.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 12 + 30 * j,  30 * k + 10, 20, 20);
                j ++;
            }
            Button.tag = 1000 + i;
            Button.clipsToBounds = true;
            [Button addTarget:self action:@selector(goToPerson:) forControlEvents:UIControlEventTouchUpInside];
            Button.layer.cornerRadius = Button.width/2;
            Button.imageView.clipsToBounds = true;
            Button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [Button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, string]] forState:UIControlStateNormal placeholderImage:nil];
            [_replyBackgroundView addSubview:Button];
            _replayBtnY = CGRectGetMaxY(Button.frame);
        }
        _replyBackgroundView.frame = ZQ_RECT_CREATE(39 + 12, 0, ZQ_Device_Width - 59 + 36.75 - 51, _replayBtnY + 5);
        _replyBackgroundView.image = [[UIImage imageNamed:@"bubbleSomeone"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
        _lineView.frame = CGRectMake(CGRectGetMinX(_replyBackgroundView.frame), CGRectGetMaxY(_replyBackgroundView.frame), CGRectGetWidth(_replyBackgroundView.frame), 0.5);
    } else {
        _replyBackgroundView.frame = ZQ_RECT_CREATE(0, 10, ZQ_Device_Width, 0.00001);
        _replayBtnY = 0.0001;
        _replyBackgroundView.image = nil;
    }
    model.priseCellH = CGRectGetMaxY(_replyBackgroundView.frame)+10;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)goToPerson:(UIButton*)button{
    
    if (_deleagete && [_deleagete respondsToSelector:@selector(goToPerson:WithPerTag:)]) {
        [_deleagete goToPerson:self.indexPath WithPerTag: button.tag - 1000];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
