//
//  BillHistroryDetailVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/24.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BillHistroryDetailVc.h"
#import "BillSectionFootOrHeadView.h"
#import "BillProNormalTableViewCell.h"
#import "HistoryFaPiaoDetailModel.h"
#import "YYModel.h"
#import "FaPiaoDetailVcListCell.h"


@interface BillHistroryDetailVc ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) BillSectionFootOrHeadView *footOrHeadView;
@property(nonatomic,strong) UIButton * makeSureBtn;
@property(nonatomic,strong) UIView * tableFootView;
@property(nonatomic,strong) HistoryFaPiaoDetailModel * detailmodel;

@end

@implementation BillHistroryDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailmodel = [[HistoryFaPiaoDetailModel alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
    

    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.tableFootView;
    [self getDataFromServer];
}


-(void)getDataFromServer{
    MJWeakSelf
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"applyid"] = self.applyID;
    parm[@"memberid"] = usermodel.userID;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [XKNetworkManager POSTToUrlString:HistryFapiaoListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *reslutDict = JSonDictionary;
        
        
        NSString *code = [NSString stringWithFormat:@"%@",reslutDict[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            weakSelf.detailmodel = [HistoryFaPiaoDetailModel yy_modelWithDictionary:reslutDict[@"rst"]];
            
            [weakSelf.tableView reloadData];
            
            
        }else{
            [weakSelf showHint:@"数据异常"];
        }
        
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
    
   
    
    
    
}
-(BillSectionFootOrHeadView *)footOrHeadView{
    if (_footOrHeadView == nil) {
        _footOrHeadView = [BillSectionFootOrHeadView footOrHeadView];
        _footOrHeadView.frame = CGRectMake(0, 0, ScreenWidth, 60);
    }
    return _footOrHeadView;
}



-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerNib:[UINib nibWithNibName:@"BillProNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BillProNormalTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"FaPiaoDetailVcListCell" bundle:nil] forCellReuseIdentifier:@"FaPiaoDetailVcListCell"];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.fapiaoType isEqualToString:@"1"]) {
            return 4;
        }
        return 2;
    }
   
    
    if (section == 1) {
        if ([ZQ_CommonTool isEmpty:self.detailmodel.company_name]) {
            return 0;
        }else{
            return 3;
        }
    }
    
    
    if (section == 2) {
        if ([ZQ_CommonTool isEmpty:self.detailmodel.person_name]) {
            return 0;
        }else{
            return 4;
        }
    }

    
    
    if (section == 3) {
        if ([ZQ_CommonTool isEmpty:self.detailmodel.alipay_name]) {
            return 0;
        }else{
            return 2;
        }
    }

    
    
    return self.detailmodel.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 4) {
        FaPiaoDetailVcListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"FaPiaoDetailVcListCell"];
        
        HistroyFapiaoDetailListModel *subModel  =   self.detailmodel.list[indexPath.row];
        
        cell1.tasknameLabel.text = subModel.projectName;
        cell1.moneyLabel.text = subModel.total_price;
        cell1.startTimeLabel.text = [NSString timeHasSecondTimeIntervalString:subModel.starttime];
        cell1.endTimeLabel.text = [NSString timeHasSecondTimeIntervalString:subModel.inputtime];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    
    MJWeakSelf
    BillProNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillProNormalTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.descTextField.enabled = NO;
    [self SetNmmeLabelDataToCell:cell andIndexPath:indexPath];
    
  
    return cell;
}


-(void)SetNmmeLabelDataToCell:(BillProNormalTableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"账号名称:";
            
            cell.descTextField.text = self.detailmodel.primary_name;
           
        }else if (indexPath.row == 1){
            
            cell.nameLabel.text = @"税  号:";
            
            cell.descTextField.text = self.detailmodel.tax_no;
            
        }else if (indexPath.row == 2){
            cell.nameLabel.text = @"账 号:";
           
            cell.descTextField.text = self.detailmodel.primary_cardcode;
            
        }else if (indexPath.row == 3){
            
            
            
            
            cell.nameLabel.text = @"开户行:";
            
            cell.descTextField.text = self.detailmodel.primary_bank_name;
            
            
        }
        
        
        /**********/
    }else if (indexPath.section == 1){
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"账号名称:";
           
            cell.descTextField.text = self.detailmodel.company_name;
            
        }else if (indexPath.row == 1){
            cell.nameLabel.text = @"账  号:";
           
            cell.descTextField.text = self.detailmodel.company_cardcode;
            
        }else if (indexPath.row == 2){
            cell.nameLabel.text = @"开户行地址:";
            
            cell.descTextField.text = self.detailmodel.company_bank_name;
            
        }
        /**********/
    }else if (indexPath.section == 2){
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"开户名称:";
            
            cell.descTextField.text = self.detailmodel.person_name;
            
        }else if (indexPath.row == 1){
            cell.nameLabel.text = @"账  号:";
            
            cell.descTextField.text = self.detailmodel.person_cardcode;
            
        }else if (indexPath.row == 2){
            cell.nameLabel.text = @"开户行地址:";
           
            cell.descTextField.text = self.detailmodel.person_bank_name;
            
        }else{
            cell.nameLabel.text = @"身份证号:";
            
            cell.descTextField.text = self.detailmodel.id_card;
            
        }
        /**********/
    }else if(indexPath.section == 3) {
        
        /***********/
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"支付宝名称:";
            
            cell.descTextField.text = self.detailmodel.alipay_name;
            
        }else {
            cell.nameLabel.text = @"账  号:";
            
            cell.descTextField.text = self.detailmodel.alipay_code;
           
        }
        /**********/
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
    
    
    if (indexPath.section == 4) {
        return HRadio(154);
    }
    
    return HRadio(44);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 0 ) {
        
        
        if ([ZQ_CommonTool isEmpty:self.detailmodel.company_name] && [ZQ_CommonTool isEmpty:self.detailmodel.person_name] && [ZQ_CommonTool isEmpty:self.detailmodel.alipay_name]){
            return 0.0001;
        }
        return HRadio(44);
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (section == 1) {
        if ([ZQ_CommonTool isEmpty:self.detailmodel.company_name]) {
            return 0.0001;
        }
    }
    
    
    if (section == 2) {
        if ([ZQ_CommonTool isEmpty:self.detailmodel.person_name]) {
            return 0.0001;
        }
    }
    
    
    
    if (section == 3) {
        if ([ZQ_CommonTool isEmpty:self.detailmodel.alipay_name]) {
            return 0.0001;
        }
    }
    

    
    return HRadio(44);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = YES;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = NO;
        
       view.middleLabel.text = @"关联账户";
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, HRadio(44)-1, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [view addSubview:lineView];
        
        
        
        
        if ([ZQ_CommonTool isEmpty:self.detailmodel.company_name] && [ZQ_CommonTool isEmpty:self.detailmodel.person_name] && [ZQ_CommonTool isEmpty:self.detailmodel.alipay_name]){
            
            view.hidden = YES;
        }else{
            view.hidden = NO;
        }
     
        
        
        
        
        
       
        
        
        
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
        view.middleLabel.text = @"主账户";
        return view;
    }else if (section == 1){
        
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = NO;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = YES;
        
        view.panoneLabel.text = @"1";
        view.panDesView.text = @"企业";
        
        if ([ZQ_CommonTool isEmpty:self.detailmodel.company_name]) {
            view.hidden = YES;
        }else{
            view.hidden = NO;
        }
        return view;
        
    }else if(section == 2){
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = NO;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = YES;
        
        view.panoneLabel.text = @"2";
        view.panDesView.text = @"个人";
        if ([ZQ_CommonTool isEmpty:self.detailmodel.person_name]) {
            view.hidden = YES;
        }else{
            view.hidden = NO;
        }
        
        return view;
        
    }else if(section == 3){
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = NO;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = YES;
        
        view.panoneLabel.text = @"3";
        view.panDesView.text = @"支付宝";
        
        if ([ZQ_CommonTool isEmpty:self.detailmodel.alipay_name]) {
            view.hidden = YES;
        }else{
            view.hidden = NO;
        }
        return view;
        
    }else{
        BillSectionFootOrHeadView *view = [BillSectionFootOrHeadView footOrHeadView];
        view.panView.hidden = YES;
        view.upLabel.hidden = YES;
        view.middleLabel.hidden = NO;
        view.middleLabel.font = [UIFont systemFontOfSize:FontRadio(15)];
        view.middleLabel.text = @"开票明细";
        return view;
    }
    return [UIView new];
    
}


@end
