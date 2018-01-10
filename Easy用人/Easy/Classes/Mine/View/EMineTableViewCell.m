//
//  EMineTableViewCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMineTableViewCell.h"

@implementation EMineCellModel

@end

@interface EMineTableViewCell()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
/// 提示label
@property (nonatomic, strong) UILabel *leftHintLabel;
@property (nonatomic, strong) UILabel *rightHintLabel;
@end

@implementation EMineTableViewCell
- (UILabel *)rightHintLabel{
    if (_rightHintLabel == nil) {
        _rightHintLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#ff4f4f"] text:@"" textAlignment:0];
    }
    return _rightHintLabel;
}

- (UILabel *)leftHintLabel{
    if (_leftHintLabel == nil) {
        _leftHintLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#ff4f4f"] text:@"" textAlignment:0];
    }
    return _leftHintLabel;
}

- (UILabel *)leftLabel{
    if (_leftLabel == nil) {
        
        _leftLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"" textAlignment:0];
    }
    return _leftLabel;
}
- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc]init];
       
    }
    return _arrowImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(E_RealWidth(10));
    }];
    
    self.arrowImageView.image = [UIImage imageNamed:@"mine_jiantou"];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-E_RealWidth(10));
    }];
    
    [self.contentView addSubview:self.leftHintLabel];
    [self.leftHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(E_RealWidth(10));
    }];
    
    [self.contentView addSubview:self.rightHintLabel];
    [self.rightHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-E_RealWidth(10));
    }];

}

- (void)setModel:(EMineCellModel *)model{
    _model = model;
    self.leftLabel.text = model.leftString;
    switch (model.style) {
        case hintPositionNone:
            
            break;
            
        case hintPositionLeft:
        {
            self.leftHintLabel.text = model.hintString;
        }
            break;
            
        case hintPositionRight:
        {
            self.rightHintLabel.text = model.hintString;
        }
            break;
            
        default:
            break;
    }
}


@end
