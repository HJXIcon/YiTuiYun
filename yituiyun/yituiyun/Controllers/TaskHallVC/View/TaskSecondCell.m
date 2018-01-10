//
//  TaskSecondCell.m
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "TaskSecondCell.h"
#import "ZQImageAndLabelButton.h"
#import "TaskNodeModel.h"

@interface TaskSecondCell ()

@end

@implementation TaskSecondCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString* identifier = @"taskSecondCell";
    TaskSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TaskSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*
         numberLabel;
         singleLabel;
         promotionLabel
         */
        
        //推广人数
        UILabel *numberLabel1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(0, 10, ZQ_Device_Width/3 - 1, 20)];
        numberLabel1.backgroundColor = [UIColor clearColor];
        numberLabel1.textColor = kUIColorFromRGB(0x808080);
        numberLabel1.textAlignment = NSTextAlignmentCenter;
        numberLabel1.text = @"推广人数";
        numberLabel1.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:numberLabel1];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(numberLabel1.frame), ZQ_Device_Width/3-1, 30)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = kUIColorFromRGB(0xF16156);
        _numberLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_numberLabel];
        
        UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(numberLabel1.frame), 20, 1, 30)];
        view.backgroundColor = kUIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:view];
        
        //累计成单
        UILabel *singleLabel1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/3, 10, ZQ_Device_Width/3 - 1, 20)];
        singleLabel1.backgroundColor = [UIColor clearColor];
        singleLabel1.textColor = kUIColorFromRGB(0x808080);
        singleLabel1.textAlignment = NSTextAlignmentCenter;
        singleLabel1.text = @"累计成单";
        singleLabel1.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:singleLabel1];
        
        self.singleLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/3, CGRectGetMaxY(numberLabel1.frame), ZQ_Device_Width/3 - 1, 30)];
        _singleLabel.backgroundColor = [UIColor clearColor];
        _singleLabel.textAlignment = NSTextAlignmentCenter;
        _singleLabel.textColor = kUIColorFromRGB(0xF16156);
        _singleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_singleLabel];
        
        UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(singleLabel1.frame), 20, 1, 30)];
        view1.backgroundColor = kUIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:view1];
        
        //累计推广
        UILabel *promotionLabel1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/3*2, 10, ZQ_Device_Width/3, 20)];
        promotionLabel1.backgroundColor = [UIColor clearColor];
        promotionLabel1.textColor = kUIColorFromRGB(0x808080);
        promotionLabel1.textAlignment = NSTextAlignmentCenter;
        promotionLabel1.text = @"累计推广";
        promotionLabel1.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:promotionLabel1];
        
        self.promotionLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/3*2, CGRectGetMaxY(promotionLabel1.frame), ZQ_Device_Width/3, 30)];
        _promotionLabel.backgroundColor = [UIColor clearColor];
        _promotionLabel.textAlignment = NSTextAlignmentCenter;
        _promotionLabel.textColor = kUIColorFromRGB(0xF16156);
        _promotionLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_promotionLabel];

    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
