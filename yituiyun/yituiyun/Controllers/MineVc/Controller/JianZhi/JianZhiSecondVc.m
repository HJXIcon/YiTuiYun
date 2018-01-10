//
//  JianZhiSecondVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiSecondVc.h"
#import "TPKeyboardAvoidingTableView.h"
#import "JianZhiSecondupCell.h"
#import "JianZhiSecondDownCell.h"
#import "JianZhiFistListView.h"
#import "JianZhiContainerVC.h"
#import "OrderPayVc.h"
@interface JianZhiSecondVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) TPKeyboardAvoidingTableView * tableView;
@property(nonatomic,strong) UIButton * makeSureBtn;
@property(nonatomic,strong) JianZhiFistListView * listView;

@end

@implementation JianZhiSecondVc
-(UIButton *)makeSureBtn{
    if (_makeSureBtn == nil) {
        _makeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(WRadio(46), ScreenHeight -HRadio(180), ScreenWidth -2*WRadio(46), HRadio(44))];
        [_makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _makeSureBtn.backgroundColor = UIColorFromRGBString(@"0xf16156");
        [_makeSureBtn setTitle:@"确认发布" forState:UIControlStateNormal];
        _makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_makeSureBtn addTarget:self action:@selector(makeSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _makeSureBtn.layer.cornerRadius = 5;
        _makeSureBtn.clipsToBounds = YES;
    }
    return _makeSureBtn;
}

-(void)makeSureBtnClick{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
  
    
    if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].describe]) {
        [self showHint:@"职位描叙不能为空"];
        return;
    }
    
    if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].ageMin] || [ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].ageMax]) {
        [self showHint:@"年龄不能为空"];
        return;
    }else{
        
        CGFloat agemin = [[JianZhiModel shareInstance].ageMin floatValue];
        CGFloat agemax =  [[JianZhiModel shareInstance].ageMax floatValue];
        
        if (agemin>agemax) {
            [self showHint:@"最小年龄不能大于最大年龄"];
            return ;
        }
    }
    
    
    
    if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].heightMax] || [ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].heightMin]) {
        [self showHint:@"身高不能为空"];
        return;
    }else{
        
        CGFloat agemin = [[JianZhiModel shareInstance].heightMin floatValue];
        CGFloat agemax =  [[JianZhiModel shareInstance].heightMax floatValue];
        
        if (agemin>agemax) {
            [self showHint:@"最小身高不能大于最大身高"];
            return ;
        }
    }
    
    if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].sex]) {
//        [self showHint:@"请选择性别"];
//        return;
        [JianZhiModel shareInstance].sex = @"0";
    }
    
    if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].jobType]) {
//        [self showHint:@"请选择求职类型"];
//        return;
        [JianZhiModel shareInstance].jobType = @"0";
    }

    MJWeakSelf
    LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"发布" andDesc:@"确认发布" WithCancelBlock:^(LHKAlterView *alterView) {
        [alterView removeFromSuperview];
        
        
        
    } WithMakeSure:^(LHKAlterView *alterView) {
          
        /***************/
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        
        [XKNetworkManager POSTToUrlString:JianZhiTijiao parameters:[self returnDictionary] progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *reslut  = JSonDictionary;
            
            NSString *code = [NSString stringWithFormat:@"%@",reslut[@"errno"]];
            if ([code isEqualToString:@"0"] ) {
                
                
                                
                NSString *order = reslut[@"rst"][@"jobid"];
                
                
                //立即支付
                NSArray *VCS = weakSelf.containerVc.navigationController.childViewControllers;
                
                UIViewController *vc = nil;
                if (VCS.count == 2) {
                    vc = VCS[0];
                }else{
                    vc = VCS[1];
                }
                
              
                
                
                [weakSelf.containerVc.navigationController popToViewController:vc animated:NO];
                
                OrderPayVc *payVc = [OrderPayVc new];
                payVc.demanID = order;
                payVc.isZhaoPin = YES;
                
                
                [vc.navigationController pushViewController:payVc animated:YES];
                
              

                [[JianZhiModel shareInstance] cleanData];
                
                
                
            }else{
                [weakSelf showHint:@"服务器返回错误"];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf showHint:error.localizedDescription];
            
        }];
        

        
        
        /**************/
        
        
        
        [alterView removeFromSuperview];

    }];
    [[UIApplication sharedApplication].keyWindow addSubview:alt];


    
    
    
}


-(NSMutableDictionary *)returnDictionary{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"memberid"] = model.userID;
    parm[@"title"] = [JianZhiModel shareInstance].title;
    parm[@"salary"] = [JianZhiModel shareInstance].salary;
    parm[@"unit"] = [JianZhiModel shareInstance].unit;
    parm[@"settlement"] = [JianZhiModel shareInstance].settlement;
    parm[@"person_number"] = [JianZhiModel shareInstance].person_number;
    parm[@"start_date"] = [JianZhiModel shareInstance].start_date;
    parm[@"end_date"] = [JianZhiModel shareInstance].end_date;
    parm[@"contact"] = [JianZhiModel shareInstance].contact;
    parm[@"phone"] = [JianZhiModel shareInstance].phone;
    parm[@"email"] =[JianZhiModel shareInstance].email;
    parm[@"province"] =[JianZhiModel shareInstance].province;
    parm[@"city"] =[JianZhiModel shareInstance].city;
    parm[@"area"] =[JianZhiModel shareInstance].area;
    parm[@"address"] =[JianZhiModel shareInstance].address;
    parm[@"describe"] = [JianZhiModel shareInstance].describe;
    parm[@"ageMin"] = [JianZhiModel shareInstance].ageMin;
    parm[@"ageMax"] = [JianZhiModel shareInstance].ageMax;
    parm[@"heightMin"] = [JianZhiModel shareInstance].heightMin;
    parm[@"heightMax"] = [JianZhiModel shareInstance].heightMax;
    parm[@"sex"] = [JianZhiModel shareInstance].sex;
    parm[@"jobType"] = [JianZhiModel shareInstance].jobType;
    if (self.ismodfiy) {
        parm[@"id"] =  self.detailmodel.jobid;
    }
    
    
    return parm;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.detailmodel == nil || self.ismodfiy) {
        self.makeSureBtn.hidden = NO;
        if (self.ismodfiy) {
            [self.makeSureBtn setTitle:@"重新发布" forState:UIControlStateNormal];
        }
    }else{
        self.makeSureBtn.hidden = YES;
    }
     self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
    [self.view addSubview:self.makeSureBtn];
    
    
}
-(TPKeyboardAvoidingTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-HRadio(150)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiSecondupCell" bundle:nil] forCellReuseIdentifier:@"JianZhiSecondupCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiSecondDownCell" bundle:nil] forCellReuseIdentifier:@"JianZhiSecondDownCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
   
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HRadio(163);
    }
    return HRadio(44);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 7.5, 15, 15)];
    [view addSubview:titleImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame)+5, 0, 100, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGBString(@"0x343434");
    [view addSubview:label];
    
    UIView *linView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, ScreenWidth, 1)];
    linView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
    [view addSubview:linView];
    
    if (section == 0) {
        
        titleImageView.image = [UIImage imageNamed:@"gongzuomiaoshu-up"];
        label.text = @"职位描述";
        
    }else{
        
        titleImageView.image = [UIImage imageNamed:@"renyuanyaoqiu-down"];
        label.text = @"人员要求";
    }
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf
    if (indexPath.section == 0) {
        JianZhiSecondupCell *upcell = [tableView dequeueReusableCellWithIdentifier:@"JianZhiSecondupCell"];
        
        if (self.detailmodel == nil || self.ismodfiy) {
            if (self.ismodfiy) {
                upcell.textView.text = self.detailmodel.describe;
                
                
            }
            upcell.texviewblock = ^(NSString *str) {
                
                [JianZhiModel shareInstance].describe = str;
                
            };
        }else{
            upcell.textView.text = self.detailmodel.describe;
            upcell.textView.editable = NO;
        }
        
        
        
        return upcell;
    }
    
    JianZhiSecondDownCell *downCell = [tableView dequeueReusableCellWithIdentifier:@"JianZhiSecondDownCell"];
    
    if (indexPath.row == 0) {
        downCell.panView.hidden = NO;
        downCell.ageLabel.hidden = NO;
        downCell.listBtn.hidden = YES;
        
        downCell.TitleLabel.text = @"年龄";
        downCell.ageLabel.text = @"岁";
        
        if (self.detailmodel == nil || self.ismodfiy) {
            
            if (self.ismodfiy) {
                downCell.textField1.text = self.detailmodel.ageMin;
                downCell.TextField2.text = self.detailmodel.ageMax;
            }
            
            downCell.textfieldblock1 = ^(NSString *str) {
                [JianZhiModel shareInstance].ageMin = str;
            };
            downCell.textfieldblock2 = ^(NSString *str) {
                [JianZhiModel shareInstance].ageMax =  str;
            };
        }else{
            downCell.textField1.text = self.detailmodel.ageMin;
            downCell.TextField2.text = self.detailmodel.ageMax;
            downCell.textField1.enabled = NO;
            downCell.TextField2.enabled = NO;
        }
       
        
        
    }else if (indexPath.row == 1){
        downCell.panView.hidden = NO;
        downCell.ageLabel.hidden = NO;
        downCell.listBtn.hidden = YES;
        
        downCell.TitleLabel.text = @"身高";
        downCell.ageLabel.text = @"cm";
        
        if (self.detailmodel == nil || self.ismodfiy ) {
            downCell.textfieldblock1 = ^(NSString *str) {
                [JianZhiModel shareInstance].heightMin = str;
                
            };
            downCell.textfieldblock2 = ^(NSString *str) {
                [JianZhiModel shareInstance].heightMax = str;
            };
            
            if (self.ismodfiy) {
                downCell.textField1.text = self.detailmodel.heightMin;
                downCell.TextField2.text = self.detailmodel.heightMax;
            }
        }else{
            downCell.textField1.text = self.detailmodel.heightMin;
            downCell.TextField2.text = self.detailmodel.heightMax;
            downCell.textField1.enabled = NO;
            downCell.TextField2.enabled = NO;
        }
      
        
        
    }else if (indexPath.row == 2){
        downCell.panView.hidden = YES;
        downCell.ageLabel.hidden = YES;
        downCell.listBtn.hidden = NO;
        
        downCell.TitleLabel.text = @"性别";
        
        if (self.detailmodel == nil || self.ismodfiy) {
            [downCell.listBtn setTitle:@"不限" forState:UIControlStateNormal];
            
            if (self.ismodfiy) {
                [downCell.listBtn setTitle:[NSString sexWithSheHe:[self.detailmodel.sex integerValue]] forState:UIControlStateNormal];
            }
            
            downCell.sexblock = ^(UIButton *btn) {
                
                CGRect rect = [downCell convertRect:downCell.listBtn.frame toView:weakSelf.tableView];
                
                NSArray *datas = @[@"不限",@"男",@"女"];
                
                weakSelf.listView = [[JianZhiFistListView alloc]initWithRect:rect andDatas:datas];
                [weakSelf.view addSubview:weakSelf.listView];
                
                weakSelf.listView.listreturnblock = ^(NSString *str,NSInteger index) {
                    [btn setTitle:str forState:UIControlStateNormal];
                    [JianZhiModel shareInstance].sex = [NSString stringWithFormat:@"%ld",index];
                };
                
                
            };
  
        }else{
            
              [downCell.listBtn setTitle:[NSString sexWithSheHe:[self.detailmodel.sex integerValue]] forState:UIControlStateNormal];
            downCell.listBtn.userInteractionEnabled = NO;
            
        }
       
        
    }else{
        downCell.panView.hidden = YES;
        downCell.ageLabel.hidden = YES;
        downCell.listBtn.hidden = NO;
        
        downCell.TitleLabel.text = @"求职类型";
        
        if (self.detailmodel == nil || self.ismodfiy ) {
            [downCell.listBtn setTitle:@"不限" forState:UIControlStateNormal];
            if (self.ismodfiy) {
                [downCell.listBtn setTitle:[NSString jobTypeWithType:[self.detailmodel.jobType integerValue]] forState:UIControlStateNormal];
            }
            
            downCell.sexblock = ^(UIButton *btn) {
                
                CGRect rect = [downCell convertRect:downCell.listBtn.frame toView:weakSelf.tableView];
                
                NSArray *datas = @[@"不限",@"全职",@"兼职",@"校园兼职"];
                
                weakSelf.listView = [[JianZhiFistListView alloc]initWithRect:rect andDatas:datas];
                [weakSelf.view addSubview:weakSelf.listView];
                
                weakSelf.listView.listreturnblock = ^(NSString *str,NSInteger index) {
                    [btn setTitle:str forState:UIControlStateNormal];
                    
                    [JianZhiModel shareInstance].jobType = [NSString stringWithFormat:@"%ld",index];
                };
                
                
            };
  
        }else{
            downCell.listBtn.userInteractionEnabled = NO;
            [downCell.listBtn setTitle:[NSString jobTypeWithType:[self.detailmodel.jobType integerValue]] forState:UIControlStateNormal];
        }
        
    }
    downCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return downCell;
}

@end
