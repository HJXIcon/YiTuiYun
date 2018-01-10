//
//  RecommendCell.m
//  yituiyun
//
//  Created by 张强 on 16/7/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "RecommendCell.h"
#import "GoodsModel.h"

@interface RecommendCell ()

@end

@implementation RecommendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString* identifier = @"RecommendCell";
    RecommendCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeView];
    }
    return self;
}

- (void)makeView{
    
    self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 10, 50, 50)];
    [self.contentView addSubview:_iconView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 10, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 25)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.numberOfLines = 0;
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    self.descLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, CGRectGetMaxY(_nameLabel.frame), ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 24, 25)];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.textColor = kUIColorFromRGB(0x808080);
    [self.contentView addSubview:_descLabel];
}

@end
