//
//  JXPunchClockAddressCell.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPunchClockAddressCell.h"

@interface JXPunchClockAddressCell ()
@property (nonatomic, assign) NSInteger rotatNum;
@end
@implementation JXPunchClockAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = kUIColorFromRGB(0x5e5e5e);
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [self.refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.refreshButton];
        
        self.addressLabel = [[UILabel alloc]init];
        self.addressLabel.textColor = kUIColorFromRGB(0x404040);
        self.addressLabel.font = [UIFont systemFontOfSize:15];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.addressLabel];
       
        self.addressNotRefrshLabel = [[UILabel alloc]init];
        self.addressNotRefrshLabel.textColor = kUIColorFromRGB(0x404040);
        self.addressNotRefrshLabel.font = [UIFont systemFontOfSize:15];
        self.addressNotRefrshLabel.numberOfLines = 0;
        self.addressNotRefrshLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.addressNotRefrshLabel];
        
        
        
    
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.width.mas_greaterThanOrEqualTo(60);
        }];
        
        [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.and.width.mas_equalTo(20);
            
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
            make.right.mas_equalTo(self.refreshButton.mas_left).offset(-10);
        }];
        
        
        [self.addressNotRefrshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
        
    }
    return self;
}

- (void)refreshButtonClick:(UIButton *)button{
    _rotatNum = 0;
    [self rotating:button];
    
    if (self.reloadAddressBlock) {
        self.reloadAddressBlock();
    }
}

//旋转
- (void)rotating:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        _rotatNum ++;
        view.transform = CGAffineTransformRotate(view.transform, M_PI);
    } completion:^(BOOL finished) {
        if (_rotatNum <= 3) {
            [self rotating:view];
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
