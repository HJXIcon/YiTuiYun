//
//  HomeMiddleLabelVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/6.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "HomeMiddleLabelVc.h"
#import "ProjectDetailViewController.h"

@interface HomeMiddleLabelVc ()<UITableViewDelegate,UITableViewDelegate>
/**<#type#> */
@property(nonatomic,strong) NSMutableArray * dataArray;
/**<#type#> */
@property(nonatomic,strong) UITableView * tableView;
/**<#type#> */
@property(nonatomic,assign)NSInteger  page;

@end

@implementation HomeMiddleLabelVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor =kUIColorFromRGB(0xf1f1f1);
    
    NSString *title = [NSString stringWithFormat:@"%@",self.dict[@"name"]];
    NSString *linkid = [NSString stringWithFormat:@"%@",self.dict[@"linkageid"]];
    
    self.navigationItem.title = title;
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    
    


}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - 收索数据
-(UITableView *)tableView{
    MJWeakSelf
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homecell"];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);

        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf dataArrayFromNetwor];
        }];
        //上拉加载
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf dataArrayFromNetwor];
            
        }];
    }
    return _tableView;
}

#pragma mark - 发送查找请求
- (void)dataArrayFromNetwor{
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"t"] = @"1";
    params[@"status"] = @"6";
    params[@"provid"] = dic[@"provinceId"];
    params[@"cityid"] = dic[@"cityId"];
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(10);
    params[@"type"] = self.dict[@"linkageid"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString * app_Version = infoDictionary[@"CFBundleShortVersionString"] ;
    
    
    params[@"version"] = app_Version;
    
    params[@"from"] = @"ios";

    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"] integerValue] == 0) {
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            
            /******************/
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempdownArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                
                if (tempdownArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempdownArray];
                    
                }
                
                
            }
            
            /******************/
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        self.page --;
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"homecell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    homeTableModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    
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

    homeTableModel *projectModel = self.dataArray[indexPath.row];
    
        ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:projectModel.demandid WithType:userInfoModel.identity WithWhere:1];
        pushToControllerWithAnimated(vc)
    

}

@end
