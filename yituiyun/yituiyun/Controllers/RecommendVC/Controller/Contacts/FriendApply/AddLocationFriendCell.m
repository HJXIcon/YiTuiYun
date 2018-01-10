/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "AddLocationFriendCell.h"
@interface AddLocationFriendCell ()

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UIImageView *sexView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@end

@implementation AddLocationFriendCell
+ (instancetype)choseCellWithTableView:(UITableView *)tableView{
    NSString* const identifier = @"AddLocationFriendCell";
    AddLocationFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AddLocationFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 15, 40, 40)];
        _avatarView.layer.cornerRadius = 20;
        _avatarView.clipsToBounds = YES;
        [self.contentView addSubview:_avatarView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_avatarView.frame) + 12, 13, ZQ_Device_Width - CGRectGetMaxX(_avatarView.frame) - 24, 27)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_avatarView.frame) + 12, 13, ZQ_Device_Width - CGRectGetMaxX(_avatarView.frame) - 24, 27)];
        _typeLabel.layer.cornerRadius = 3;
        _typeLabel.clipsToBounds = YES;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = kUIColorFromRGB(0xffffff);
        _typeLabel.backgroundColor = kUIColorFromRGB(0xf16156);
        _typeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_typeLabel];
        
        self.sexView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 15, 40, 40)];
        [self.contentView addSubview:_sexView];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_avatarView.frame) + 12, 13, ZQ_Device_Width - CGRectGetMaxX(_avatarView.frame) - 24, 27)];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.textColor = kUIColorFromRGB(0x999999);
        [self.contentView addSubview:_distanceLabel];
        
        self.descLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_avatarView.frame) + 12, 40, ZQ_Device_Width - CGRectGetMaxX(_avatarView.frame) - 24, 17)];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = kUIColorFromRGB(0x999999);
        [self.contentView addSubview:_descLabel];
    }
    return self;
}
    
- (void)setAddFriendModel:(AddFriendModel *)addFriendModel{
    _addFriendModel = addFriendModel;
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:addFriendModel.avatar] placeholderImage:[UIImage imageNamed:@"EaseUIResource.bundle/user"]];

    _titleLabel.text = addFriendModel.nickname;
    CGSize titleSize = [addFriendModel.nickname sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(ZQ_Device_Width - CGRectGetMaxX(_avatarView.frame) - 12 - 70, 27)];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_avatarView.frame) + 12, 13, titleSize.width, 27);
    
    if ([ZQ_CommonTool isEmpty:addFriendModel.industry]) {
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_titleLabel.frame) + 10, 16.5, 0.00000000001, 20);
    } else {
        _typeLabel.backgroundColor = kUIColorFromRGB(0xf16156);
        _typeLabel.text = addFriendModel.industry;
        CGSize typeSize = [addFriendModel.industry sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(70, 27)];
        _typeLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_titleLabel.frame) + 10, 16.5, typeSize.width+10, 20);
    }
    
    _sexView.frame = CGRectMake(CGRectGetMaxX(_typeLabel.frame) + 10, 17, 18, 18);
    if ([addFriendModel.sex integerValue] == 1) {
        _sexView.image = [UIImage imageNamed:@"nan"];
    } else if ([addFriendModel.sex integerValue] == 2) {
        _sexView.image = [UIImage imageNamed:@"nv"];
    } else {
        _sexView.image = nil;
    }
    
    _descLabel.text = addFriendModel.desc;
    _descLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(_avatarView.frame) + 12, 40, ZQ_Device_Width - CGRectGetMaxX(_avatarView.frame) - 14, 17);
    
    if (![ZQ_CommonTool isEmpty:addFriendModel.distance]) {
        _distanceLabel.text = [NSString stringWithFormat:@"%@km", addFriendModel.distance];
        CGSize distanceSize = [_distanceLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width, 27)];
        _distanceLabel.frame = ZQ_RECT_CREATE(ZQ_Device_Width - distanceSize.width - 10, 13, distanceSize.width, 27);
    }
}

@end
