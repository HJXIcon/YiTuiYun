//
//  JianZhiShenHeVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiShenHeVC.h"
#import "LHKTaskHallCell.h"
#import "TaskHallModel.h"


@interface JianZhiShenHeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation JianZhiShenHeVC
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray= [NSMutableArray array];
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


- (UITableView *)tableView{
    MJWeakSelf
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"LHKTaskHallCell" bundle:nil] forCellReuseIdentifier:@"TaskHallCell"];
        
        _tableView.tableFooterView = [UIView new];
        
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHKTaskHallCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TaskHallCell"];
    [cell.tingzhiBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [cell.addBtn setTitle:@"录取" forState:UIControlStateNormal];
    cell.shengyubaozhengjinLabel.hidden = NO;
    JiZhiSheHeListModel *model = self.dataArray[indexPath.section];
    cell.jianzhishenhemodel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeImageView.hidden = YES;
    cell.subImageView.hidden = YES;
    cell.twoImageView.hidden = YES;
    cell.leftcontstant.constant = -10;
   
    MJWeakSelf
    cell.tingzhiblock = ^{
       
        
        LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"是否拒绝申请" WithCancelBlock:^(LHKAlterView *alterView) {
            
            [alterView removeFromSuperview];
            
        } WithMakeSure:^(LHKAlterView *alterView) {
            [alterView removeFromSuperview];
            //操作
            [weakSelf handleJianZhiRefuseOrPass:2 andapplyID:model.applyid];
            

        }];
        [[UIApplication sharedApplication].keyWindow addSubview:alt];
    };
    
    cell.addblock = ^{
        LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"是否录取" WithCancelBlock:^(LHKAlterView *alterView) {
            
            [alterView removeFromSuperview];
            
        } WithMakeSure:^(LHKAlterView *alterView) {
           [alterView removeFromSuperview];
            //操作
             [weakSelf handleJianZhiRefuseOrPass:1 andapplyID:model.applyid];
            
            
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:alt];    };
    
    return cell;
}
-(void)handleJianZhiRefuseOrPass:(NSInteger)type andapplyID:(NSString *)appid{
   MJWeakSelf
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"applyid"] = appid;
    parm[@"memberid"] = userinfo.userID;
    parm[@"t"] = @(type);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [XKNetworkManager POSTToUrlString:JianZhiHandleRefuseOrPass parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf showHint:@"操作成功"];
            
            [weakSelf.tableView.mj_header beginRefreshing];
            
        }else{
            [weakSelf showHint:@"操作失败"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ScreenWidth<375) {
        return HRadio(140);
    }
    return 135;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headView.backgroundColor = UIColorFromRGBString(@"0xededed");
    return headView;
}


-(void)getDataFromServer{
    
    MJWeakSelf
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = usermodel.userID;
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @(10);
    
    [XKNetworkManager POSTToUrlString:JianZhiSheHeList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        
        if ([code isEqualToString:@"0"] ) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            /**********/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [JiZhiSheHeListModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [JiZhiSheHeListModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [JiZhiSheHeListModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [JiZhiSheHeListModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            
            /***********/
            [weakSelf.tableView reloadData];
            
            
            
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showHint:@"服务器数据出错"];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showHint:error.localizedDescription];
        
    }];
}

@end
