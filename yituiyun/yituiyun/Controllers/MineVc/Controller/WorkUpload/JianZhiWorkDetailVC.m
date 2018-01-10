//
//  JianZhiWorkDetailVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/9/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiWorkDetailVC.h"
#import "CancelTaskCell.h"
#import "WorkResonVC.h"
#import "JianZhiWorkDetailModel.h"
#import "JXRepeatButton.h"

@interface JianZhiWorkDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) JXRepeatButton * otherBtn;

@property(nonatomic,strong) JXRepeatButton * nopassBtn;

@property(nonatomic,strong) JXRepeatButton * passBtn;
@property(nonatomic,strong) JianZhiWorkDetailModel * model;

@end

@implementation JianZhiWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"招聘列表";
    [self setupTableView];
    [self dataArrayFrom];
    self.model = [[JianZhiWorkDetailModel alloc]init];
    
  
}

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64  - 44) style:UITableViewStylePlain];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView registerClass:[CancelTaskCell class] forCellReuseIdentifier:@"CancelTaskCell"];
    [self.view addSubview:_tableView];
}

-(JXRepeatButton *)nopassBtn{
    if (_nopassBtn == nil) {
        
        //不通过
        
        CGFloat h = 44;
        CGFloat y = ScreenHeight -44-64;
        
        _nopassBtn = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
        _nopassBtn.frame = CGRectMake(0, y, ZQ_Device_Width*0.5 , h);
        _nopassBtn.backgroundColor = [UIColor whiteColor];
        _nopassBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nopassBtn addTarget:self action:@selector(nopassBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_nopassBtn setTitle:@"不通过" forState:UIControlStateNormal];
        [_nopassBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        
    }
    return _nopassBtn;
}


-(JXRepeatButton *)passBtn{
    if (_passBtn == nil) {
        //通过
        CGFloat h = 44;
        CGFloat y = ScreenHeight -44-64;
        _passBtn = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
        _passBtn.frame = CGRectMake(ZQ_Device_Width*0.5, y, ZQ_Device_Width*0.5 , h);
        _passBtn.backgroundColor = UIColorFromRGBString(@"0xf16156");
        _passBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_passBtn addTarget:self action:@selector(passBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        [_passBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    }
    return _passBtn;
}

-(JXRepeatButton *)otherBtn{
    if (_otherBtn == nil) {
        CGFloat h = 44;
        CGFloat y = ScreenHeight -44-64;
        
        
        _otherBtn = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
        _otherBtn.frame = CGRectMake(0, y, ZQ_Device_Width , h);
        _otherBtn.backgroundColor = kUIColorFromRGB(0xcacaca);
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _otherBtn.userInteractionEnabled = NO;
        [_otherBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        
    }
    return _otherBtn;
}


#pragma mark - 不通过

-(void)passBtnClick{
    
    
    
    LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"通过后佣金将直接发放到该用户账号上" WithCancelBlock:^(LHKAlterView *alterView) {
        [alterView removeFromSuperview];
    } WithMakeSure:^(LHKAlterView *alterView) {
        
        /***************/
        MJWeakSelf
        [SVProgressHUD showWithStatus:@"加载中.."];
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        parm[@"nodeid"] = self.nodeID;
        parm[@"user_id"] = model.userID;
        parm[@"t"] = @(1);
        //        parm[@"remark"] = @"";
        
        [XKNetworkManager POSTToUrlString:CompanyNeedShenHeSucess parameters:parm progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *resultDict = JSonDictionary;
            NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
            NSString *reson = [NSString stringWithFormat:@"%@",resultDict[@"errmsg"]];
            
            //            NSLog(@"-----%@-%@-",resultDict,self.nodeID);
            if ([code isEqualToString:@"0"]) {
                
                
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showHint:reson];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf showHint:error.localizedDescription];
        }];
        
        
        /***************/
        
        [alterView removeFromSuperview];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alt];
    
    
}

-(void)nopassBtnClick{
    
    WorkResonVC *vc = [[WorkResonVC alloc]init];
    vc.nodeID = self.nodeID;
    vc.navigationItem.title = @"填写理由";
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf
   
        
        CancelTaskCell *cell = [CancelTaskCell cellWithTableView:tableView];
    
    
        cell.textField.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"上传用户:";
            cell.textField.text = self.model.nickname;
        }else{
            cell.nameLabel.text = @"联系电话:";
            cell.textField.text = self.model.mobile;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"时间:";
            cell.textField.text = [NSString timeHasSecondTimeIntervalString:self.model.inputtime];
        }else{
            cell.nameLabel.text = @"地址:";
            cell.textField.text = self.model.address;
        }
    }else{
        
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"时间:";
            cell.textField.text = [NSString timeHasSecondTimeIntervalString:self.model.update_time];
        }else{
            cell.nameLabel.text = @"地址:";
            cell.textField.text = self.model.end_address;
        }
    }
    
        return cell;
        
}


- (void)dataArrayFrom {
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"nodeid"] =self.nodeID;
    
    [XKNetworkManager POSTToUrlString:TaskNodeTimeDetail parameters:parm progress:^(CGFloat progress) {
        [SVProgressHUD  dismiss];
    } success:^(id responseObject) {
        [SVProgressHUD  dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        
        if (![resultDict[@"errno"] isEqualToString:@"0"]) {
            [weakSelf showHint:resultDict[@"errmsg"]];
            return ;
        }
        
        
        //姓名
//        weakSelf.name = resultDict[@"rst"][@"node"][@"nickname"];
//        //tel
//        weakSelf.tel =  resultDict[@"rst"][@"node"][@"mobile"];
        
        weakSelf.model = [JianZhiWorkDetailModel objectWithKeyValues:resultDict[@"rst"][@"node"]];
        
//    
//        
        //状态码
        NSString *statusCode =   resultDict[@"rst"][@"node"][@"auditing_status"];
        
        
        if ([statusCode isEqualToString:@"2"]) { //是企业审核中
            [weakSelf.view addSubview:weakSelf.nopassBtn];
            [weakSelf.view addSubview:weakSelf.passBtn];
            
        }else{
            [weakSelf.view addSubview:weakSelf.otherBtn];
            
            [weakSelf.otherBtn setTitle:[NSString getStringWithCompanyType:[statusCode integerValue]] forState:UIControlStateNormal];
            
        }
        
        
       
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD  dismiss];
    }];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section  == 0) {
        return  0.00001;
    }
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }else{
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        backView.backgroundColor = [UIColor whiteColor];
        
        //上面
        UIView  *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        upView.backgroundColor = UIColorFromRGBString(@"0xededed");
        [backView addSubview:upView];
        
        //中间
        UILabel *middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth, 29)];
        middleLabel.textColor = UIColorFromRGBString(@"0x5e5e5e");
        middleLabel.font = [UIFont systemFontOfSize:14];
        if (section == 1) {
            middleLabel.text = @"上班";
        }else{
            middleLabel.text = @"下班";
        }
        [backView addSubview:middleLabel];
        
        //下班
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        lineView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
        [backView addSubview:lineView];
        
        
        return backView;
    }
    return nil;
}

@end
