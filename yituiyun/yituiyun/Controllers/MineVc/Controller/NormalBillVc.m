//
//  NormalBillVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NormalBillVc.h"
#import "BillSectionFootOrHeadView.h"
#import "BillProNormalTableViewCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "LastFaPiaoModel.h"

@interface NormalBillVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) BillSectionFootOrHeadView *footOrHeadView;
@property(nonatomic,strong) UIButton * makeSureBtn;
@property(nonatomic,strong) UIView * tableFootView;
@end

@implementation NormalBillVc

-(BillSectionFootOrHeadView *)footOrHeadView{
    if (_footOrHeadView == nil) {
        _footOrHeadView = [BillSectionFootOrHeadView footOrHeadView];
        _footOrHeadView.frame = CGRectMake(0, 0, ScreenWidth, 60);
    }
    return _footOrHeadView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[KaiFaPiaoModel alloc]init];
    self.model.main_totalMoney = self.totalmoney;
    self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
    
    UIView *tilteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HRadio(44))];
    tilteView.backgroundColor = [UIColor whiteColor];
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-15, HRadio(44))];
    titlelabel.text = @"开票以主账户信息为主,与关联账户无关,关联账户同属主账号";
    titlelabel.font = [UIFont systemFontOfSize:FontRadio(12)];
    [tilteView addSubview:titlelabel];
    [self.view addSubview:tilteView];
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.tableFooterView = self.tableFootView;
    
    [self getLastFaPiaoInfo:2];
    
    
}



-(void)getLastFaPiaoInfo:(NSInteger)type{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = usermodel.userID;
    parm[@"type"] = @(type);
    [XKNetworkManager POSTToUrlString:GetLastFapiaoRecord parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            LastFaPiaoModel *lastmodel = [LastFaPiaoModel objectWithKeyValues:resultDict[@"rst"]];
            
            weakSelf.model.main_acountName = lastmodel.primary_name;
            weakSelf.model.main_suihao = lastmodel.tax_no;
            weakSelf.model.main_pro_acount = lastmodel.primary_cardcode;
            weakSelf.model.main_pro_bankName = lastmodel.primary_bank_name;
            
            
            weakSelf.model.company_acountName = lastmodel.company_name;
            weakSelf.model.company_acount = lastmodel.company_cardcode;
            weakSelf.model.company_acountAddress = lastmodel.company_bank_name;
            
            
            weakSelf.model.person_acountName = lastmodel.person_name;
            weakSelf.model.person_acount = lastmodel.person_cardcode;
            weakSelf.model.person_acountAddress = lastmodel.person_bank_name;
            weakSelf.model.person_shengfenID = lastmodel.id_card;
            
            
            weakSelf.model.alipay_acountName = lastmodel.alipay_name;
            weakSelf.model.alipay_acount = lastmodel.alipay_code;
            
            [weakSelf.tableView reloadData];
            
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(UIView *)tableFootView{
    if (_tableFootView == nil) {
        _tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        
        UIButton *makeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 44)];
        makeSureBtn.layer.cornerRadius = 5;
        makeSureBtn.clipsToBounds = YES;
        [makeSureBtn setTitle:@"提交" forState:UIControlStateNormal];
        makeSureBtn.backgroundColor = UIColorFromRGBString(@"0xf16156");
        makeSureBtn.center = CGPointMake(ScreenWidth*0.5, 50);
        _makeSureBtn = makeSureBtn;
        [_tableFootView addSubview:makeSureBtn];
        [makeSureBtn addTarget:self action:@selector(makesureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFootView;
}
-(void)makesureBtnClick:(UIButton *)btn{
    
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    
    if ([ZQ_CommonTool isEmpty:self.model.main_acountName ]) {
        [self showHint:@"请输入主账号-账号名称"];
        return ;
    }
    
    if ([ZQ_CommonTool isEmpty:self.model.main_suihao ]) {
        [self showHint:@"请输入主账号-税号"];
        return ;
    }
    
    /******************************************************/
    
    
    
    BOOL companyallisNull = ([ZQ_CommonTool isEmpty:self.model.company_acountName] && [ZQ_CommonTool isEmpty:self.model.company_acount] && [ZQ_CommonTool isEmpty:self.model.company_acountAddress]);
    
    BOOL companyallisNotNull =(![ZQ_CommonTool isEmpty:self.model.company_acountName] && ![ZQ_CommonTool isEmpty:self.model.company_acount] && ![ZQ_CommonTool isEmpty:self.model.company_acountAddress]);
   
    
    
    if (companyallisNull || companyallisNotNull) {
        
    }else{
        [self showHint:@"请完善企业关联信息"];
        return ;
    }
    
    
    BOOL personallisNull = ([ZQ_CommonTool isEmpty:self.model.person_acountName] && [ZQ_CommonTool isEmpty:self.model.person_acount] && [ZQ_CommonTool isEmpty:self.model.person_acountAddress] && [ZQ_CommonTool isEmpty:self.model.person_shengfenID]);
    
    BOOL psersonallisNotNull =(![ZQ_CommonTool isEmpty:self.model.person_acountName] && ![ZQ_CommonTool isEmpty:self.model.person_acount] && ![ZQ_CommonTool isEmpty:self.model.person_acountAddress] && ![ZQ_CommonTool isEmpty:self.model.person_shengfenID]);

    
    
    if (personallisNull || psersonallisNotNull) {
        
    }else{
        [self showHint:@"请完善个人关联信息"];
        return ;
    }
    
    BOOL alipayisNull = ([ZQ_CommonTool isEmpty:self.model.alipay_acountName] && [ZQ_CommonTool isEmpty:self.model.alipay_acount]);
    BOOL alipayisNotNull = (![ZQ_CommonTool isEmpty:self.model.person_acountName] &&![ZQ_CommonTool isEmpty:self.model.alipay_acount]);
    
    if (alipayisNull || alipayisNotNull) {
        
    }else{
        [self showHint:@"请完善支付宝关联信息"];
        return ;
    }
    
    
    MJWeakSelf
    /****************************************************/
    
    
    
    NSMutableDictionary *parm = [self getParm];
    
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    
    [XKNetworkManager POSTToUrlString:SubmitFaPiao parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *result = JSonDictionary;
        
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            if (weakSelf.callback) {
                weakSelf.callback();
            }
            [weakSelf showHint:@"操作成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf showHint:@"开票失败"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    

    
}




-(NSMutableDictionary *)getParm{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    parm[@"memberid"] = usermodel.userID;
    parm[@"account_id"] = self.acount_id;
    parm[@"type"] = @(2);
    parm[@"primary_name"] = self.model.main_acountName;
    parm[@"tax_no"] = self.model.main_suihao;
    
    
    parm[@"company_name"] = self.model.company_acountName;
    parm[@"company_cardcode"] = self.model.company_acount;
    parm[@"company_bank_name"] = self.model.company_acountAddress ;
    
    
    parm[@"person_name"] = self.model.person_acountName;
    parm[@"person_cardcode"] = self.model.person_acount;
    parm[@"person_bank_name"] = self.model.person_acountAddress;
    parm[@"id_card"] = self.model.person_shengfenID;
    
    parm[@"alipay_name"] = self.model.alipay_acountName;
    parm[@"alipay_code"] = self.model.alipay_acount;
    
    
    return parm;
    
    
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, HRadio(44), ScreenWidth, self.view.frame.size.height-HRadio(44)-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerNib:[UINib nibWithNibName:@"BillProNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BillProNormalTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return 3;
    
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 4;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf
    BillProNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillProNormalTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self SetNmmeLabelDataToCell:cell andIndexPath:indexPath];
    
    
    cell.textfieldblock = ^(NSString *string) {
        //        NSLog(@"---------%ld-----%ld------%@",indexPath.section,indexPath.row,string);
        
        [weakSelf setDescLabelDataWith:string andIndexPath:indexPath];
        
        
        
    };
    return cell;
}

-(void)setDescLabelDataWith:(NSString *)str andIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.section == 0) {
        /***********/
        if (indexPath.row == 0) {
            self.model.main_acountName = str;
            
        }else if (indexPath.row == 1){
            
            
            self.model.main_suihao = str;
            
            
        }else{
            //开票金额
        }
        
        
        /**********/
    }else if (indexPath.section == 1){
        /***********/
        if (indexPath.row == 0) {
            self.model.company_acountName = str;
            
        }else if (indexPath.row == 1){
            self.model.company_acount = str;
            
        }else if (indexPath.row == 2){
            self.model.company_acountAddress = str;
            
        }
        /**********/
    }else if (indexPath.section == 2){
        /***********/
        if (indexPath.row == 0) {
            self.model.person_acountName = str;
            
        }else if (indexPath.row == 1){
            self.model.person_acount = str;
            
        }else if (indexPath.row == 2){
            self.model.person_acountAddress = str;
            
        }else{
            self.model.person_shengfenID = str;
            
        }
        /**********/
    }else {
        
        /***********/
        if (indexPath.row == 0) {
            self.model.alipay_acountName = str;
            
        }else {
            self.model.alipay_acount = str;
            
        }
        /**********/
    }
    
}


-(void)SetNmmeLabelDataToCell:(BillProNormalTableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"账号名称:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.main_acountName;
            cell.descTextField.placeholder = @"请输入账号名称";
        }else if (indexPath.row == 1){
            
            
            cell.nameLabel.text = @"税  号:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.main_suihao;
            cell.descTextField.placeholder = @"请输入税号";
            
        }else{
            cell.nameLabel.text = @"开票金额:";
            cell.descTextField.enabled = NO;
            cell.descTextField.text = self.model.main_totalMoney;
        }
        
        
        /**********/
    }else if (indexPath.section == 1){
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"账号名称:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.company_acountName;
            cell.descTextField.placeholder = @"请输入账号名称";
        }else if (indexPath.row == 1){
            cell.nameLabel.text = @"账  号:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.company_acount;
            cell.descTextField.placeholder = @"请输入账号";
        }else if (indexPath.row == 2){
            cell.nameLabel.text = @"开户行地址:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.company_acountAddress;
            cell.descTextField.placeholder = @"请输入开户行地址";
        }
        /**********/
    }else if (indexPath.section == 2){
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"开户名称:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.person_acountName;
            cell.descTextField.placeholder = @"请输入开户名称";
        }else if (indexPath.row == 1){
            cell.nameLabel.text = @"账  号:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.person_acount;
            cell.descTextField.placeholder = @"请输入账号";
        }else if (indexPath.row == 2){
            cell.nameLabel.text = @"开户行地址:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.person_acountAddress;
            cell.descTextField.placeholder = @"请输入开户行地址";
        }else{
            cell.nameLabel.text = @"身份证号:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.person_shengfenID;
            cell.descTextField.placeholder = @"请输入身份证号";
        }
        /**********/
    }else {
        
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"支付宝名称:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.alipay_acountName;
            cell.descTextField.placeholder = @"请输入支付宝名称";
        }else {
            cell.nameLabel.text = @"账  号:";
            cell.descTextField.enabled = YES;
            cell.descTextField.text = self.model.alipay_acount;
            cell.descTextField.placeholder = @"请输入账号";
        }
        /**********/
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(44);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 0 || section == 3) {
        return HRadio(44);
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HRadio(44);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = YES;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = NO;
        
        NSString *titlstr = @"关联账号(关联账号选填,可以修改)";
        view.middleLabel.text = titlstr;
        
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:titlstr];
        
        
        [attstr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, 4)];
        [attstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, titlstr.length-4)];
        
        
        view.middleLabel.attributedText = attstr;
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, HRadio(44)-1, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [view addSubview:lineView];
        return view;
    }else if (section == 3){
        
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = YES;
        view.upLabel.hidden = NO;
        view.middleLabel.hidden = YES;
        view.upLabel.text = @"确认无误后,请提交";
        return view;
        
    }
    return [UIView new];
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = YES;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = NO;
        view.middleLabel.text = @"主账号";
        return view;
    }else if (section == 1){
        
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = NO;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = YES;
        
        view.panoneLabel.text = @"1";
        view.panDesView.text = @"企业";
        return view;
        
    }else if(section == 2){
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = NO;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = YES;
        
        view.panoneLabel.text = @"2";
        view.panDesView.text = @"个人";
        return view;
        
    }else{
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = NO;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = YES;
        
        view.panoneLabel.text = @"3";
        view.panDesView.text = @"支付宝";
        return view;
        
    }
    return [UIView new];
    
}
-(void)dealloc{
    NSLog(@"----delloc--");
}

@end
