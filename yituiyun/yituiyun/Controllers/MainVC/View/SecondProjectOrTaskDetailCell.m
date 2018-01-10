//
//  SecondProjectOrTaskDetailCell.m
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "SecondProjectOrTaskDetailCell.h"
#import "ZQLabelAndImageButton.h"

@implementation SecondProjectOrTaskDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.listArray = [NSMutableArray array];
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 35, 35)];
        self.iconImageView.contentMode=UIViewContentModeCenter;
        self.iconImageView.image = [UIImage imageNamed:@"project_yaoqiu"];
        [self.contentView addSubview:self.iconImageView];

        
        self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(33, 10, ZQ_Device_Width - 24, 35)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = kUIColorFromRGB(0x000000);

        [self.contentView addSubview:_nameLabel];
        
        self.backView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 40, ZQ_Device_Width, 1)];
        [self.contentView addSubview:_backView];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"secondProjectOrTaskDetailCell";
    SecondProjectOrTaskDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SecondProjectOrTaskDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)btnLayOut{
    
    for (UIView *view in _backView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat x  = 0.0;
    CGFloat y = 0.0;
    CGFloat n = 0.0;
    CGRect backViewRect = _backView.frame;
    
    for (int i = 0; i < _listArray.count; i++) {
        NSDictionary *dic = _listArray[i];
        NSString *str = [NSString stringWithFormat:@"%@", dic[@"name_zh"]];
        NSString *isImage = [NSString stringWithFormat:@"%@", dic[@"t"]];
        
        CGSize Size = [self TextWidth:str WithIsImage:isImage];
        CGFloat iii = ZQ_Device_Width - x;
        if (iii < Size.width + 24) {
            n = y;
            x = 0;
            backViewRect.size.height = n + Size.height + 14;
            _backView.frame = backViewRect;
        }
        
        ZQLabelAndImageButton *button = [[ZQLabelAndImageButton alloc] initWithFrame:ZQ_RECT_CREATE(x + 12, n + 12, Size.width, Size.height)];
        [button isShowImage:[isImage integerValue]];
        [button setUserInteractionEnabled:NO];
        x = CGRectGetMaxX(button.frame);
        y = CGRectGetMaxY(button.frame);
        [[button layer] setCornerRadius:Size.height*0.5];
        button.layer.borderColor =UIColorFromRGBString(@"0xa0a0a0").CGColor;
        button.layer.borderWidth = 1.0f;
        [[button layer] setMasksToBounds:YES];
//        [button setBackgroundColor:kUIColorFromRGB(0xFEEFEE)];
        
        button.label.numberOfLines = 0;
        button.label.text = str;
        button.imageV.image = [UIImage imageNamed:@"camera"];
        [_backView addSubview:button];
    }
    
    _cellHight = y + 45;
    
}

- (void)btnLayOut1
{
    for (UIView *view in _backView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    NSString *string = _descString;
    string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n"];
    label.text = string;
    label.textColor = kUIColorFromRGB(0x404040);
    label.backgroundColor = kUIColorFromRGB(0xFEEFEE);
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [_backView addSubview:label];
    
    CGSize detailsSize = [label.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 24, MAXFLOAT)];
    label.frame = CGRectMake(12, 10, detailsSize.width + 5, detailsSize.height + 10);
    _backView.frame = ZQ_RECT_CREATE(0, 40, ZQ_Device_Width, CGRectGetHeight(label.frame) + 10);
    
    _cellHight = CGRectGetHeight(_backView.frame) + 45;
}

//动态计算宽度
- (CGSize)TextWidth:(NSString *)text WithIsImage:(NSString *)isImage//MAXFLOAT
{
    //判断文字是否为空
    if ([ZQ_CommonTool isEmpty:text]) {
        return CGSizeMake(0.01, 30);
    }
    
    if ([isImage integerValue] == 1) {
        CGSize describeSize = [text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 30)];
        CGFloat fl = describeSize.width;
        if (fl < ZQ_Device_Width - 24 - 20) {
            return CGSizeMake(fl + 20, 30);
        } else {
            CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 24 - 20, MAXFLOAT)];
            return CGSizeMake(ZQ_Device_Width - 24, textSize.height + 10);
        }
    }
    
    CGSize describeSize = [text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 30)];
    CGFloat fl = describeSize.width;
    if (fl < ZQ_Device_Width - 24 - 45) {
        return CGSizeMake(fl + 45, 30);
    }
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 24 - 45, MAXFLOAT)];
    return CGSizeMake(ZQ_Device_Width - 24, textSize.height + 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
