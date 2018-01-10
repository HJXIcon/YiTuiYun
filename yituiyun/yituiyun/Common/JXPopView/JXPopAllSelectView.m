//
//  JXPopAllSelectView.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPopAllSelectView.h"
#import "JXPopViewCell.h"

@interface JXPopAllSelectView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *txtLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation JXPopAllSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setupUI{
    
    self.imgView = [JXFactoryTool creatImageView:CGRectZero image:[UIImage imageNamed:@"shaixuan"]];
    self.imgView.image = [ZQ_CommonTool imageWithColor:[UIColor whiteColor]];
    self.imgView.layer.cornerRadius = 2;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 0.5;
    self.imgView.layer.borderColor = UIColorFromRGBString(@"0xb4b4b4").CGColor;
    [self addSubview:self.imgView];
    
    self.txtLabel = [JXFactoryTool creatLabel:CGRectZero font:[JXPopViewCell titleFont] textColor:UIColorFromRGBString(@"0x4a4a4a") text:@"全部" textAlignment:0];
    [self addSubview:self.txtLabel];
    
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
    [self addSubview:self.line];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize imageSize = [JXPopViewCell imageSize];
    
    self.imgView.frame = CGRectMake(PopoverViewCellHorizontalMargin, (CGRectGetHeight(self.frame) - imageSize.height)/2, imageSize.width, imageSize.height);
    self.txtLabel.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + PopoverViewCellTitleLeftEdge, 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.imgView.frame) + PopoverViewCellTitleLeftEdge * 2, self.frame.size.height);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
}


- (void)tapAction{
    self.isSelectAll = !self.isSelectAll;
    
    if (self.tapBlock) {
        self.tapBlock(self.isSelectAll);
    }
}

- (void)setIsSelectAll:(BOOL)isSelectAll{
    _isSelectAll = isSelectAll;
    if (isSelectAll) {
        self.imgView.image = [ZQ_CommonTool imageWithColor:UIColorFromRGBString(@"0xf16156")];
    }else{
        self.imgView.image = [ZQ_CommonTool imageWithColor:[UIColor whiteColor]];
        self.imgView.layer.cornerRadius = 2;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.borderWidth = 0.5;
        self.imgView.layer.borderColor = UIColorFromRGBString(@"0xb4b4b4").CGColor;
    }
}
@end
