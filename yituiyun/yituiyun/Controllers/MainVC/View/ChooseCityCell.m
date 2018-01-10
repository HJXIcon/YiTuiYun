//
//  ChooseCityCell.m
//  同门艺人
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "ChooseCityCell.h"

@implementation ChooseCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.cityListArray = [NSMutableArray array];
        
//        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 44)];
//        [self.contentView addSubview:_backView];
        
        self.cityNameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(15, 0, ZQ_Device_Width - 30, 44)];
        _cityNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_cityNameLabel];
    }
    return self;
}

- (void)btnLayOut{
    
//    for (UIView *view in _backView.subviews) {
//        [view removeFromSuperview];
//    }
//    CGFloat x  = 0.0;
//    CGFloat y = 0.0;
//    CGFloat n = 0.0;
//    CGRect backViewRect = _backView.frame;
//    
//    for (int i = 0; i < _cityListArray.count; i++) {
//        NSDictionary *dic = _cityListArray[i];
//        NSString *str = [NSString stringWithFormat:@"%@", dic[@"name"]];
//        CGFloat width = [self TextWidth:str];
//        CGFloat iii = ZQ_Device_Width - x;
//        if (iii < width + 24) {
//            n = y;
//            x = 0;
//            backViewRect.size.height = n + 44;
//            _backView.frame = backViewRect;
//        }
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        //自适应label的宽度
//        button.frame = CGRectMake(x + 12, n + 12, width, 30);
//        x = CGRectGetMaxX(button.frame);
//        y = CGRectGetMaxY(button.frame);
//        button.tag =  i;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        button.layer.cornerRadius = 2;
//        button.layer.borderWidth = 0.5f;
//        button.layer.borderColor = kUIColorFromRGB(0xaaaaaa).CGColor;
//        [button setTitleColor:kUIColorFromRGB(0x858585) forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
////        if ([dic[@"defaults"] integerValue] == 1) {
////            [button setBackgroundColor:[UIColor redColor]];
////            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////        } else {
////            [button setBackgroundColor:[UIColor whiteColor]];
////            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
////        }
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [button setTitle:dic[@"name"] forState:UIControlStateNormal];
//        [_backView addSubview:button];
//    }
//    
//    _cellHight = y + 10;
    
}
//动态计算宽度
- (CGFloat)TextWidth:(NSString *)text WithIsImage:(NSString *)isImage
{
    //判断文字是否为空
    if ([ZQ_CommonTool isEmpty:text]) {
        return 0.1;
    }
    //按字体大小计算宽度
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
//    // 返回宽度
//    if (rect.size.width < 67) {
//        CGFloat fl = 70;
//        if ([isImage integerValue] == 1) {
//            fl = 95;
//        }
//        
//        return fl;
//    }
    
    CGFloat fl = rect.size.width + 20;
    if ([isImage integerValue] == 1) {
        fl = rect.size.width + 25;
    }
    return fl;
}

- (void)buttonAction:(UIButton *)button{
    if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(seleCityButtonClick:WithIndexPath:)]){
        
        [_delegate seleCityButtonClick:button.tag WithIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
