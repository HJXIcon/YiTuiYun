//
//  JXPopViewCell.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPopViewCell.h"
#import "JXPopModel.h"

// extern
float const PopoverViewCellHorizontalMargin = 17.f; ///< 水平边距
float const PopoverViewCellTitleLeftEdge = 12.f; ///< 标题左边边距


@interface JXPopViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *txtLabel;

@end
@implementation JXPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.imgView = [JXFactoryTool creatImageView:CGRectZero image:[UIImage imageNamed:@"shaixuan"]];
    [self.contentView addSubview:self.imgView];
    
    self.txtLabel = [JXFactoryTool creatLabel:CGRectZero font:[JXPopViewCell titleFont] textColor:UIColorFromRGBString(@"0x4a4a4a") text:@"数据的得失" textAlignment:0];
    [self.contentView addSubview:self.txtLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize imageSize = [JXPopViewCell imageSize];
    
    self.imgView.frame = CGRectMake(PopoverViewCellHorizontalMargin, (CGRectGetHeight(self.frame) - imageSize.height)/2, imageSize.width, imageSize.height);
    self.txtLabel.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + PopoverViewCellTitleLeftEdge, 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.imgView.frame) + PopoverViewCellTitleLeftEdge * 2, self.frame.size.height);
    
}

- (void)setModel:(JXPopModel *)model{
    _model = model;
    self.txtLabel.text = model.title;
    if (model.isSelect) {
         self.imgView.image = [ZQ_CommonTool imageWithColor:UIColorFromRGBString(@"0xf16156")];
    }else{
         self.imgView.image = [ZQ_CommonTool imageWithColor:[UIColor whiteColor]];
        self.imgView.layer.cornerRadius = 2;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.borderWidth = 0.5;
        self.imgView.layer.borderColor = UIColorFromRGBString(@"0xb4b4b4").CGColor;
    }
}



+ (instancetype)cellForTableView:(UITableView *)tableView{
    Class cellClass = NSClassFromString(NSStringFromClass(self));
    id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self)];
    }
    return cell;
}



/*! @brief 标题字体 */
+ (UIFont *)titleFont {
    return [UIFont systemFontOfSize:15.f];
}

+ (CGSize)imageSize{
    return CGSizeMake(15, 15);
}
@end
