//
//  MyWalletTishi.m
//  yituiyun
//
//  Created by yituiyun on 2017/10/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "MyWalletTishi.h"

@interface MyWalletTishi()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,assign)BOOL  isReallName;
@end

@implementation MyWalletTishi

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        
        

        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self getRealNameStaus];
        
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isReallName) {
        return 5;
    }
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.subviews) {
        if ([view isMemberOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc]init];
  
    label.numberOfLines = 0 ;
  
    if (ScreenWidth<375) {
         label.font = [UIFont systemFontOfSize:12];
    }else{
          label.font = [UIFont systemFontOfSize:13];
    }
    label.textColor = UIColorFromRGBString(@"0x636363");
    [cell addSubview:label];
    
    
    if (indexPath.row == 0) {
        label.text = @"1.提现申请后，最晚3工作日到帐，节假日，非工作日除外。";
        label.frame = CGRectMake(0, 0, ScreenWidth-20, 44);
        label.text = @"提现须知:";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
    }
    
    else if (indexPath.row == 1) {
        label.text = @"1.提现申请后，最晚3工作日到帐，节假日，非工作日除外。";
        label.frame = CGRectMake(0, 0, ScreenWidth-20, 44);
    }else if(indexPath.row == 2){
        label.text = @"2.单次提现金额小于200元，需要而外收取2元提现手续费；单次提现金额大于或等于200元，免提现手续费。";
          label.frame = CGRectMake(0, 0, ScreenWidth-20, 44);
    }else if(indexPath.row == 3){
        label.text = @"3.个人当月工资收入超过3500元，按照规定的相关劳务协议上交个人所得税，平台自动从您个人工资里扣税，由易推云代缴到国家税务机关。扣除金额按国家规定执行。具体请参考国家最新劳务税政策。 如：当月累计收入为3600元，按照国家政策，您超出的100元需要缴纳3%共3元的个人所得税，您的税后收入是3597元。";
          label.frame = CGRectMake(0, 0, ScreenWidth-20, 100);
    }else{
        label.text = @"非全日制用工劳动合同书 >>";
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(0, 0, ScreenWidth-20, 44);
        label.textColor = UIColorFromRGBString(@"0xf16156");
    }
  
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 90;
    }
    if (indexPath.row == 0) {
        return 30;
    }
    return 44;
}

-(void)getRealNameStaus{
    MJWeakSelf
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parmDict[@"memberid"] = model.userID;
    [XKNetworkManager POSTToUrlString:RealNameCerfiStatus parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
       
        NSDictionary *resutDic=JSonDictionary;
        
        
        
        NSString *errnoString = [NSString stringWithFormat:@"%@",resutDic[@"errno"] ];
        
        if ([errnoString isEqualToString:@"0"]) {
            //0 未认证 //1 审核中  //2 已认证 //3 认证失败
            
            
            
            NSInteger status = [resutDic[@"rst"][@"is_authentication"] integerValue];
            
            if (status == 2) {
                weakSelf.isReallName = YES;
            }else{
                weakSelf.isReallName = NO;
            }
        }else{
           weakSelf.isReallName = NO;
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
      weakSelf.isReallName = NO;
       
    }];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 4) {

        if (self.block) {
            self.block();
        }
    }
}
@end
