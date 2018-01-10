//
//  FirstProjectOrTaskDetailCell.m
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "FirstProjectOrTaskDetailCell.h"
#import "ZQLabelAndImageButton.h"
#import "ProjectModel.h"

@interface FirstProjectOrTaskDetailCell ()
@property (nonatomic, strong) UILabel *adrLabel;

@end

@implementation FirstProjectOrTaskDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];


        
        self.adrLabel = [[UILabel alloc] init];
        _adrLabel.text = @"推广地点：";
        CGSize labelSize = [_adrLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 30)];
        _adrLabel.frame = ZQ_RECT_CREATE(12, 10, labelSize.width, 30);
        _adrLabel.textColor = kUIColorFromRGB(0x808080);
        _adrLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_adrLabel];
        
        self.backView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_adrLabel.frame), 10, ZQ_Device_Width - CGRectGetMaxX(_adrLabel.frame) - 12, 1)];
      
 
        [self.contentView addSubview:_backView];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"FirstProjectOrTaskDetailCell";
    FirstProjectOrTaskDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FirstProjectOrTaskDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (void)btnLayOut:(ProjectModel *)model
{
    _model = model;
    NSMutableString *adress = [[NSMutableString alloc]init];
    
    for (int i=0; i<model.Cityarray.count; i++) {
        NSDictionary *dict = model.Cityarray[i];
        NSString *temp =@"";
        if (i == model.Cityarray.count-1) {
            
          
            if ([dict[@"province"] isEqualToString:@"全国"] ) {
                temp = @"全国";
            }else{
                temp = [NSString stringWithFormat:@"%@-%@\n",dict[@"province"],dict[@"city"]];}
        }else{
            
            temp = [NSString stringWithFormat:@"%@-%@",dict[@"province"],dict[@"city"]];
        }
        [adress appendString:temp];

    }

    if (_backView) {
        [_backView removeAllSubviews];
    }
    
    if ([model.isAdress integerValue] == 1) {
        CGSize adrSize = [adress sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (adrSize.width <= ZQ_Device_Width - 94) {
            _backView.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_adrLabel.frame), 10, ZQ_Device_Width - CGRectGetMaxX(_adrLabel.frame) - 12, 30);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backView.frame), 30)];
            label.text = adress;
            label.textColor = kUIColorFromRGB(0x808080);
            label.font = [UIFont systemFontOfSize:14];
            [_backView addSubview:label];
        } else {
            _backView.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_adrLabel.frame), 10, ZQ_Device_Width - CGRectGetMaxX(_adrLabel.frame) - 12, 60);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backView.frame), 30)];
            label.text = adress;
            label.textColor = kUIColorFromRGB(0x808080);
            label.font = [UIFont systemFontOfSize:14];
            [_backView addSubview:label];
            
            CGFloat width = [self TextWidth:@"点击查看更多地点"];
            ZQLabelAndImageButton *button = [[ZQLabelAndImageButton alloc] initWithFrame:ZQ_RECT_CREATE(0, 30, width, 30)];
            [button isShowImage:2];
            button.label.text = @"点击查看更多地点";
            button.imageV.image = [UIImage imageNamed:@"adressD"];
            button.label.frame = ZQ_RECT_CREATE(0, 0, CGRectGetWidth(button.frame) - 25, 30);
            button.imageV.frame = ZQ_RECT_CREATE(CGRectGetWidth(button.frame) - 20, 10, 10, 10);
            button.label.textColor = kUIColorFromRGB(0xf16156);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:button];
        }
    } else if ([model.isAdress integerValue] == 2) {
        CGSize adreSize = [adress sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - CGRectGetMaxX(_adrLabel.frame) - 12, MAXFLOAT)];
        
        _backView.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_adrLabel.frame), 16.5, ZQ_Device_Width - CGRectGetMaxX(_adrLabel.frame) - 12, adreSize.height + 35);

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backView.frame), adreSize.height)];
      
        label.text = adress;
        label.numberOfLines = 0;
        label.textColor = kUIColorFromRGB(0x808080);
        label.font = [UIFont systemFontOfSize:14];
        [_backView addSubview:label];
        
        CGFloat width = [self TextWidth:@"点击收起"];
        ZQLabelAndImageButton *button = [[ZQLabelAndImageButton alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(label.frame) + 5, width, 30)];
        [button isShowImage:2];
        button.label.text = @"点击收起";
        button.imageV.image = [UIImage imageNamed:@"adressU"];
        button.label.frame = ZQ_RECT_CREATE(0, 0, CGRectGetWidth(button.frame) - 25, 30);
        button.imageV.frame = ZQ_RECT_CREATE(CGRectGetWidth(button.frame) - 20, 10, 10, 10);
        button.label.textColor = kUIColorFromRGB(0xf16156);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    _cellHight = CGRectGetMaxY(_backView.frame) + 10;
}

- (void)buttonAction:(ZQLabelAndImageButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(moreAdressButtonClick)]){
        
        [_delegate moreAdressButtonClick];
    }
}

//动态计算宽度
- (CGFloat)TextWidth:(NSString *)text
{
    //判断文字是否为空
    if ([ZQ_CommonTool isEmpty:text]) {
        return 0.1;
    }
    //按字体大小计算宽度
    CGRect rect = [text boundingRectWithSize:CGSizeMake(ZQ_Device_Width - CGRectGetMaxX(_adrLabel.frame) - 12, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    CGFloat fl = rect.size.width + 25;
    return fl;
}



@end
