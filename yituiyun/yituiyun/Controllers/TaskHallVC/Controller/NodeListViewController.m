//
//  NodeListViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/2/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NodeListViewController.h"
#import "TaskNodeModel.h"
#import "ProjectModel.h"
#import "UploadDetailViewController.h"
#import "SignInViewController.h"
#import "UploadViewController.h"
#import "TaskNodeCell.h"
#import "NodeError.h"
#import "NodeStatusDetailVC.h"

@interface NodeListViewController ()<UITableViewDataSource,UITableViewDelegate,TaskNodeCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) ProjectModel *model;


@end

@implementation NodeListViewController
- (instancetype)initWith:(NSInteger)where WithProjectModel:(ProjectModel *)model
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
        self.model = model;
        self.page = @"1";
        self.isremo = YES;
        self.where = where;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isremo = YES;
    self.page = @"1";
    [self nodeListDataArray];
}

- (void)nodeListDataArray
{
    __weak NodeListViewController *weakSelf = self;
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _model.projectId;
    params[@"memberid"] = infoModel.userID;
    params[@"pagesize"] = @"15";
    params[@"page"] = _page;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.node"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            
            
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    TaskNodeModel *model = [[TaskNodeModel alloc] init];
                    model.taskId = _model.projectId;
                    model.taskName = _model.projectName;
                    model.nodeName = [NSString stringWithFormat:@"%@", subDic[@"address"]];
                    model.nodeId = [NSString stringWithFormat:@"%@", subDic[@"nodeid"]];
                    model.nodeState = [NSString stringWithFormat:@"%@", subDic[@"status"]];
                    model.state = _model.type;
                    model.signInAddress = [NSString stringWithFormat:@"%@", subDic[@"address"]];
                    [listDataArray addObject:model];
                    
                    model.inputtime = [NSString stringWithFormat:@"%@",subDic[@"inputtime"]];
                    model.audit_list = [NSMutableArray array];
                    [model.audit_list removeAllObjects];
                    if (![ZQ_CommonTool isEmptyArray:subDic[@"audit_list"]]) {
                        
                        
                        NSArray *tempArray =  subDic[@"audit_list"];
                       
                        for (int i = 0; i<tempArray.count; i++) {
                            
                            
                            NSDictionary *dictdict = tempArray[i];
                            SubTaskModel *subtask = [[SubTaskModel alloc]init];
                            subtask.remark = [NSString stringWithFormat:@"%@",dictdict[@"remark"]];
                            subtask.add_time = [NSString stringWithFormat:@"%@",dictdict[@"add_time"]];
                           
                            subtask.title = [NSString stringWithFormat:@"%@",dictdict[@"title"]];
                            [model.audit_list addObject:subtask];
                        }
                       
                        
                    }
                    
                    
                }
            }
            
            
            [weakSelf configuration:listDataArray];
            
            
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}
- (void)configuration:(NSArray *)array
{
    if (_isremo == YES) {
        if ([_dataArray count] != 0) {
            [_dataArray removeAllObjects];
        }
    }
    if (![ZQ_CommonTool isEmptyArray:array]) {
        [_dataArray addObjectsFromArray:array];
        
    
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    backview.backgroundColor =UIColorFromRGBString(@"0xededed");
    [self.view addSubview:backview];
    
    [self setupNav];
    [self setupTableView];
    [self setupRefresh];
}

- (void)setupNav{
    self.title = @"节点";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 64-10) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - 添加刷新
- (void)setupRefresh{
    [_tableView setHeadRefreshWithTarget:self withAction:@selector(loadNewStatus)];
    [_tableView setFootRefreshWithTarget:self withAction:@selector(loadMoreStatus)];
}

#pragma mark 下拉刷新
- (void)loadNewStatus
{
    self.isremo = YES;
    self.page = @"1";
    [_tableView endRefreshing];
    [self nodeListDataArray];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    [self nodeListDataArray];
    
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55+35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf
    TaskNodeCell *cell = [TaskNodeCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    TaskNodeModel *model = _dataArray[indexPath.section];
    cell.iconView.image = [UIImage imageNamed:@"oldNode"];
    cell.nameLabel.textColor = kUIColorFromRGB(0x404040);
    cell.backgroundColor = kUIColorFromRGB(0xffffff);
    cell.nameLabel.text = model.nodeName;
    cell.tagLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.tagLabel.layer.borderWidth = 1;
    cell.tagLabel.layer.cornerRadius = 3;
    cell.tagLabel.clipsToBounds = YES;
    NSString *timestr = [NSString timeHasSecondTimeIntervalString:model.inputtime];
    cell.timeLabel.text = [NSString stringWithFormat:@"签到时间:%@",timestr];
    SubTaskModel *s_model = [model.audit_list lastObject];
    cell.statusLabel.text =s_model.remark;
    cell.statusBtn.hidden = NO;
    
    if ([model.nodeState isEqualToString:@"0"]) {
        cell.checkInButton.hidden = YES;
        cell.uploadButton.hidden = NO;
        cell.tagLabel.hidden = YES;
        cell.statusLabel.text = @"请上传凭证";
        cell.statusBtn.hidden = YES;
        
    } else {
        cell.checkInButton.hidden = YES;
        cell.uploadButton.hidden = YES;
        if ([model.nodeState isEqualToString:@"1"]) {
            cell.tagLabel.hidden = NO;
            cell.tagLabel.text = @"已审核";
            cell.tagLabel.textColor = [UIColor lightGrayColor];
        } else if ([model.nodeState isEqualToString:@"2"]) {
            cell.tagLabel.hidden = NO;
            cell.tagLabel.text = @"已失效";
            cell.tagLabel.textColor = [UIColor lightGrayColor];
            cell.statusBtn.hidden = YES;
            cell.statusLabel.text = @"该凭证已失效，请重新签到添加";
        } else if ([model.nodeState isEqualToString:@"3"]) {
            cell.tagLabel.hidden = NO;
            cell.tagLabel.text = @"审核中";
            cell.tagLabel.textColor = [UIColor redColor];
            cell.tagLabel.layer.borderColor = [UIColor redColor].CGColor;

        }else if ([model.nodeState isEqualToString:@"4"]) {
            cell.tagLabel.hidden = NO;
            cell.tagLabel.text = @"审核失败";
            cell.statusLabel.text = s_model.title;
            cell.tagLabel.textColor = [UIColor lightGrayColor];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //添加查看详情
    cell.detialblock = ^{
        NodeStatusDetailVC *detailvc = [[NodeStatusDetailVC alloc]init];
        
        detailvc.datas = model.audit_list;
        detailvc.modalPresentationStyle=UIModalPresentationCustom;
        [weakSelf presentViewController:detailvc animated:YES completion:nil];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (![ZQ_CommonTool isEmptyArray:_dataArray]) {
                    if (indexPath.row == 0) {
                        TaskNodeModel *model = _dataArray[indexPath.section];
                        model.state = _model.type;
                        
//                        NSLog(@"-------%@",model.nodeState);
                        if (! [model.nodeState isEqualToString:@"0"] ) {
                            
                            
                        UploadDetailViewController *vc = [[UploadDetailViewController alloc] initWithTaskNodeModel:model WithDataArray:_model.positionArray WithWhere:2];
                        pushToControllerWithAnimated(vc)
                        
                           
   }
                    }else{
                         //点击的上传
//                        NSLog(@"------点击的上传");
                    }
            }

    
    [self.view endEditing:YES];
}

#pragma mark - TaskNodeCellDelegate
- (void)checkInButtonClickWithIndex:(NSIndexPath *)indexPath//签到
{
    if ([_model.type isEqualToString:@"1"]) {
        if ([_model.payType integerValue] == 1) {
            SignInViewController *vc = [[SignInViewController alloc] initWithProjectModel:_model];
            pushToControllerWithAnimated(vc)
        } else {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"每天最多只可以签到2次，请问是否在规定的时间内签到？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     SignInViewController *vc = [[SignInViewController alloc] initWithProjectModel:_model];
                     pushToControllerWithAnimated(vc)
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
    } else {
        [ZQ_UIAlertView showMessage:@"此任务不能签到" cancelTitle:@"确定"];
    }
}

- (void)uploadButtonClickWithIndex:(NSIndexPath *)indexPath//上传
{
    if ([_model.type isEqualToString:@"1"]) {
        TaskNodeModel *model = _dataArray[indexPath.section];
        UploadViewController *vc = [[UploadViewController alloc] initWithTaskNodeModel:model WithWhere:1];
        [vc.textArray addObjectsFromArray:_model.textArray];
        [vc.imageArray addObjectsFromArray:_model.imgsArray];
        pushToControllerWithAnimated(vc)
    } else {
        [ZQ_UIAlertView showMessage:@"此任务不能上传资料" cancelTitle:@"确定"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
