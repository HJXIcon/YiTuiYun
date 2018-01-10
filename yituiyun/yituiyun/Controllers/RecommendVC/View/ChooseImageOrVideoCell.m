//
//  ChooseImageOrVideoCell.m
//  tongmenyiren
//
//  Created by 张强 on 16/9/14.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ChooseImageOrVideoCell.h"
#import "ZQImageAndLabelButton.h"
#import "ImageOrVideoModel.h"

@interface ChooseImageOrVideoCell ()
/** 图片背景 */
@property(nonatomic,strong)UIImageView * imageBackgroundView;

@end

@implementation ChooseImageOrVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"ChooseImageOrVideoCell";
    ChooseImageOrVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChooseImageOrVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageArray = [NSMutableArray array];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(12, 0, ZQ_Device_Width - 24, 40)];
        _nameLabel.textColor = kUIColorFromRGB(0x404040);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        self.imageBackgroundView = [[UIImageView alloc] init];
        [_imageBackgroundView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_imageBackgroundView];
        
    }
    return self;
}

- (void)makeView{
    
    for (UIView *view in _imageBackgroundView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger imageOrVideo = 8;
    for (ImageOrVideoModel *model in self.imageArray) {
        if ([model.type integerValue] == 2) {
            imageOrVideo = 0;
        }
    }
    
    if (_imageArray.count > imageOrVideo) {
        NSInteger j = 0;
        NSInteger k = 0;
        for (int i = 0; i < self.imageArray.count; i ++) {
            ImageOrVideoModel *model = self.imageArray[i];
            NSString *string = [NSString stringWithFormat:@"%@%@", kHost, model.dataUrl];
            if (j == 4) {
                j = 0;
                k ++;
            }
            UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
            Button.tag = 10000 + i;
            Button.frame = ZQ_RECT_CREATE(12 + (ZQ_Device_Width-39)/4 * j + 5 * j, 12 + k * (ZQ_Device_Width-39)/4 + 5 * k, (ZQ_Device_Width-39)/4, (ZQ_Device_Width-39)/4);
            [Button addTarget:self action:@selector(showImageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [Button sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
            [_imageBackgroundView addSubview:Button];
            
            if (imageOrVideo == 0) {
                UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
                imageV.frame = ZQ_RECT_CREATE(20, 20, CGRectGetWidth(Button.frame) - 40, CGRectGetHeight(Button.frame) - 40);
                [Button addSubview:imageV];
                
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                [Button addGestureRecognizer:longPress];
            }
            j ++;
        }
        _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, 24 + k * (ZQ_Device_Width-39)/4 + 5 * k + (ZQ_Device_Width-39)/4);
        
    } else {
        NSInteger j = 0;
        NSInteger k = 0;
        for (int i = 0; i < self.imageArray.count; i ++) {
            ImageOrVideoModel *model = self.imageArray[i];
            NSString *string = [NSString stringWithFormat:@"%@%@", kHost, model.dataUrl];
            if (j == 4) {
                j = 0;
                k ++;
            }
            UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
            Button.tag = 10000 + i;
            Button.frame = ZQ_RECT_CREATE(12 + (ZQ_Device_Width-39)/4 * j + 5 * j, 12 + k * (ZQ_Device_Width-39)/4 + 5 * k, (ZQ_Device_Width-39)/4, (ZQ_Device_Width-39)/4);
            [Button addTarget:self action:@selector(showImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [Button sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
            [_imageBackgroundView addSubview:Button];
            j ++;
        }
        
        if (j == 4) {
            j = 0;
            k ++;
        }
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        addButton.frame = ZQ_RECT_CREATE(12 + (ZQ_Device_Width-39)/4 * j + 5 * j, 12 + k * (ZQ_Device_Width-39)/4 + 5 * k, (ZQ_Device_Width-39)/4, (ZQ_Device_Width-39)/4);
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [_imageBackgroundView addSubview:addButton];
        
        _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, CGRectGetMaxY(addButton.frame) + 12);
    }
    
    self.height = CGRectGetMaxY(_imageBackgroundView.frame);
    
}

- (void)readOnlyMakeView{
    
    for (UIView *view in _imageBackgroundView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger j = 0;
    NSInteger k = 0;
    for (int i = 0; i < self.imageArray.count; i ++) {
        NSString *string = [NSString stringWithFormat:@"%@%@", kHost, self.imageArray[i]];
        if (j == 4) {
            j = 0;
            k ++;
        }
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
        Button.tag = 10000 + i;
        Button.frame = ZQ_RECT_CREATE(12 + (ZQ_Device_Width-39)/4 * j + 5 * j, 12 + k * (ZQ_Device_Width-39)/4 + 5 * k, (ZQ_Device_Width-39)/4, (ZQ_Device_Width-39)/4);
        [Button addTarget:self action:@selector(showImageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [Button sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
        [_imageBackgroundView addSubview:Button];
        j ++;
        
        _imageBackgroundView.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width, CGRectGetMaxY(Button.frame) + 12);
    }
    
    self.height = CGRectGetMaxY(_imageBackgroundView.frame);
}

- (void)showImageButtonClick:(UIButton *)button
{
    if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(picturesButtonClickTag:WithIndexPath:)]) {
        [_delegate picturesButtonClickTag:button.tag - 10000 WithIndexPath:_indexPath];
    }
}

- (void)addButtonClick
{
    if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(addImageButtonClickWithIndexPath:)]) {
        [_delegate addImageButtonClickWithIndexPath:_indexPath];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(longPressButtonWithIndexPath:)]) {
            [_delegate longPressButtonWithIndexPath:_indexPath];
            
        }
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
