//
//  FXInsureListCell.m
//  yituiyun
//
//  Created by fx on 16/12/3.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXInsureListCell.h"

@interface FXInsureListCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *taskLabel;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *buyLabel;
@property (nonatomic, strong) UIView *imgBackView;

@end
@implementation FXInsureListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"FXInsureListCell";
    FXInsureListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[FXInsureListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12.5, 55, 55)];
        self.typeLabel.textColor = MainColor;
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        self.typeLabel.font = [UIFont systemFontOfSize:13];
        self.typeLabel.layer.borderWidth = 1;
        self.typeLabel.layer.borderColor = MainColor.CGColor;
        self.typeLabel.layer.cornerRadius = self.typeLabel.frame.size.height / 2;
        self.typeLabel.clipsToBounds = YES;
        [self.contentView addSubview:self.typeLabel];
        
        self.taskLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame) + 10, 30, 200, 20)];
        self.taskLabel.textColor = kUIColorFromRGB(0x404040);
        self.taskLabel.textAlignment = NSTextAlignmentLeft;
        self.taskLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.taskLabel];
        
        UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.taskLabel.frame) + 30, ScreenWidth, 1)];
        lineFirView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:lineFirView];
        
        self.startLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineFirView.frame) + 5, ScreenWidth - 20, 20)];
        self.startLabel.textColor = kUIColorFromRGB(0x404040);
        self.startLabel.textAlignment = NSTextAlignmentLeft;
        self.startLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.startLabel];
        
        self.endLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.startLabel.frame) + 5, ScreenWidth - 20, 20)];
        self.endLabel.textColor = kUIColorFromRGB(0x404040);
        self.endLabel.textAlignment = NSTextAlignmentLeft;
        self.endLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.endLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.endLabel.frame) + 5, ScreenWidth - 20, 20)];
        self.priceLabel.textColor = kUIColorFromRGB(0x404040);
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.priceLabel];
        
        UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame) + 10, ScreenWidth, 1)];
        lineSecView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:lineSecView];
        
        self.buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineSecView.frame) + 10, ScreenWidth - 20, 20)];
        self.buyLabel.textColor = kUIColorFromRGB(0x808080);
        self.buyLabel.textAlignment = NSTextAlignmentLeft;
        self.buyLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.buyLabel];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.buyLabel.frame) + 5, ScreenWidth - 20, 20)];
        tipLabel.text = @"购买凭证:";
        tipLabel.textColor = kUIColorFromRGB(0x808080);
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:tipLabel];
        
        self.imgBackView = [[UIView alloc]init];
        [self.contentView addSubview:self.imgBackView];
        
    }
    return self;
}

- (void)setInsureModel:(FXInsureListModel *)insureModel{
    _insureModel = insureModel;
    
    if ([_insureModel.insureType isEqualToString:@"1"]) {
        _typeLabel.text = @"工资险";
    }else{
        _typeLabel.text = @"人身险";
    }
    _taskLabel.text = _insureModel.taskName;
    _startLabel.text = [NSString stringWithFormat:@"保险开始时间:%@",_insureModel.startTime];
    _endLabel.text = [NSString stringWithFormat:@"保险结束时间:%@",_insureModel.endTime];
    _priceLabel.text = [NSString stringWithFormat:@"购买金额:¥%@",_insureModel.price];
    _buyLabel.text = [NSString stringWithFormat:@"购买时间:%@",_insureModel.buyTime];
    
    //凭证图片
    for (UIView *view in _imgBackView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imgWidth = (ScreenWidth - 80) / 4;
    if (_insureModel.imgUrlArray.count > 0) {
        _imgBackView.hidden = NO;
        for (int i = 0; i < _insureModel.imgUrlArray.count; i++) {
            NSDictionary *imgDic = _insureModel.imgUrlArray[i];
            UIButton* imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(i * (imgWidth + 20) + 10, 0, imgWidth, 55);
            //            imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageButton.imageView.clipsToBounds = true;
            imageButton.tag = i;
            [imageButton sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:imgDic[@"url"]]] forState:UIControlStateNormal placeholderImage:nil];
            [imageButton addTarget:self action:@selector(imageButtonDown:) forControlEvents:UIControlEventTouchUpInside];
            [_imgBackView addSubview:imageButton];
        }
    }
    if (_insureModel.imgUrlArray.count > 0) {
        _imgBackView.hidden = NO;
        self.imgBackView.frame = CGRectMake(0, CGRectGetMaxY(_buyLabel.frame) + 30, ScreenWidth, 60);
        
    }else{
        _imgBackView.hidden = YES;
    }

    
}

//图片预览
- (void)imageButtonDown:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageClickWithIndex:WithIndexPath:)]) {
        [self.delegate imageClickWithIndex:button.tag WithIndexPath:self.indexPath];
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
