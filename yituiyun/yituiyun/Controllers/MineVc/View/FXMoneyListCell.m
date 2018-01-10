//
//  FXMoneyListCell.m
//  yituiyun
//
//  Created by fx on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXMoneyListCell.h"

@interface FXMoneyListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *numLabel;

@end
@implementation FXMoneyListCell

+ (instancetype)moneyListCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"FXMoneyListCell";
    FXMoneyListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FXMoneyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth / 2, 20)];
        self.titleLabel.textColor = kUIColorFromRGB(0x404040);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, ScreenWidth / 2, 20)];
        self.timeLable.textColor = kUIColorFromRGB(0xababab);
        self.timeLable.textAlignment = NSTextAlignmentLeft;
        self.timeLable.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.timeLable];
        
        self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 110, 25, 100, 20)];
        self.numLabel.textAlignment = NSTextAlignmentRight;
        self.numLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}
- (void)setListModel:(FXMoneyListModel *)listModel{
    _listModel = listModel;
    
    self.titleLabel.text = listModel.itemTitle;
    self.timeLable.text = listModel.time;
    self.numLabel.text = listModel.num;
    if ([listModel.num intValue] < 0) {
        self.numLabel.textColor = MainColor;
    }else{
        self.numLabel.textColor = [UIColor colorWithR:97 G:153 B:110];
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
