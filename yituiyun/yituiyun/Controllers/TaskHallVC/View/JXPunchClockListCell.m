//
//  JXPunchClockListCell.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPunchClockListCell.h"
#import "JXPunchClockListModel.h"

@implementation JXPunchClockListCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        self.iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 25, 10, 10)];
        [_iconView setUserInteractionEnabled:NO];
        _iconView.image = [UIImage imageNamed:@"oldNode"];
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
        
        _nameLabel.text = @"";
        [self.contentView addSubview:_nameLabel];
        
        /// 打卡时间
        self.timeLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(_iconView.frame) + 12, 30, ZQ_Device_Width - CGRectGetMaxX(_iconView.frame) - 36 - 50, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = kUIColorFromRGB(0x9f9f9f);
        if (ScreenWidth<375) {
            self.timeLabel.font = [UIFont systemFontOfSize:WRadio(13)];
        }else{
            self.timeLabel.font = [UIFont systemFontOfSize:13];
        }
        
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.text = @"上班时间:2017-07-12 19:09";
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 55, ScreenWidth - 20, 1)];
        lineView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
        [self.contentView addSubview:lineView];
        
        //状态label
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 12, 55, 210, 35)];
        self.statusLabel.text = @"下班未打卡";
        if (ScreenWidth<375) {
            self.statusLabel.font = [UIFont systemFontOfSize:WRadio(14)];
        }else{
            self.statusLabel.font = [UIFont systemFontOfSize:14];
        }
        
        self.statusLabel.textColor = UIColorFromRGBString(@"0xff9f4a");
        [self.contentView addSubview:self.statusLabel];
        
       
        // 状态btn
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
        self.statusBtn.hidden = YES;
    }
    
    return self;
}

- (void)setModel:(JXPunchClockListModel *)model{
    _model = model;
    self.nameLabel.text = model.address;
    self.timeLabel.text = [NSString stringWithFormat:@"上班时间:%@",[NSString timeHasMinuteTimeIntervalString:model.inputtime]];
    
    if ([model.status intValue] == 0 || [model.status intValue] == 2 || [ZQ_CommonTool isEmptyArray:model.audit_list] ) {
        self.statusBtn.hidden = YES;
        
    }else{
        self.statusBtn.hidden = NO;
    }
    
    // #0 待打下班卡  #1审核完成;2已失效;3审核中;4审核不通过
    NSString *statusString;
    switch ([model.status intValue]) {
        case 0:
            statusString = @"下班未打卡";
            break;
            
        case 1:
            statusString = @"审核完成";
            break;
            
        case 2:
            statusString = @"已失效";
            break;
            
        case 3:
            statusString = @"审核中";
            break;
            
        case 4:
            statusString = @"审核不通过";
            break;
            
        default:
            break;
    }
    
    self.statusLabel.text = statusString;
}

- (void)statusBtnClick:(UIButton *)btn{
    if (self.seeProgressBlock) {
        self.seeProgressBlock();
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
