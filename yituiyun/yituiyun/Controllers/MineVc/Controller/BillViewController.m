//
//  BillViewController.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BillViewController.h"
#import "ProBillVC.h"
#import "LHKLeftButoon.h"
#import "BillinfomationCell.h"
#import "BillHistroyListVC.h"
#import "CompanyFaPiaoModel.h"
#import "NormalBillVc.h"
@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton * selectAllBtn;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) NSMutableArray * selectArray;
@end

@implementation BillViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //右上角的按钮和选择所有按钮
    [self setupRightBtn];
    
    [self.view addSubview:self.tableView];
//加载数据
    [self getDataFromServer];
    
}


-(void)getDataFromServer{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    UserInfoModel *usermodel =[ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = usermodel.userID;
    
    [XKNetworkManager POSTToUrlString:FaPiaoRecordList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        
        NSString *code =[NSString stringWithFormat:@"%@", resultDict[@"errno"]];
        NSString *tishimessage = [NSString stringWithFormat:@"%@", resultDict[@"errmsg"]];
        
        if ([code isEqualToString:@"0"]) {
            
            weakSelf.dataArray = [CompanyFaPiaoModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
            [weakSelf.tableView reloadData];
            
        }else{
            [weakSelf showHint:tishimessage];
 
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
-(void)setupRightBtn{
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = [NSString sizeWithString:@"开票历史" andFont:[UIFont systemFontOfSize:FontRadio(14)] andMaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [btn setTitle:@"开票历史" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FontRadio(14)];
    [btn addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    //选择所有的按钮
    self.selectAllBtn = [[LHKLeftButoon alloc]initWithFrame:CGRectMake(ScreenWidth-75+2, 0, 75, HRadio(50))];
    
    [self.selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
   
    [self.selectAllBtn setTitleColor:UIColorFromRGBString(@"0x464646") forState:UIControlStateNormal];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"dian_normal"] forState:UIControlStateNormal];
    
    [self.selectAllBtn setImage:[UIImage imageNamed:@"dian_select"] forState:UIControlStateSelected];
    [self.view addSubview:self.selectAllBtn];
    
    
    UIView *linView = [[UIView alloc]initWithFrame:CGRectMake(0, HRadio(49), ScreenWidth, HRadio(1))];
    
    linView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
    [self.view addSubview:linView];
    
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HRadio(50), ScreenWidth, ScreenHeight-64-HRadio(50)-HRadio(44)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BillinfomationCell" bundle:nil] forCellReuseIdentifier:@"BillinfomationCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(void)rightbtnClick{
    
    BillHistroyListVC *listVc = [[BillHistroyListVC alloc]init];
    listVc.navigationItem.title = @"开票历史";
    pushToControllerWithAnimated(listVc)
    
}

-(void)selectAllBtnClick:(UIButton *)btn{
   
    
    
    if (self.dataArray.count > 0) {
        
         btn.selected = !btn.selected;
        
        
        if (btn.selected) {
            [self.selectArray removeAllObjects];
            [self.selectArray addObjectsFromArray:self.dataArray];
            
            for (CompanyFaPiaoModel *model in self.dataArray) {
                model.isSelect = YES;
            }
            
        }else{
            
            [self.selectArray removeAllObjects];
            
            for (CompanyFaPiaoModel *model in self.dataArray) {
                model.isSelect = NO;
            }
        }
        
            CGFloat sum = 0.0f;
            for (CompanyFaPiaoModel *model in self.selectArray) {
                sum+=[model.total_price floatValue];
            }
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",sum];
    
        
        
        
        [self.tableView reloadData];

    }
    
    
}

#pragma mark -- tableView 代理和数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(135);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyFaPiaoModel *datamodel = self.dataArray[indexPath.row];
    BillinfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillinfomationCell"];
//    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    cell.taskNameLabel.text = datamodel.projectName;
    cell.moneyLabel.text = datamodel.total_price;
    cell.startTimeLabel.text = [NSString timeHasSecondTimeIntervalString:datamodel.starttime];
    cell.endTimeLabel.text = [NSString timeHasSecondTimeIntervalString:datamodel.inputtime];

    if (datamodel.isSelect) {
        cell.selectImageView.image = [UIImage imageNamed:@"dian_select"];
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"dian_normal"];
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyFaPiaoModel *datamodel = self.dataArray[indexPath.row];
    
    if (datamodel.isSelect) {
        datamodel.isSelect = NO;
        [self.selectArray removeObject:datamodel];
        self.selectAllBtn.selected = NO;
    }else{
        datamodel.isSelect = YES;
        [self.selectArray addObject:datamodel];
    }
    
   
        CGFloat sum = 0.0f;
        for (CompanyFaPiaoModel *model in self.selectArray) {
            sum+=[model.total_price floatValue];
        }
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",sum];
   
    
    if (self.selectArray.count == self.dataArray.count) {
        self.selectAllBtn.selected = YES;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark--开票按钮

- (IBAction)proBtnClick:(UIButton *)sender {
    
    
    
    if (self.selectArray.count == 0) {
        [self showHint:@"请选择发票记录"];
        return ;
    }
    
    NSMutableString *acount_id = [[NSMutableString alloc]init];
    
    if (self.selectArray.count == 1) {
       
        CompanyFaPiaoModel *model = self.selectArray[0];
        acount_id = [model.cid mutableCopy];
    }else{
        
        for ( int i = 0; i<self.selectArray.count; i++) {
            
             CompanyFaPiaoModel *model = self.selectArray[i];
            if (i == self.selectArray.count-1) {
                [acount_id appendFormat:@"%@",model.cid];
            }else{
               [acount_id appendFormat:@"%@,",model.cid];
            }
            
        }
    }
    
    
    MJWeakSelf
    
    ProBillVC *blivc = [[ProBillVC alloc]init];
    blivc.acount_id = acount_id;
    blivc.totalmoney = self.totalMoneyLabel.text;
    blivc.navigationItem.title = @"开专票";
   
    blivc.callback = ^{
      //回调
        weakSelf.selectAllBtn.selected = NO;
        [weakSelf.selectArray removeAllObjects];
        [weakSelf.dataArray removeAllObjects];
        weakSelf.totalMoneyLabel.text = @"0元";
        [weakSelf getDataFromServer];
        

        
    };
    pushToControllerWithAnimated(blivc)
}
- (IBAction)normalBtnClick:(UIButton *)sender {
   
   
    
    if (self.selectArray.count == 0) {
        [self showHint:@"请选择发票记录"];
        return ;
    }
    
    NSMutableString *acount_id = [[NSMutableString alloc]init];
    
    if (self.selectArray.count == 1) {
        
        CompanyFaPiaoModel *model = self.selectArray[0];
        acount_id = [model.cid mutableCopy];
    }else{
        
        for ( int i = 0; i<self.selectArray.count; i++) {
            
            CompanyFaPiaoModel *model = self.selectArray[i];
            if (i == self.selectArray.count-1) {
                [acount_id appendFormat:@"%@",model.cid];
            }else{
                [acount_id appendFormat:@"%@,",model.cid];
            }
            
        }
    }
    
    
    
    MJWeakSelf
    NormalBillVc *blivc = [[NormalBillVc alloc]init];
    blivc.acount_id = acount_id;
    blivc.totalmoney = self.totalMoneyLabel.text;
    blivc.navigationItem.title = @"开普票";
   
    blivc.callback = ^{
        
        weakSelf.selectAllBtn.selected = NO;
        [weakSelf.selectArray removeAllObjects];
        [weakSelf.dataArray removeAllObjects];
          weakSelf.totalMoneyLabel.text = @"0元";
        [weakSelf getDataFromServer];
        
        
    };
    pushToControllerWithAnimated(blivc)
}

#pragma mark -- 获取最后一次发票的信息


@end
