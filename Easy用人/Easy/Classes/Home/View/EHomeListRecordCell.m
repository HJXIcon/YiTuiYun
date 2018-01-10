//
//  EHomeListRecordCell.m
//  Easy
//
//  Created by yituiyun on 2017/11/27.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeListRecordCell.h"
#import "EHomeListModel.h"

@interface EHomeListRecordCell()
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *jobLabel;

@end

@implementation EHomeListRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    CGSize size = CGSizeMake(kScreenW / 5, CGRectGetHeight(self.frame));
    self.dayLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"2017\n11-09" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.dayLabel];
//    CGSize daySize =  [@"09-11" sizeWithFont:[UIFont systemFontOfSize:E_FontRadio(12)] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.dayLabel.numberOfLines = 2;
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
//        make.left.mas_equalTo(self.contentView).offset(20);
//        make.size.mas_equalTo(CGSizeMake(ceil(daySize.width), ceil(daySize.height) * 2));
        make.size.mas_equalTo(size);
    }];
    
    
    self.timeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"起08:57:51\n止08:57:51" textAlignment:NSTextAlignmentCenter];
    self.timeLabel.numberOfLines = 2;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(kScreenW / 5 - 20, self.contentView.height));
         make.size.mas_equalTo(size);
    }];
    
    self.numLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"78" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(60, 44));
         make.size.mas_equalTo(size);
    }];
    
    self.moneyLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"78" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(60, 44));
         make.size.mas_equalTo(size);
    }];
    
    
    UIView *jobView = [[UIView alloc]init];
    [self.contentView addSubview:jobView];
    [jobView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        //        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.size.mas_equalTo(size);
    }];
    
    self.jobLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(12)] textColor:[UIColor colorWithHexString:@"#7a7a7a"] text:@"服务员" textAlignment:NSTextAlignmentCenter];
    [jobView addSubview:self.jobLabel];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(jobView);
        make.right.mas_equalTo(jobView.mas_right).offset(-10);
    }];
    
    
    
    [self.contentView masonry_distributeSpacingHorizontallyWith:@[self.dayLabel,self.timeLabel,self.numLabel,self.moneyLabel,jobView]];
    
    
}

- (void)setModel:(EHomeListModel *)model{
    _model = model;
    self.dayLabel.text = [model.add_time timeIntervalWithFormat:@"yyyy\nMM-dd"];
    self.timeLabel.text = [NSString stringWithFormat:@"起%@\n止%@",[model.start_time timeIntervalWithFormat:@"hh:mm:ss"],[model.end_time timeIntervalWithFormat:@"hh:mm:ss"]];
    
    self.moneyLabel.text = model.total_price;
    self.jobLabel.text = model.demand_title;
    self.numLabel.text = kStringIsEmpty(model.room_num) ? [NSString stringWithFormat:@"%0.f",[model.duration floatValue] / 3600] : model.room_num;
    
    
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
