//
//  EMyCommentCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMyCommentCell.h"
#import "JXStarRatingView.h"
#import "EMyCommentModel.h"

@interface EMyCommentCell()
@property (nonatomic, strong) UILabel *hotelLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) JXStarRatingView *starView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation EMyCommentCell
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    [super setFrame:frame];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.hotelLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#434343"] text:@"" textAlignment:0];
    [self.contentView addSubview:self.hotelLabel];
    [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.jobLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"#434343"] text:@"" textAlignment:0];
    [self.contentView addSubview:self.jobLabel];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hotelLabel);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.hotelLabel.mas_bottom).offset(11);
    }];
    
    UILabel *comMsgLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"#737373"] text:@"酒店评价:" textAlignment:0];
    [self.contentView addSubview:comMsgLabel];
    [comMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hotelLabel);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    
    self.starView = [[JXStarRatingView alloc]init];
    self.starView.backgroundImage = [UIImage imageNamed:@"mine_backStar"];
    self.starView.foregroundImage = [UIImage imageNamed:@"mine_foreStar"];
    self.starView.style = JXStarRatingWholeStarStyle;
    self.starView.starMargin = 9;

    [self.contentView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(comMsgLabel);
        make.left.mas_equalTo(comMsgLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
    
    self.commentLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#737373"] text:@"" textAlignment:0];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.preferredMaxLayoutWidth = kScreenW - 20;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hotelLabel);
        make.right.mas_equalTo(self.jobLabel);
        make.top.mas_equalTo(comMsgLabel.mas_bottom).offset(14);
    }];
    
    
    
    self.timeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHexString:@"#737373"] text:@"" textAlignment:0];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.commentLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.contentView).offset(-15).priority(200);
    }];
    
}


- (void)setModel:(EMyCommentModel *)model{
    _model = model;
    self.hotelLabel.text = model.hotelName;
    self.jobLabel.text = @"服务员";
    self.timeLabel.text = [model.addTime timeIntervalWithFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.commentLabel.text = model.content;
    self.starView.progress = [model.star floatValue];
}

@end
