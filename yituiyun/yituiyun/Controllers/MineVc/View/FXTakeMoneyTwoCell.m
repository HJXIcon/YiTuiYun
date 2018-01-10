//
//  FXTakeMoneyCell.m
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXTakeMoneyTwoCell.h"

@interface FXTakeMoneyTwoCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *choseView;

@end
@implementation FXTakeMoneyTwoCell

+ (instancetype)takeMoneyCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"FXTakeMoneyTwoCell";
    FXTakeMoneyTwoCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FXTakeMoneyTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
        [self.contentView addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 10, 12.5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20)];
        self.titleLabel.textColor = kUIColorFromRGB(0x404040);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        self.describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMaxY(_titleLabel.frame) + 5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20)];
        self.describeLabel.textColor = kUIColorFromRGB(0xababab);
        self.describeLabel.textAlignment = NSTextAlignmentLeft;
        self.describeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.describeLabel];
        
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
        Button.frame = CGRectMake(ScreenWidth - 70, 0, 70, 70);
        [Button addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:Button];
        
        self.choseView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 20, 20)];
        [Button addSubview:self.choseView];
        
    }
    return self;
}
- (void)setTakeMoneyModel:(FXTakeMoneyModel *)takeMoneyModel{
    _takeMoneyModel = takeMoneyModel;
    
    self.iconView.image = [UIImage imageNamed:takeMoneyModel.iconImg];
    self.titleLabel.text = takeMoneyModel.title;
    
    if (![ZQ_CommonTool isEmpty:takeMoneyModel.describeStr]) {
        self.describeLabel.text = takeMoneyModel.describeStr;
        self.titleLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, 12.5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20);
        self.describeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMaxY(_titleLabel.frame) + 5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20);
    } else {
        self.describeLabel.text = @"";
        self.titleLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 70);
        self.describeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMaxY(_titleLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 0.000000001);
    }
    
    if ([takeMoneyModel.isChose integerValue] == 1) {
        self.choseView.image = [UIImage imageNamed:@"chose"];
    } else {
        self.choseView.image = [UIImage imageNamed:@"unchose"];
    }
}

- (void)buttonClick
{
    if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(buttonClickWithIndexPath:)]) {
        [_delegate buttonClickWithIndexPath:_indexPath];
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
