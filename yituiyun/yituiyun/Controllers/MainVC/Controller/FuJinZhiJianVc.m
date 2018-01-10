//
//  FuJinZhiJianVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "FuJinZhiJianVc.h"
#import "CompanyNeedListModel.h"
#import "HomeTableViewCell.h"
#import "TaskHallEnterpriseDetailJianZhiVC.h"

@interface FuJinZhiJianVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray * dataArray;

/**<#type#> */
@property(nonatomic,strong) UITableView * tableView;
/**<#type#> */
@property(nonatomic,assign)NSInteger  page;

@end

@implementation FuJinZhiJianVc

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    
}

-(UITableView *)tableView{
    MJWeakSelf
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homecell"];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        //        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf getJianZhiData];
        }];
        //上拉加载
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf getJianZhiData];
            
        }];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"homecell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    CompanyJianZhiModel *model = self.dataArray[indexPath.row];
    cell.fujinjianzhimodel = model;
    cell.titlepanView.hidden = YES;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    cell.oneImageView.image = [UIImage imageNamed:@"tubiao_1"];
    cell.twoImageView.image = [UIImage imageNamed:@"tubiao_2"];
    cell.threeImageView.hidden = YES;
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.dataArray.count == 0) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HRadio(141);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
    
    if ([userInfoModel.userID isEqualToString:@"0"]) {
        [ZQ_CallMethod againLogin];
        return;
    }
      CompanyJianZhiModel *model = self.dataArray[indexPath.row];
    [self zhaoPinSelect:model.jobid];
    
    
}
-(void)zhaoPinSelect:(NSString*)jobID{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userinfo.userID;
    parm[@"jobid"] = jobID;
    [XKNetworkManager POSTToUrlString:JianZhiCompanyListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resut = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resut[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            JianZhiModelDetail *model = [JianZhiModelDetail objectWithKeyValues:resut[@"rst"]];
            
            TaskHallEnterpriseDetailJianZhiVC *VC = [[TaskHallEnterpriseDetailJianZhiVC alloc]init];
            VC.title =model.title;
            VC.detailModel = model;
            [self.navigationController pushViewController:VC animated:YES];
            
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
}




- (void)getJianZhiData{
    MJWeakSelf
  
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @10;
    parm[@"status"] = @3;
    parm[@"city"] = self.city;
    parm[@"province"] = self.province;
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [XKNetworkManager POSTToUrlString:JianZhiCompanyList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        [SVProgressHUD dismiss];
        if ([code isEqualToString:@"0"] ) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            /**********/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            
            /***********/
            [weakSelf.tableView reloadData];
            
            
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showHint:@"服务器数据出错"];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showHint:error.localizedDescription];
    }];
}



@end
