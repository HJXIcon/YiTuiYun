//
//  LHKTaskHallCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKTaskHallCell.h"

@implementation LHKTaskHallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = 31;
    self.iconImageView.clipsToBounds = YES;
//    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.tingzhiBtn.layer.borderColor = UIColorFromRGBString(@"0xaaaaaa").CGColor;
    self.tingzhiBtn.layer.borderWidth = 1;
    self.tingzhiBtn.layer.cornerRadius = 3;
    self.tingzhiBtn.clipsToBounds = YES;
    self.addBtn.layer.cornerRadius = 3;
    self.addBtn.clipsToBounds = YES;

    
}


-(void)setModel:(TaskHallModel *)model{
    _model = model;
    //名称
    self.nameLabel.text = model.projectName;
    //图像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString imagePathAddPrefix:model.thumb] ] placeholderImage:[UIImage imageNamed:@"personlogo"]];
    //tagsLabel
    if (1) {
        self.timeImageView.hidden = NO;
        self.subImageView.hidden = YES;
//        self.tagsLabel.text = model.timeTypeStr;
        self.fenjieView.hidden = YES;
        self.timeLabel.hidden = YES;
        
        NSString *successTimeStr = [NSString stringWithFormat:@"截止至:%@",model.endDate
];
        self.tagsLabel.text = successTimeStr;

    }else{
        self.timeLabel.hidden = NO;
        self.fenjieView.hidden = NO;
        self.timeImageView.hidden = YES;
        self.subImageView.hidden = NO;
        NSMutableString *mustr = [[NSMutableString alloc]init];
        for (NSString *str in model.tags) {
            [mustr appendString:str];
        }
        
        if (mustr.length>10) {
            NSString *tempStr = [mustr substringToIndex:9];
            mustr  =[NSString stringWithFormat:@"%@...",tempStr];
        }
        
        self.tagsLabel.text = mustr;
        
       NSString *tempTimeStr = [NSString timeWithTimeIntervalString: model.timeTypeStr];
        NSString *successTimeStr = [NSString stringWithFormat:@"截止至%@",tempTimeStr];
        self.timeLabel.text = successTimeStr;

    }
    //接单量
    NSString *jeStr = [NSString stringWithFormat:@"执行中:%@单",model.count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:jeStr];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBString(@"0x9d9d9d") range:NSMakeRange(0, 3)];
    self.recevLabel.attributedText = attr;
    //成单量
    NSString *cStr = [NSString stringWithFormat:@"已完成:%@单",model.complete_count];
    NSMutableAttributedString *cattr = [[NSMutableAttributedString alloc]initWithString:cStr];
    [cattr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBString(@"0x9d9d9d") range:NSMakeRange(0, 3)];
    self.completeLabel.attributedText = cattr;
    
    //剩余单量
    NSString *surlustext = [NSString stringWithFormat:@"剩余单量:%@单",model.surplus_single];
    self.shengyuLabel.text = surlustext;
    
    //状态判断
//  self.statusLabel.text =   [NSString returnTaskType:[model.status integerValue]];
    
    UserInfoModel *usermode = [ZQ_AppCache userInfoVo];
    
    if ([usermode.identity isEqualToString:@"6"]) {
      /********/
        
        if ([model.demand_status isEqualToString:@"7"] || [model.demand_status isEqualToString:@"0"] || [model.demand_status isEqualToString:@"8"]) {
            self.statusLabel.text = @"任务已停止";
        }else{
            
            if ([model.status isEqualToString:@"3"]) {
                self.statusLabel.text = @"任务已取消";
            }else if ([model.status isEqualToString:@"2"]){
                self.statusLabel.text = @"任务已停止";
            }else{
                self.statusLabel.text = @"任务执行中";
            }
            
        }
        /********/
        
        
    }else{
        if ([model.status isEqualToString:@"7"]) {
            self.statusLabel.text = @"需求已停止";
            
        }else if ([model.status isEqualToString:@"8"]){
            self.statusLabel.text = @"需求已完成";
        }else{
            self.statusLabel.text = @"需求执行中";
        }
    }
    
    
    
}


-(void)setListmodel:(CompanyJianZhiModel *)listmodel{
    
    _listmodel = listmodel ;
    
    
    //名称
    self.nameLabel.text = listmodel.title;
    //图像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString imagePathAddPrefix:listmodel.logo] ] placeholderImage:[UIImage imageNamed:@"personlogo"]];
 
    self.recevLabel.hidden = YES;
    
    self.completeLabel.hidden = YES;
    
    //
    self.tagsLabel.hidden = NO;
    self.fenjieView.hidden = NO;
    self.timeLabel.hidden = NO;
    self.tagsLabel.text = _listmodel.work_area;
    self.timeLabel.text = [NSString settmenJianZhiWithType:[_listmodel.settlement integerValue]];
    
    //剩余单量 ----报名
    self.shengyuLabel.text = [NSString stringWithFormat:@"截止时间:%@",_listmodel.end_date];
    

    self.shengyubaozhengjinLabel.text =[NSString stringWithFormat:@"招聘人数:%@",_listmodel.person_number];
    
    //状态判断
    self.statusLabel.text =[self statusWithstausType:[_listmodel.status integerValue] ];

}


-(void)setJianzhishenhemodel:(JiZhiSheHeListModel *)jianzhishenhemodel{
    _jianzhishenhemodel = jianzhishenhemodel;
    
    if ([_jianzhishenhemodel.apply_status isEqualToString:@"1"]) {
        //有两个操作按钮
                self.addBtn.backgroundColor = UIColorFromRGBString(@"0xf16156");
                [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.tingzhiBtn.hidden = NO;
        self.addBtn.userInteractionEnabled = YES;
        

    }else{
//        self.addBtn.backgroundColor = [UIColor blueColor];
//        [self.addBtn setTitleColor:UIColorFromRGBString(@"0xf16156") forState:UIControlStateNormal];
        self.addBtn.userInteractionEnabled = NO;
        self.tingzhiBtn.hidden = YES;
        [self.addBtn setTitle:[NSString statusWithShenHe:[jianzhishenhemodel.apply_status integerValue]] forState:UIControlStateNormal];
        }
    
    //名称
    self.nameLabel.text = jianzhishenhemodel.nickname;
    //图像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString imagePathAddPrefix:jianzhishenhemodel.avatar] ] placeholderImage:[UIImage imageNamed:@"personlogo"]];
    //tagsLabel
    
        NSString *successTimeStr = [NSString stringWithFormat:@"性别: %@",[NSString sexWithSheHe:[self.jianzhishenhemodel.sex integerValue]]];
        self.tagsLabel.text = successTimeStr;
    
    NSString *timeLabel = [NSString stringWithFormat:@"年龄: %@",self.jianzhishenhemodel.age];
    self.timeLabel.text = timeLabel;
    
    //接单量
    NSString *jeStr = [NSString stringWithFormat:@"学历: %@",[NSString educationWithSheHe:[self.jianzhishenhemodel.education integerValue]]];
    
    self.recevLabel.text = jeStr;
    //成单量
    NSString *cStr = [NSString stringWithFormat:@"特长: %@",self.jianzhishenhemodel.hobbies];
    self.completeLabel.text = cStr;
    
    //剩余单量
    
    NSString *surlustext = [NSString stringWithFormat:@"身高: %@cm",self.jianzhishenhemodel.height];
    self.shengyuLabel.text = surlustext;
    
    NSString *telphone = [NSString stringWithFormat:@"电话: %@",self.jianzhishenhemodel.mobile];
    self.statusLabel.text = telphone;
    
    self.shengyubaozhengjinLabel.text = jianzhishenhemodel.title;
    
   
}


//停止任务
- (IBAction)tingzhiBtnClick:(UIButton *)sender {
    if (self.tingzhiblock) {
        self.tingzhiblock();
    }
}




//添加单量

- (IBAction)addBtnClick:(id)sender {
    if (self.addblock) {
        self.addblock();
    }
}


-(NSString *)unitWithType:(NSInteger)type{
    switch (type) {
        case 1:
            return @"天";
            break;
        case 2:
             return @"小时";
            break;

        case 3:
             return @"周";
            break;

        case 4:
             return @"月";
            break;

            
        default:
             return @"错误";
            break;
    }
}

-(NSString *)statusWithstausType:(NSInteger)type{
    switch (type) {
        case 0:
            return @"待审核";
            break;
        case 1:
            return @"未通过";
            break;
            
        case 2:
            return @"需求通过";
            break;
        case 3:
            return @"待支付";
            break;
            
            
        case 6:
            return @"执行中";
            break;
            
        case 7:
            return @"招聘停止";
            break;
        case 8:
            return @"招聘完成";
            break;

            
            
        default:
            return @"错误";
            break;
    }

}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    // 调用super
    [super setHighlighted:highlighted animated:animated];
    
    if (![self.model.applyStop isEqualToString:@"1"]){
    self.tingzhiBtn.backgroundColor = [UIColor whiteColor];
//        self.addBtn.backgroundColor = UIColorFromRGBString(@"0xf16156");
    
    }
}
@end
