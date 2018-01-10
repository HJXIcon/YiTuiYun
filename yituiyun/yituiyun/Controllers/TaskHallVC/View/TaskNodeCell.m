//
//  TaskNodeCell.m
//  yituiyun
//
//  Created by NIT on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "TaskNodeCell.h"
#import "ZQImageAndLabelButton.h"
#import "TaskNodeModel.h"

@interface TaskNodeCell ()

@end

@implementation TaskNodeCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString* identifier = @"TaskNodeCell";
    TaskNodeCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TaskNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 25, 10, 10)];
        [_iconView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_iconView];
        
        //标题
        self.nameLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 5, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 36 - 40, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = kUIColorFromRGB(0x404040);
        _nameLabel.numberOfLines = 2;
        if (ScreenWidth<375) {
           _nameLabel.font = [UIFont systemFontOfSize:WRadio(14)];
        }else{
            _nameLabel.font = [UIFont systemFontOfSize:14];
        }
        
        [self.contentView addSubview:_nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 30, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 36 - 50, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = kUIColorFromRGB(0x9f9f9f);
        if (ScreenWidth<375) {
          self.timeLabel.font = [UIFont systemFontOfSize:WRadio(13)];
        }else{
           self.timeLabel.font = [UIFont systemFontOfSize:13];
        }
        
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.text = @"签到时间";
        
        
        self.tagLabel = [[UILabel alloc] init];
        self.tagLabel.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 62, 12.5, 60, 25);
        //        _tagLabel.backgroundColor = [UIColor clearColor];
                _tagLabel.textAlignment = NSTextAlignmentCenter;
                _tagLabel.textColor = kUIColorFromRGB(0x808080);
        if (ScreenWidth<375) {
             _tagLabel.font = [UIFont systemFontOfSize:WRadio(14)];
        }else{
            _tagLabel.font = [UIFont systemFontOfSize:14];
        }
        
                [self.contentView addSubview:_tagLabel];
        
        self.checkInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkInButton.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 62, 12.5, 50, 25);
        _checkInButton.layer.cornerRadius = 3;
        _checkInButton.layer.borderWidth = 1;
        _checkInButton.tag = 1141;
        _checkInButton.layer.borderColor = kUIColorFromRGB(0xf16156).CGColor;
        _checkInButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkInButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_checkInButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
        [_checkInButton setTitle:@"签到" forState:UIControlStateNormal];
        [self.contentView addSubview:_checkInButton];
        
        self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadButton.hidden = YES;
        _uploadButton.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 62, 12.5, 50, 25);
        _uploadButton.layer.cornerRadius = 3;
        _uploadButton.layer.borderWidth = 1;
        _uploadButton.tag = 1142;
        _uploadButton.layer.borderColor = kUIColorFromRGB(0xf16156).CGColor;
        if (ScreenWidth<37) {
          _uploadButton.titleLabel.font = [UIFont systemFontOfSize:WRadio(14)];
        }else{
            _uploadButton.titleLabel.font = [UIFont systemFontOfSize:14];
  
        }
        
        [_uploadButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_uploadButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
        [_uploadButton setTitle:@"未上传" forState:UIControlStateNormal];
        [self.contentView addSubview:_uploadButton];
        
        //分割线
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, ScreenWidth, 1)];
        lineView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
        [self.contentView addSubview:lineView];
        
        //状态label
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 12, 55, 210, 35)];
        self.statusLabel.text = @"等待企业审核";
        if (ScreenWidth<375) {
          self.statusLabel.font = [UIFont systemFontOfSize:WRadio(14)];
        }else{
            self.statusLabel.font = [UIFont systemFontOfSize:14];
        }

        self.statusLabel.textColor = UIColorFromRGBString(@"0xff9f4a");
        [self.contentView addSubview:self.statusLabel];
        
        //状态btn
        self.statusBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-58-15, 55, 58, 35)];
        [self.statusBtn setTitle:@"查看进度" forState:UIControlStateNormal];
        if (ScreenWidth<375) {
             self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:WRadio(14)];
        }else{
            self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:14]; 
        }
       
        [self.statusBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.statusBtn];
        [self.statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

-(void)statusBtnClick:(UIButton *)btn{

    if (self.detialblock) {
        self.detialblock();
    }
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag == 1141) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkInButtonClickWithIndex:)]) {
            [self.delegate checkInButtonClickWithIndex:_indexPath];
        }
    } else if (button.tag == 1142) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(uploadButtonClickWithIndex:)]) {
            [self.delegate uploadButtonClickWithIndex:_indexPath];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-11);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.width.mas_equalTo(@(50));
//        make.height.mas_equalTo(@(HRadio(25)));
//    }];
}

@end
