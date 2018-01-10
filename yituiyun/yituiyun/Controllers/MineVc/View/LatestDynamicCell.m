//
//  LatestDynamicCell.m
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "LatestDynamicCell.h"

@interface LatestDynamicCell ()<UITextFieldDelegate>
/** 图片背景 */
@property(nonatomic,strong)UIImageView * imageBackgroundView;

@end

@implementation LatestDynamicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"LatestDynamicCell";
    LatestDynamicCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LatestDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dynamicDic = [NSMutableDictionary dictionary];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
        label.text = @"最新动态";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = kUIColorFromRGB(0x808080);
        [self.contentView addSubview:label];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(15, 44, ZQ_Device_Width - 45, 30)];
        _nameLabel.textColor = kUIColorFromRGB(0x404040);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        self.imageBackgroundView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageBackgroundView];
    }
    return self;
}

- (void)makeView
{
    for (UIView *view in _imageBackgroundView.subviews) {
        [view removeFromSuperview];
    }
    if (![ZQ_CommonTool isEmpty:_dynamicDic[@"content"]]) {
        _nameLabel.frame = ZQ_RECT_CREATE(15, 44, ZQ_Device_Width - 45, 20);
        _nameLabel.text = _dynamicDic[@"content"];
    } else {
        _nameLabel.frame = ZQ_RECT_CREATE(15, 44, ZQ_Device_Width - 45, 0.0001);
    }
    if (![ZQ_CommonTool isEmpty:_dynamicDic[@"basicInfo"]]) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
        Button.frame = ZQ_RECT_CREATE(15,10,(ScreenWidth - 85)/4,(ScreenWidth - 85)/4);
        NSString *string = [NSString stringWithFormat:@"%@%@", kHost, _dynamicDic[@"thumb"]];
        [Button sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
        [_imageBackgroundView addSubview:Button];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
        imageV.frame = ZQ_RECT_CREATE(15, 20, CGRectGetWidth(Button.frame) - 40, CGRectGetHeight(Button.frame) - 40);
        [Button addSubview:imageV];
        if (![ZQ_CommonTool isEmpty:_dynamicDic[@"content"]]) {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, (ScreenWidth - 85)/4 + 20);
        } else {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame) - 10, ZQ_Device_Width, (ScreenWidth - 85)/4 + 20);
        }
    } else if (![ZQ_CommonTool isEmptyArray:_dynamicDic[@"showImages"]]){
        NSArray *imageArray = _dynamicDic[@"showImages"];
        NSInteger j = imageArray.count;
        if (j > 4) {
            j = 4;
        }
        for (int i = 0; i < j; i ++) {
            NSDictionary *dic = imageArray[i];
            NSString *string = [NSString stringWithFormat:@"%@%@", kHost, dic[@"url"]];
            
            UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
            Button.frame = ZQ_RECT_CREATE(15 + (ScreenWidth - 85)/4 * i + 10 * i,10,(ScreenWidth - 85)/4,(ScreenWidth - 85)/4);
            [Button sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
            [_imageBackgroundView addSubview:Button];
        }
        if (![ZQ_CommonTool isEmpty:_dynamicDic[@"content"]]) {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, (ScreenWidth - 85)/4 + 20);
        } else {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame) - 10, ZQ_Device_Width, (ScreenWidth - 85)/4 + 20);
        }
    } else {
        if (![ZQ_CommonTool isEmpty:_dynamicDic[@"content"]]) {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, 10);
        } else {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, 0.00001);
        }
    }
    _height = CGRectGetMaxY(_imageBackgroundView.frame);

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
