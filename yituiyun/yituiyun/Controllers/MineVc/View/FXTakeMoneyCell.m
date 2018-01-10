//
//  FXTakeMoneyCell.m
//  yituiyun
//
//  Created by fx on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXTakeMoneyCell.h"

@interface FXTakeMoneyCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *choseView;

@end
@implementation FXTakeMoneyCell

+ (instancetype)takeMoneyCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"FXTakeMoneyCell";
    FXTakeMoneyCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FXTakeMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 30, 30)];
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
        Button.frame = CGRectMake(ScreenWidth - 100, 0, 80, 80);
        [Button addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:Button];
        
        self.choseView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 20, 20)];
        [Button addSubview:self.choseView];
        
    }
    return self;
}
- (void)setTakeMoneyModel:(CardListModel *)takeMoneyModel{
    _takeMoneyModel = takeMoneyModel;
    
    
    
    if (self.indexPath.section == 0) {
        
        if ([ZQ_CommonTool isEmpty:takeMoneyModel.alicode]) {
            
            self.describeLabel.text = @"推荐支付宝用户使用";
            self.titleLabel.text = @"支付宝";
            
        }else{
            self.describeLabel.text = takeMoneyModel.alicode;
            self.titleLabel.text = takeMoneyModel.aliname;
        }
        
        
        self.titleLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, 12.5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20);
        self.describeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMaxY(_titleLabel.frame) + 5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20);
        self.iconView.image = [UIImage imageNamed:@"zhifubao-"];
                
    }else{
        
        if (takeMoneyModel.cardcode.length>5) {
            NSString *cardCode = [takeMoneyModel.cardcode substringFromIndex:takeMoneyModel.cardcode.length - 4];
            
            self.describeLabel.text = [NSString stringWithFormat:@"尾号%@",cardCode];
        }else{

            self.describeLabel.text = @"尾号0000";
        }
        

        self.titleLabel.text = takeMoneyModel.bankName;
        self.titleLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, 12.5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20);
        self.describeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 10, CGRectGetMaxY(_titleLabel.frame) + 5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 20, 20);
        self.iconView.image = [UIImage imageNamed:@"yinhangkazhifu-"];

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

@end
