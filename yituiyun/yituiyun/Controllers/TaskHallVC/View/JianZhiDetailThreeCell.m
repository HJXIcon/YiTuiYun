//
//  JianZhiDetailThreeCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiDetailThreeCell.h"

@implementation JianZhiDetailThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setUItags{
    
    CGFloat fontszie = FontRadio(14);
    
    int width = 10;
    
    int j = 0;
    
    int row = 1;
    
    
    for (UIView *views in self.subviews) {
        if (views.tag == 1000) {
            [views removeFromSuperview];
        }
    }
    
    for (int i = 0 ; i < self.datas.count; i++) {
        
        
        
        int labWidth = [self widthForLabel:self.datas[i] fontSize:fontszie]+15;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(5*j + width, row * 35, labWidth, 30);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.text =self.datas[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:fontszie];
        label.numberOfLines = 1;
        label.layer.borderWidth = 1;
        label.textColor = [UIColor blackColor];
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.cornerRadius = 15;
        label.tag = 1000;
        label.clipsToBounds = YES;
        
        [self addSubview:label];
        
        width = width + labWidth;
        
        j++;
        
        if (width > ScreenWidth - 50) {
            
            j = 0;
            
            width = 10;
            
            row++;
            
            label.frame = CGRectMake(5*j + width,row * 30+15, labWidth, 30);
            
            width = width + labWidth;
            
            j++;
            
        }
        
        if (i == self.datas.count-1) {
            self.cellheight = CGRectGetMaxY(label.frame)+10;
           
        }
        
    }
    
}
- (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font
{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width;
}


@end
