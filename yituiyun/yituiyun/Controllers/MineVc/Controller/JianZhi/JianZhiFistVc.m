//
//  JianZhiFistVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiFistVc.h"
#import "JianZhiFistCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "JianZhiFistListView.h"
#import "WSDatePickerView.h"
#import "LZCityPickerController.h"


@interface JianZhiFistVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) TPKeyboardAvoidingTableView * tableView;
@property(nonatomic,strong) NSArray * datas;
@property(nonatomic,strong) JianZhiFistListView * listView;
@end

@implementation JianZhiFistVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (self.detailmodel == nil) {
        self.datas = @[
                       @{@"title":@"职位名称:",@"desc":@"请输入5-20的标题"},
                       @{@"title":@"薪资待遇:",@"desc":@"请输入薪资待遇"},
                       @{@"title":@"结算方式:",@"desc":@"请选择结算方式"},
                       @{@"title":@"招聘人数:",@"desc":@"请输入需要招聘的人数/天"},
                       @{@"title":@"工作开始时间:",@"desc":@"请选择工作开始时间"},
                       @{@"title":@"工作截止时间:",@"desc":@"请选择工作截止时间"},
                       @{@"title":@"工作天数:",@"desc":@""},
                       @{@"title":@"联系人:",@"desc":@"请输入联系人名字"},
                       @{@"title":@"联系人电话:",@"desc":@"请输入联系人电话"},
                       @{@"title":@"联系邮箱:",@"desc":@"请输入联系邮箱"},
                       @{@"title":@"工作地点:",@"desc":@"请输入工作地点/省、市、区"},
                       @{@"title":@"详细地址:",@"desc":@"请输入工作详细地点"}
                       
                       ];
        
 
    }else{
        
        
        
        
        
        self.datas = @[
                       
                       
                       @{@"title":@"职位名称:",@"desc":[self getNotNullString:self.detailmodel.title]},
                       @{@"title":@"薪资待遇:",@"desc":[self getNotNullString:self.detailmodel.salary],@"desc2":[self getNotNullString:self.detailmodel.unit]},
                       @{@"title":@"结算方式:",@"desc":[self getNotNullString:self.detailmodel.settlement]},
                       
                       @{@"title":@"招聘人数:",@"desc":[self getNotNullString:self.detailmodel.person_number]},
                       @{@"title":@"工作开始时间:",@"desc":[self getNotNullString:self.detailmodel.start_date]},
                       @{@"title":@"工作截止时间:",@"desc":[self getNotNullString:self.detailmodel.end_date]},
                        @{@"title":@"工作天数:",@"desc":[self getNotNullString:self.detailmodel.days]},
                       @{@"title":@"联系人:",@"desc":[self getNotNullString:self.detailmodel.contact]},
                       
                       @{@"title":@"联系人电话:",@"desc":[self getNotNullString:self.detailmodel.phone]},
                       
                       @{@"title":@"联系邮箱:",@"desc":[self getNotNullString:self.detailmodel.email]},
                      
                       @{@"title":@"工作地点:",@"desc":[self getNotNullString:self.detailmodel.detail_area]},
                       
                       @{@"title":@"详细地址:",@"desc":[self getNotNullString:self.detailmodel.address]}
                       
                       
                       ];
        

    }
    
    
    
}

-(NSString *)getNotNullString:(NSString *)str{
    if ([ZQ_CommonTool isEmpty:str]) {
        return @"0";
    }
    return str;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiFistCell" bundle:nil] forCellReuseIdentifier:@"fistcell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(44);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MJWeakSelf
    
    JianZhiFistCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"fistcell"];
    NSDictionary *dict = self.datas[indexPath.row];
    cell.descTextField.keyboardType = UIKeyboardTypeDefault;
    
    
    if (indexPath.row == 1 ) {
        cell.descTextField.hidden = NO;
        cell.listBtn.hidden = NO;
        cell.descBtn.hidden = YES;
        cell.arrowImageView.hidden = YES;
        cell.descTextField.enabled = YES;
        cell.descTextField.keyboardType =  UIKeyboardTypeDecimalPad;

        
        cell.Titlelabel.text = dict[@"title"];
        
        if (self.detailmodel ==nil  || self.ismodfiy) {
            
            if (self.ismodfiy) {
               cell.descTextField.text = dict[@"desc"];
            }else{
               cell.descTextField.placeholder = dict[@"desc"];
                
                
            }
            
            [cell.listBtn setTitle:@"天" forState:UIControlStateNormal];
            [cell.listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.textfieldblock = ^(NSString *str) {
                
                [JianZhiModel shareInstance].salary = str;
                
                
            };
            
            cell.listblock = ^(UIButton *btn) {
                
                CGRect rect = [cell convertRect:cell.listBtn.frame toView:weakSelf.tableView];
                
                NSArray *datas = @[@"天"];
                
                weakSelf.listView = [[JianZhiFistListView alloc]initWithRect:rect andDatas:datas];
                [weakSelf.view addSubview:weakSelf.listView];
                
                weakSelf.listView.listreturnblock = ^(NSString *str,NSInteger index) {
                    [btn setTitle:str forState:UIControlStateNormal];
                    [JianZhiModel shareInstance].unit = [NSString stringWithFormat:@"%ld",index+1];
                    
                    
                };
            };

        }else{
            
            cell.descTextField.text = dict[@"desc"];
            cell.descTextField.enabled = NO;
            [cell.listBtn setTitle:[NSString unitJianZhiWithType:[dict[@"desc2"] integerValue]] forState:UIControlStateNormal];
            [cell.listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            
        }
        
    }else if (indexPath.row == 2){
        
        cell.descTextField.hidden = NO;
        cell.listBtn.hidden = NO;
        cell.descBtn.hidden = YES;
        cell.arrowImageView.hidden = YES;
        cell.descTextField.enabled = NO;
        
        cell.Titlelabel.text = dict[@"title"];
        
        if (self.detailmodel == nil || self.ismodfiy ) {
//            cell.descTextField.placeholder = dict[@"desc"];
            
            [cell.listBtn setTitle:@"日结" forState:UIControlStateNormal];
            [cell.listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if (self.ismodfiy) {
                [cell.listBtn setTitle:[NSString settmenJianZhiWithType:[dict[@"desc"] integerValue]] forState:UIControlStateNormal];
                [cell.listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            
            
            cell.listblock = ^(UIButton *btn) {
                
                CGRect rect = [cell convertRect:cell.listBtn.frame toView:weakSelf.tableView];
                
                NSArray *datas = @[@"日结",@"次日结"];
                
                weakSelf.listView = [[JianZhiFistListView alloc]initWithRect:rect andDatas:datas];
                [weakSelf.view addSubview:weakSelf.listView];
                
                weakSelf.listView.listreturnblock = ^(NSString *str,NSInteger index) {
                    [btn setTitle:str forState:UIControlStateNormal];
                    [JianZhiModel shareInstance].settlement = [NSString stringWithFormat:@"%ld",index+1];
                };
            };
 
        }else{
            cell.descTextField.text = @"";
            cell.descTextField.enabled = NO;
            [cell.listBtn setTitle:[NSString settmenJianZhiWithType:[dict[@"desc"] integerValue]] forState:UIControlStateNormal];
            [cell.listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        
        
    }else if (indexPath.row == 4 || indexPath.row == 5){
        cell.descTextField.hidden = YES;
        cell.listBtn.hidden = YES;
        cell.arrowImageView.hidden = NO;
        cell.descBtn.hidden = NO;
         cell.descTextField.enabled = YES;
        cell.Titlelabel.text  = dict[@"title"];
        
        if (self.detailmodel== nil || self.ismodfiy) {
            [cell.descBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.descBtn setTitle:dict[@"desc"] forState:UIControlStateNormal];
            if (self.ismodfiy) {
                [cell.descBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                
                if (![ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].start_date] && indexPath.row == 4) {
                    [cell.descBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell.descBtn setTitle:[JianZhiModel shareInstance].start_date forState:UIControlStateNormal];
                }
                
                if (![ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].end_date] && indexPath.row == 5) {
                    [cell.descBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell.descBtn setTitle:[JianZhiModel shareInstance].end_date forState:UIControlStateNormal];
                }
            }
            
            cell.addressblock = ^(UIButton *btn) {
             
                WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
                    NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
                    
                    
                    if (indexPath.row == 4) {
                         [JianZhiModel shareInstance].start_date = date;
                    }else{
                         [JianZhiModel shareInstance].end_date = date;
                    }
                    
                    if (![ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].start_date] && ![ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].end_date]) {
                       
                        long long uptime = [NSString timeSwitchTimestamp:[JianZhiModel shareInstance].start_date andFormatter:@""];
                        long long downtime = [NSString timeSwitchTimestamp:[JianZhiModel shareInstance].end_date andFormatter:@""];
                        
                        if (downtime<uptime) {
                            [self showHint:@"截止时间不能小于开始时间"];
                            return ;
                        }else{
                            NSInteger intvaltime = 1+ (downtime - uptime)/86400;
                            JianZhiFistCell *shijianCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
                            shijianCell.descTextField.text = [NSString stringWithFormat:@"%ld天",intvaltime];
                            
                            
                        }
                    }
                    
                   
                    [btn setTitle:date forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                }];
                datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
                [datepicker show];
                [weakSelf.view endEditing:YES];
                
            };
 
        }else{
            [cell.descBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.descBtn.userInteractionEnabled = NO;
            [cell.descBtn setTitle:dict[@"desc"] forState:UIControlStateNormal];
        }
       
    }
    
    
    else if (indexPath.row == 10){
        cell.descTextField.hidden = YES;
        cell.listBtn.hidden = YES;
        cell.arrowImageView.hidden = NO;
        cell.descBtn.hidden = NO;
         cell.descTextField.enabled = YES;
        cell.Titlelabel.text  = dict[@"title"];
        
        if (self.detailmodel == nil  || self.ismodfiy ) {
            [cell.descBtn setTitle:dict[@"desc"] forState:UIControlStateNormal];
            if (self.ismodfiy) {
             [cell.descBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
            }else{
                [cell.descBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateNormal];
            }
           
            cell.addressblock = ^(UIButton *btn) {
               
                NSArray *cityArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityAddressArray"];
                
                if (cityArray.count == 0) {
                    [weakSelf requestCityAddress:btn];
                    
                }else{
                    [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
                        
                        // 选择结果回调
                        [btn setTitle:address forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        
                        
                        
                        [JianZhiModel shareInstance].province = province;
                        [JianZhiModel shareInstance].city = city;
                        [JianZhiModel shareInstance].area = area;
                        
                    }];
                }
                
                
                
                
            };
  
        }else{
            
            
            
            [cell.descBtn setTitle:dict[@"desc"] forState:UIControlStateNormal];
            cell.descBtn.userInteractionEnabled = NO;
            [cell.descBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];

            
        }
        
        
        
        
    }else{
        cell.listBtn.hidden = YES;
        cell.arrowImageView.hidden = YES;
        cell.descTextField.hidden = NO;
        cell.descBtn.hidden = YES;
        cell.Titlelabel.text  = dict[@"title"];
        
        if (indexPath.row == 3) {
             cell.descTextField.keyboardType =  UIKeyboardTypeNumberPad;
        }
        
        if (indexPath.row == 6) {
            cell.descTextField.enabled = NO;
            cell.descTextField.text = self.detailmodel.days;
        }else{
            cell.descTextField.enabled = YES;
        }
        
        if (self.detailmodel == nil  || self.ismodfiy) {
            if (self.ismodfiy) {
                cell.descTextField.text = dict[@"desc"];
            }else{
                cell.descTextField.placeholder = dict[@"desc"];
            }
            
            
            cell.textfieldblock = ^(NSString *str) {
                
                switch (indexPath.row) {
                    case 0:
                        [JianZhiModel shareInstance].title = str;
                        break;
                    case 3:
                        
                        
                       
                        [JianZhiModel shareInstance].person_number = str;
                        break;
                    case 7:
                        [JianZhiModel shareInstance].contact = str;
                        break;
                    case 8:
                        [JianZhiModel shareInstance].phone = str;
                        
                        break;
                    case 9:
                        [JianZhiModel shareInstance].email = str;
                        
                        break;
                    case 11:
                        [JianZhiModel shareInstance].address = str;
                        
                        break;
                        
                    default:
                        break;
                }
            };
            
            
        }else{
            cell.descTextField.enabled = NO;
            cell.descTextField.text = dict[@"desc"];
            
        }
  
        }
        
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)requestCityAddress:(UIButton *)btn{
    
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    NSDictionary *parm = [NSDictionary dictionary];
    
    [XKNetworkManager POSTToUrlString:AllCitys parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
       
        
        NSDictionary *dict = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            
            NSArray *cityAddressArray = dict[@"rst"];
            
            [[NSUserDefaults standardUserDefaults] setObject:cityAddressArray forKey:@"cityAddressArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求操作
                [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
                    
                    // 选择结果回调
                    [btn setTitle:address forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                   
                    
                }];
                
            });
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showHint:@"服务器没请求到数据"];
        }
        
        
        
        
    } failure:^(NSError *error) {
        [weakSelf showHint:@"服务器出错"];
    }];
}
@end
