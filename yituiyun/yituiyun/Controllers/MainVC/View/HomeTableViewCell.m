//
//  HomeTableViewCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wnLabel;

@property (weak, nonatomic) IBOutlet UIImageView *isNewProjectImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constan1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constan2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3H;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor =UIColorFromRGBString(@"0xededed");
    self.thumbImageView.layer.cornerRadius = WRadio(37.5);
    self.thumbImageView.clipsToBounds = YES;
    self.constan2.constant = HRadio(19);
    self.constan1.constant = HRadio(8);
//    self.jianzhistatusLabel.hidden = YES;
    //
    self.image2w.constant = WRadio(14);
    self.image2H.constant = WRadio(14);
    self.image3H.constant = WRadio(14);
    self.image3w.constant = WRadio(14);
    self.image1w.constant=WRadio(11);
    self.image1H.constant = WRadio(14);
    
}


- (void)setFrame:(CGRect)frame{
    CGRect old = frame;
    old.origin.x+=5;
    old.size.width-=10;
    frame = old;
    
    [super setFrame:frame];
}
- (void)setModel:(homeTableModel *)model{
    
    if (![model isKindOfClass:[homeTableModel class]]) {
        return;
    }
    
    _model = model;
    //项目名称
    self.projectNameLabel.text = model.projectName;
    //图片
    NSURL *url = [NSURL URLWithString:[NSString imagePathAddPrefix:model.thumb]];
    [self.thumbImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"personlogo"]];
    //接单量
    NSString *jieStr = [NSString stringWithFormat:@"执行中:%@单",model.count];
    self.countLabel.text = jieStr;
    //成单量
    NSString *cStr = [NSString stringWithFormat:@"已完成:%@单",model.complete_count];
    self.completeLabel.text = cStr;
    //剩余单量
    NSString *sstr = [NSString stringWithFormat:@"剩余单量:%@单",model.surplus_single];
    self.surplusLabel.text = sstr;
    //每单的价格
    NSString *singtr = [NSString stringWithFormat:@"%@",model.wn];
   
    self.wnLabel.text = singtr;
    //有效时间
    self.timeTypeLabel.text = [NSString stringWithFormat:@"截止至%@",model.endDate];
    //标签tags
    
    if (model.tags.count>0) {
        NSMutableString *mtags =[[NSMutableString alloc]init];
        for (NSString *tagstr in model.tags) {
            [mtags appendString:tagstr];
        }
        self.tagsLabel.text = mtags;
    }else{
        self.tagsLabel.text = @"暂无标签";
    }
  

    //处理时间 new
    
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    long long  timeStamp =[timeSp longLongValue];
    
    long long server = [model.inputtime longLongValue];
    
    
    if ((timeStamp-server)>72*3600) {
        self.isNewProjectImageView.hidden = YES;
    }else{
        self.isNewProjectImageView.hidden = NO;
    }

}

-(void)setFujinjianzhimodel:(CompanyJianZhiModel *)fujinjianzhimodel{
    
    if (![fujinjianzhimodel isKindOfClass:[CompanyJianZhiModel class]]) {
        return;
    }
    _fujinjianzhimodel = fujinjianzhimodel;
    
    //项目名称
    self.projectNameLabel.text = fujinjianzhimodel.title;
    //图片
    NSURL *url = [NSURL URLWithString:[NSString imagePathAddPrefix:fujinjianzhimodel.logo]];
    [self.thumbImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"personlogo"]];

    //剩余单量
    NSString *sstr = [NSString stringWithFormat:@"招聘人数: %@人/天",fujinjianzhimodel.person_number];
    self.surplusLabel.text = @"";
//    self.zhaopinPersonNumberLabel.textColor = UIColorFromRGBString(@"");
    self.zhaopinPersonNumberLabel.text = sstr;
    
    //已报名数
    NSString *jieStr;
    if ([ZQ_CommonTool isEmpty:fujinjianzhimodel.enrollment_number]) {
        jieStr = [NSString stringWithFormat:@"已报名:%@人",@"0"];
    }else{
        jieStr = [NSString stringWithFormat:@"已报名:%@人",fujinjianzhimodel.enrollment_number];
    }
    self.countLabel.text = jieStr;
    
    //已录取数
    NSString *cStr;
    if ([ZQ_CommonTool isEmpty:fujinjianzhimodel.employment_number]) {
        cStr = [NSString stringWithFormat:@"已录取:%@人",@"0"];
    }else{
        cStr = [NSString stringWithFormat:@"已录取:%@人",fujinjianzhimodel.employment_number];
    }
    self.completeLabel.text = cStr;
    
    
    //每单的价格
//    NSString *unit = [self unitWithType:[fujinjianzhimodel.unit integerValue]];
//    NSString *price = fujinjianzhimodel.salary;
//    NSString *singtr = [NSString stringWithFormat:@"%@/%@",price,unit];
//    
//    self.wnLabel.text = singtr;
    
    self.wnLabel.text = fujinjianzhimodel.wn;
    //有效时间
    
    self.timeTypeLabel.text = [NSString stringWithFormat:@"工作开始:%@",fujinjianzhimodel.start_date];
    //标签tags
    
    
    NSString *address = fujinjianzhimodel.work_area;
    NSString *settmnet = [NSString settmenJianZhiWithType:[fujinjianzhimodel.settlement integerValue]];
    
    self.tagsLabel.text = [NSString stringWithFormat:@"%@ | %@",address,settmnet];
    
    
    //处理时间 new
     self.isNewProjectImageView.hidden = YES;
    
    

    
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

@end
