//
//  EStatisticalTableCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EStatisticalTableCell.h"
#import "EStatisticalTableModel.h"

@interface EStatisticalTableCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation EStatisticalTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    CGSize size = CGSizeMake(kScreenW / 5, CGRectGetHeight(self.frame));
    self.nameLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"2017\n11-09" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(size);
    }];
    
    
    self.startTimeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"08:57:51" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.startTimeLabel];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(size);
    }];
    
    self.endTimeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"78" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.endTimeLabel];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        //        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.size.mas_equalTo(size);
    }];
    
    self.numLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"78" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(size);
    }];
    
    self.moneyLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"20" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(size);
    }];
    
    [self.contentView masonry_distributeSpacingHorizontallyWith:@[self.nameLabel,self.startTimeLabel,self.endTimeLabel,self.numLabel,self.moneyLabel]];
    
}

- (void)setModel:(EStatisticalTableModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.numLabel.text = model.room_num;
    
    self.startTimeLabel.text = kStringIsEmpty(model.start_time) ? @"" : [model.start_time timeIntervalWithFormat:@"hh:mm:ss"];
    self.endTimeLabel.text = kStringIsEmpty(model.end_time) ? @"" : [model.end_time timeIntervalWithFormat:@"hh:mm:ss"];
    
    if (kStringIsEmpty(model.start_time) || kStringIsEmpty(model.end_time)) {
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#ff6868"];
        self.moneyLabel.text = @"未打卡";
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }else{
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#7a7a7a"];
        self.moneyLabel.text = model.total_price;
        self.contentView.backgroundColor = [UIColor whiteColor];
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
