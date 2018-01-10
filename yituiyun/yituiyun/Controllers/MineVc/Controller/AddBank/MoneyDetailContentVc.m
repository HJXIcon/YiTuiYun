//
//  MoneyDetailContentVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "MoneyDetailContentVc.h"
#import "MoneyDetailContentCell.h"
#import "NSString+LHKExtension.h"


@interface MoneyDetailContentVc ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * datas;
@property(nonatomic,strong) NSMutableArray * tixianDatas;

@end

@implementation MoneyDetailContentVc
-(ChangeOrjiyi *)fistDataModel{
    if (_fistDataModel == nil) {
        _fistDataModel = [[ChangeOrjiyi alloc]init];
    }
    return _fistDataModel;
}

-(TixianOrTuiKuan *)secondDataModel{
    if (_secondDataModel == nil) {
        _secondDataModel = [[TixianOrTuiKuan alloc]init];
    }
    return _secondDataModel;
}
-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(NSMutableArray *)tixianDatas{
    if (_tixianDatas == nil) {
        _tixianDatas = [NSMutableArray array];
    }
    return _tixianDatas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyDetailContentCell" bundle:nil] forCellReuseIdentifier:@"MoneyDetailContentCell"];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGBString(@"0xfafafa");
    
    
    if (self.type == 1) {
        
        [self jiaoxiData]; //交易明细

    }else{
        [self tixianData];//提现
    }
}
-(void)jiaoxiData{
    
    [SVProgressHUD showWithStatus:@"数据加载中.."];
    MJWeakSelf
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict[@"uid"] = userModel.userID;
    parmDict[@"adid"] = self.model.adid;
    
    [XKNetworkManager POSTToUrlString:MyMoneyOneDetail parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
       
//        NSLog(@"----%@--",resultDict);
        
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
        
            NSDictionary *contentDic = resultDict[@"rst"];
            
            weakSelf.fistDataModel = [ChangeOrjiyi objectWithKeyValues:contentDic];
                        [weakSelf.tableView reloadData];
        
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)tixianData{
    [SVProgressHUD showWithStatus:@"数据加载中.."];
    MJWeakSelf
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict[@"memberid"] = userModel.userID;
    parmDict[@"did"] = self.tixianModel.did;
    
    [XKNetworkManager POSTToUrlString:TiXianRecordDetail parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
 
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *contentDic = resultDict[@"rst"];
            
            weakSelf.secondDataModel = [TixianOrTuiKuan objectWithKeyValues:contentDic];
            
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
 
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.type == 1) {
//        
//        return 7;
//    }
    
    return 7;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(65);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    if (self.type ==1) {
        MoneyDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyDetailContentCell"];
        if (indexPath.row == 0) {
            cell.oneLabel.text = @"交易类型";

            cell.twoLabel.text = self.fistDataModel.intro;

            cell.twoLabel.textColor = [UIColor blackColor];
        }else if (indexPath.row == 1){
            
            
            cell.oneLabel.text =  @"交易金额";
            cell.twoLabel.text = self.fistDataModel.money;
            cell.twoLabel.textColor =UIColorFromRGBString(@"0xff9f4a");

            
        }else if (indexPath.row == 2){
            
                cell.oneLabel.text = @"交易说明";
                cell.twoLabel.text = self.fistDataModel.projectName;
                cell.twoLabel.textColor = [UIColor blackColor];
            
            if ([self.fistDataModel.t isEqualToString:@"6"]) {
                cell.twoLabel.text = [NSString stringWithFormat:@"从好友(%@)获得佣金",self.fistDataModel.nickname];
            }
 
           

        }else if (indexPath.row == 3){
            cell.oneLabel.text = @"支付方式";
            cell.twoLabel.text = self.fistDataModel.payment;
            cell.twoLabel.textColor = [UIColor blackColor];

        }else if (indexPath.row == 4){
            cell.oneLabel.text = @"交易时间";
            cell.twoLabel.text = [NSString timeHasSecondTimeIntervalString:self.fistDataModel.add_time];
            cell.twoLabel.textColor = [UIColor blackColor];

        }else if (indexPath.row == 5){
            cell.oneLabel.text = @"订单号";
            cell.twoLabel.text = self.fistDataModel.orderno;
            cell.twoLabel.textColor = [UIColor blackColor];

        }else if (indexPath.row == 6){
            cell.oneLabel.text = @"备注";
            cell.twoLabel.text = self.fistDataModel.remark;
            cell.twoLabel.textColor = [UIColor blackColor];
            
        }




        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if ([NSString stringIsEmpty:cell.twoLabel.text]) {
            cell.twoLabel.text = @"暂无";
        }
        
        return cell;
 
    }else{
        MoneyDetailContentCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"MoneyDetailContentCell"];
        UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];

        if (indexPath.row == 0) {
            cell1.oneLabel.text = @"交易类型";
            
            if ([usermodel.identity isEqualToString:@"5"]) {
               cell1.twoLabel.text = @"退款";
            }else{
                cell1.twoLabel.text = @"提现";
            }
            
            cell1.twoLabel.textColor = [UIColor blackColor];
            
            
        }else if (indexPath.row == 1){
            
            cell1.oneLabel.text = @"交易金额";
            
            cell1.twoLabel.text = self.secondDataModel.money;
            cell1.twoLabel.textColor =UIColorFromRGBString(@"0xff9f4a");
            
        }else if (indexPath.row == 2){
           
                cell1.oneLabel.text = @"交易说明";
            
            cell1.twoLabel.text = self.secondDataModel.t_str;
            cell1.twoLabel.textColor =[UIColor blackColor];
            
        }else if (indexPath.row == 3){
            
                cell1.oneLabel.text = @"交易时间";
            
            cell1.oneLabel.text = @"时间";
            cell1.twoLabel.textColor = [UIColor blackColor];
            cell1.twoLabel.text = [NSString timeHasSecondTimeIntervalString:self.secondDataModel.inputtime];
            
        }else if (indexPath.row == 4){
            cell1.oneLabel.text = @"订单号";
            cell1.twoLabel.textColor = [UIColor blackColor];
            cell1.twoLabel.text = self.secondDataModel.orderno;
            
        }else if (indexPath.row == 5){
            cell1.oneLabel.text = @"交易状态";
            cell1.twoLabel.textColor = UIColorFromRGBString(HongSeMain);
            cell1.twoLabel.text = self.secondDataModel.status_str;
            
        }else if (indexPath.row == 6){
            cell1.oneLabel.text = @"备注";
            cell1.twoLabel.textColor = [UIColor blackColor];
            cell1.twoLabel.text = self.secondDataModel.reason;
            
        }

        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        if ([NSString stringIsEmpty:cell1.twoLabel.text]) {
            cell1.twoLabel.text = @"暂无";
        }
        return cell1;

    }
    
    
  
    
    return nil;
    
}


-(NSString *)detailtypeStr:(NSInteger)index{
    switch (index) {
        case 1:
            return @"充值";
            break;
        case 2:
            return @"退款";
            break;
        case 3:
            return @"工资";
            break;
        case 4:
            return @"提现";
            break;
        case 5:
            return @"支付需求";
            break;
        case 6:
            return @"佣金";
            break;
        case 7:
            return @"劳务税";
            break;
            
        default:
            return @"充值";
            break;
    }
    
}
-(void)dealloc{
//    NSLog(@"---------");
}


@end
