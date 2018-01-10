

//
//  MineTableViewCell.m
//  dongmibangshou
//
//  Created by LUKHA_Lu on 16/2/17.
//  Copyright © 2016年 KNKane. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:headerLongPress];
        
        _leftImage = [[UIImageView alloc] init];
        _leftImage.clipsToBounds = YES;
        _leftImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_leftImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(52, 0, 70, 44)];
        _titleLabel.textColor = kUIColorFromRGB(0x808080);
        _titleLabel.font = [UIFont systemFontOfSize:fontradio(15)];
        [self.contentView addSubview:_titleLabel];
        
        _redView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_titleLabel.frame) + 5, 17, 10, 10)];
        _redView.backgroundColor = [UIColor redColor];
        [[_redView layer] setCornerRadius:5];
        [[_redView layer] setMasksToBounds:YES];
        [self.contentView addSubview:_redView];
        _jianzhinumberLabel = [[UILabel alloc]initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_titleLabel.frame) +5, 13, 14, 14)];
        _jianzhinumberLabel.backgroundColor = UIColorFromRGBString(@"0xf16156");
        _jianzhinumberLabel.textColor = [UIColor whiteColor];
        _jianzhinumberLabel.text = @"0";
        _jianzhinumberLabel.font = [UIFont systemFontOfSize:12];
        _jianzhinumberLabel.textAlignment = NSTextAlignmentCenter;
        _jianzhinumberLabel.layer.cornerRadius = 7;
        _jianzhinumberLabel.clipsToBounds = YES;
        
//        _jianzhinumberLabel.hidden = YES;
        [self.contentView addSubview:_jianzhinumberLabel];
        
        _detaiLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_titleLabel.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_titleLabel.frame) - 45, 44)];
        _detaiLabel.textColor = kUIColorFromRGB(0x808080);
        _detaiLabel.textAlignment = NSTextAlignmentRight;
        _detaiLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_detaiLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ZQ_Device_Width, 1)];
        _lineView.backgroundColor = kUIColorFromRGB(0xeeeeee);
        
        
        [self.contentView addSubview:_lineView];
    }
    return self;
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

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(WRadio(13));
        make.width.height.mas_equalTo(@(WRadio(20)));

    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.leftImage.mas_right).offset(WRadio(20));

    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(@(WRadio(1)));
    
    }];
    
}

@end
