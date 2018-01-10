//
//  BillHistroyListVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/24.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BillHistroyListVC.h"
#import "BillHistroyListCell.h"
#import "BillHistroryDetailVc.h"

@interface BillHistroyListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger  page;
@end

@implementation BillHistroyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
      [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    
//    [self getDataFromServer];
}

-(void)getDataFromServer{
    MJWeakSelf
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = usermodel.userID;
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @(10);
    
    
    [XKNetworkManager POSTToUrlString:HistryFaPiaoList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *resultDict = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            if (weakSelf.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [HistroyFapiaoListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [HistroyFapiaoListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [HistroyFapiaoListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];}
                
 
            }else{
                /*******/
                
                //上拉的时候
                
                NSArray *tempArray = [HistroyFapiaoListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                /*****/
            }
            
            
            
            
           
            [weakSelf.tableView reloadData];
            
            
            
            
            
            
        }else{
            [weakSelf showHint:@"数据异常"];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf showHint:error.localizedDescription];
    }];
    
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(UITableView *)tableView{
    MJWeakSelf
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BillHistroyListCell" bundle:nil] forCellReuseIdentifier:@"BillHistroyListCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page =1;
            
            [weakSelf getDataFromServer];
            
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            
             [weakSelf getDataFromServer];
        }];
        

    }
    return _tableView;
}


#pragma mark -- tableView 代理和数据源方法



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HRadio(10);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HRadio(10))];
    view.backgroundColor = UIColorFromRGBString(@"0xededed");
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(154);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillHistroyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillHistroyListCell"];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    
    HistroyFapiaoListModel *model = self.dataArray[indexPath.section];
    
    cell.nameLabel.text = model.primary_name;
    cell.moneyLabel.text = model.total_price;
    cell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model.inputtime];
    
    if ([model.type isEqualToString:@"1"]) {
        cell.typeLabel.text = @"专票";
    }else{
        cell.typeLabel.text = @"普票";
    }
    
    
    NSInteger statusIn = [model.status integerValue];
    
    switch (statusIn) {
        case 0:
            cell.statusLabel.text = @"(待开票)";
            break;
        case 1:
            cell.statusLabel.text = @"(已开票)";
            break;
        case 2:
            cell.statusLabel.text = @"(开票失败)";
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HistroyFapiaoListModel *model = self.dataArray[indexPath.section];
    
    
    BillHistroryDetailVc *detailVc = [[BillHistroryDetailVc alloc]init];
    detailVc.navigationItem.title = @"开票详情";
    detailVc.applyID = model.applyid;
    detailVc.fapiaoType = model.type;
    pushToControllerWithAnimated(detailVc)
}

@end
