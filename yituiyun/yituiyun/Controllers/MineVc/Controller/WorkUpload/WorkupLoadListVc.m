//
//  WorkupLoadListVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/30.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "WorkupLoadListVc.h"
#import "WorkuploadListCell.h"
#import "YYModel.h"
#import "NSString+LHKExtension.h"
#import "CompanyWorkDetail.h"
#import "TaskHallPersonHeadSelectView.h"
#import "LHKLeftButoon.h"
#import "JianZhiFistListView.h"
#import "JianZhiWorkDetailVC.h"


@interface WorkupLoadListVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,assign)NSInteger  page;
@property(nonatomic,strong) NSMutableArray * datas;
@property(nonatomic,assign)NSInteger  selectType;
@property(nonatomic,strong) TaskHallPersonHeadSelectView * selectHeadView;
@property(nonatomic,strong) LHKLeftButoon * rightChangeBtn;
@property(nonatomic,strong) JianZhiFistListView * listView;
@property(nonatomic,assign)NSInteger  rightType;
@end

@implementation WorkupLoadListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.selectType = 0;
    self.rightType = 0;
    [self.view addSubview:self.tableView];
    
    [self dataArrayFromNetwor];
    
    [self.view addSubview:self.selectHeadView];
    
   
    
    
    LHKLeftButoon *btn = [[LHKLeftButoon alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    //    btn.backgroundColor = [UIColor whiteColor];
    //    btn.layer.cornerRadius = 5;
    [btn setTitle:@"凭证列表" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"jianzhi_jiantao"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    btn.clipsToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(publishNeeds:) forControlEvents:UIControlEventTouchUpInside];
    self.rightChangeBtn = btn;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    
    
    UIBarButtonItem *rigtBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    negativeSpacer.width = -20;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rigtBtn,nil];
}



-(void)publishNeeds:(LHKLeftButoon *)btn{
    
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.listView];
    
    
    
}




-(JianZhiFistListView *)listView{
    if (_listView == nil) {
        MJWeakSelf
        CGRect rect = [self.rightChangeBtn.superview convertRect:self.rightChangeBtn.frame toView:[UIApplication sharedApplication].keyWindow];
        
        NSArray *datas = @[@"凭证列表",@"招聘列表"];
        
        _listView = [[JianZhiFistListView alloc]initWithRect:rect andDatas:datas];
        
        
        _listView.listreturnblock = ^(NSString *str,NSInteger index) {
            [weakSelf.rightChangeBtn setTitle:str forState:UIControlStateNormal];
            
                        if (self.rightType == index) {
            
            
            
                        }else{
                            //执行操作
            
                            [weakSelf.datas removeAllObjects];
                            [weakSelf.tableView reloadData];
                            weakSelf.rightType = index;
            
                            
                            [self.tableView.mj_header beginRefreshing];
                            weakSelf.rightType == 0?(self.navigationItem.title = @"凭着列表"): (self.navigationItem.title = @"招聘列表");
                            
                        }
            
        };
    }
    return _listView;
}


-(TaskHallPersonHeadSelectView *)selectHeadView{
    if (_selectHeadView == nil) {
        _selectHeadView = [TaskHallPersonHeadSelectView headSelectView];
        _selectHeadView.frame = CGRectMake(0, 0, ScreenWidth, 44);
        _selectHeadView.delegate = self;
        [_selectHeadView.taskBtn setTitle:@"待处理" forState:UIControlStateNormal];
        _selectHeadView.taskBtn.selected = YES;
        [_selectHeadView.historyTaskbtn setTitle:@"已处理" forState:UIControlStateNormal];
        
    }
    return _selectHeadView;
}
-(void)mytaskBtnToClick:(UIButton *)btn{
    
    [self.datas removeAllObjects];
    [self.tableView reloadData];
    self.selectType = 0;
    [self.tableView.mj_header beginRefreshing];
}
-(void)myhistorytaskBtnToClick:(UIButton *)btn{
    
    [self.datas removeAllObjects];
    [self.tableView reloadData];
    self.selectType = 1;
    [self.tableView.mj_header beginRefreshing];
}


-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.tableView) {
        [self.tableView.mj_header  beginRefreshing];
    }
    
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        MJWeakSelf
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, ScreenWidth, self.view.frame.size.height-54-20) style:UITableViewStylePlain];
        
 
        _tableView.delegate = self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"WorkuploadListCell" bundle:nil] forCellReuseIdentifier:@"WorkuploadListCell"];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        
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

-(void)dataArrayFromNetwor{
    MJWeakSelf
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"user_id"] = usermodel.userID;
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @(10);
    parm[@"t"] = @(self.selectType);
    parm[@"type"] = @(self.rightType);
    
    [XKNetworkManager POSTToUrlString:CompanyWorkList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        NSDictionary *resultDict = JSonDictionary;
        
        
       
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];

            /******************/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [CompanyWorkModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                if (tempdownArray.count<10) {
                    [self.datas removeAllObjects];
                    weakSelf.datas = [CompanyWorkModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.datas removeAllObjects];
                    weakSelf.datas = [CompanyWorkModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempdownArray = [CompanyWorkModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempdownArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.datas addObjectsFromArray:tempdownArray];
                    
                }
                
                
            }
            
            /******************/
            
            [weakSelf.tableView reloadData];

            
            
            
            
            
            
        }
        
        
        

    
     
    } failure:^(NSError *error) {
        weakSelf.page --;
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];

        [weakSelf showHint:error.localizedDescription];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(80);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CompanyWorkModel *model = self.datas[indexPath.row];
    WorkuploadListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkuploadListCell"];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    cell.model = model;
    

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyWorkModel *model = self.datas[indexPath.row];
    if (self.rightType == 0) {
        
        
        CompanyWorkDetail *vc = [[CompanyWorkDetail alloc]init];
        vc.nodeID = model.nodeid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JianZhiWorkDetailVC *jvc =[[JianZhiWorkDetailVC alloc]init];
        jvc.nodeID = model.nodeid;
         [self.navigationController pushViewController:jvc animated:YES];
        
    }
    
    
  

}
@end
