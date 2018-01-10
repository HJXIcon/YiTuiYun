//
//  JXPunchClockListViewController.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPunchClockListViewController.h"
#import "JXPunchClockListCell.h"
#import "JXPunchClockListModel.h"
#import "JXPunchClockViewController.h"
#import "NodeStatusDetailVC.h"
#import "YYModel.h"

@interface JXPunchClockListViewController ()
/** 当前页码 */
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray <JXPunchClockListModel *>*dataArray;
@end

@implementation JXPunchClockListViewController

#pragma mark - lazy load
- (NSMutableArray<JXPunchClockListModel *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public Method
- (void)reloadNodeListDataArray{
    _page = 1;
    [self loadNodeListDataArray];
}

#pragma mark - load Data

- (void)loadNodeListDataArray
{
    MJWeakSelf;
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = infoModel.userID;
    params[@"job_id"] = self.job_id;
    params[@"type"] = @"1";// 0：任务的节点，1：打卡节点
    params[@"pagesize"] = @"15";
    params[@"page"] = @(_page);
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, API_Node];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf loadDataSuccess];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            
            if (weakSelf.page == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            weakSelf.page ++;
            
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
               
                NSArray *tmpArray =  [NSArray yy_modelArrayWithClass:[JXPunchClockListModel class] json:listData];
                [weakSelf.dataArray addObjectsFromArray:tmpArray];
                
            }else{
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            
        } else {
            if (weakSelf.page != 1) {
                weakSelf.page = weakSelf.page - 1;
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf loadDataSuccess];
        if (weakSelf.page != 1) {
            weakSelf.page = weakSelf.page - 1;
        }
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

#pragma mark - Actions
- (void)loadHeaderAction{
    [self loadNodeListDataArray];
}

- (void)loadFooterAction{
    [self loadNodeListDataArray];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dataArray.count) {
        self.nodataImageView.hidden = YES;
    }else{
        self.nodataImageView.hidden = NO;
    }
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    JXPunchClockListCell *cell = [JXPunchClockListCell cellForTableView:tableView];
    
    JXPunchClockListModel *model = self.dataArray[indexPath.section];
    
    cell.seeProgressBlock = ^{
        NodeStatusDetailVC *detailvc = [[NodeStatusDetailVC alloc]init];
        detailvc.datas = model.audit_list;
        detailvc.modalPresentationStyle=UIModalPresentationCustom;
        [weakSelf presentViewController:detailvc animated:YES completion:nil];
    };
    
    cell.model = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MJWeakSelf;
    JXPunchClockViewController *vc = [[JXPunchClockViewController alloc]init];

    JXPunchClockListModel *model = self.dataArray[indexPath.section];
    vc.node_id = model.nodeid;
    vc.job_id = self.job_id;
    vc.punchClockSuccessBlock = ^{
        weakSelf.page = 1;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark header/footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}



@end
