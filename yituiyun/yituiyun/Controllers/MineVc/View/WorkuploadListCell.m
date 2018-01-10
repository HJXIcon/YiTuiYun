//
//  WorkuploadListCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/30.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "WorkuploadListCell.h"

@interface WorkuploadListCell ()
@property(nonatomic,strong) CALayer  *mylayer;
@end


@implementation WorkuploadListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLabel.textColor = UIColorFromRGBString(@"0xf16156");
    self.statusLabel.layer.borderColor = UIColorFromRGBString(@"0xededed").CGColor;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.clipsToBounds = YES;
    
    
    
}

-(void)setModel:(CompanyWorkModel *)model{
    _model = model;
    
    if ([_model.auditing_status isEqualToString:@"2"]) {
        self.mylayer.borderColor= UIColorFromRGBString(@"0xf16156").CGColor;
        self.statusLabel.textColor = UIColorFromRGBString(@"0xf16156");
        self.statusLabel.layer.borderColor = UIColorFromRGBString(@"0xf16156").CGColor;
        self.statusLabel.layer.borderWidth = 1;
        
    }else{
        self.mylayer.borderColor = [UIColor lightGrayColor].CGColor;
        self.statusLabel.textColor =[UIColor lightGrayColor];
        self.statusLabel.layer.borderColor = UIColorFromRGBString(@"0xededed").CGColor;
        self.statusLabel.layer.borderWidth = 1;

    }
    
    self.usernameLabel.text =[NSString stringWithFormat:@"上传用户:%@", model.nickname];
    self.timeLabel.text = [NSString stringWithFormat:@"签到时间:%@",[NSString timeHasSecondTimeIntervalString:model.inputtime]];
    
    
    self.descLabel.text = model.address;
    self.statusLabel.text = [NSString getStringWithCompanyType:[model.auditing_status integerValue]];
    
    
//    if ([model.auditing_status integerValue] == 2) {
//        
//    }
    
    

}

-(CALayer *)mylayer{
    if (_mylayer == nil) {
        _mylayer = [CALayer layer];
        _mylayer.backgroundColor =[UIColor clearColor].CGColor;
        _mylayer.borderColor= UIColorFromRGBString(@"0xf16156").CGColor;
        _mylayer.borderWidth = 1;
        _mylayer.cornerRadius = 3;
    }
    return _mylayer;
}


-(CGSize)boundsWith:(NSString *)title{
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:FontRadio(14)]};
    CGRect rect  =  [title boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x = self.statusLabel.frame.origin.x-2;
    CGFloat y = self.statusLabel.frame.origin.y-2;
    CGFloat w = self.statusLabel.size.width+4;
    CGFloat h = self.statusLabel.size.height+4;
//    self.mylayer.frame = CGRectMake(x, y, w, h);
 

}

@end
