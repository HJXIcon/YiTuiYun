//
//  InviteFenhongDetail.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "InviteFenhongDetail.h"
#import "InviteModel.h"
#import "InviteCell.h"
#import "NSString+LHKExtension.h"
@interface InviteFenhongDetail ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * datas;

@property(nonatomic,assign)NSInteger  page;

@end

@implementation InviteFenhongDetail

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.hidden = YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteCell" bundle:nil] forCellReuseIdentifier:@"InviteCell"];
    
   
    
    
    //下拉刷新
    MJWeakSelf
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getDataFromServer];
    }];
    //上拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getDataFromServer];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)getDataFromServer{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parm= [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"memberid"] = model.userID;
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @20;
    [XKNetworkManager POSTToUrlString:InviteFengHongPaiMing parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic = JSonDictionary;
//        weakSelf.tableView.hidden = NO;
//        if ([resultDic[@"errno"] isEqualToString:@"0"]) {
//            weakSelf.datas = [InviteModel objectArrayWithKeyValuesArray:resultDic[@"rst"]];
//            [weakSelf.tableView reloadData];
//        }
        
        
        /***********/
        if ([resultDic[@"errno"] integerValue] == 0) {
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            
            /******************/
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [InviteModel objectArrayWithKeyValuesArray:resultDic[@"rst"]];
                if (tempdownArray.count<10) {
                    [self.datas removeAllObjects];
                    weakSelf.datas = [InviteModel objectArrayWithKeyValuesArray:resultDic[@"rst"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.datas removeAllObjects];
                    weakSelf.datas = [InviteModel objectArrayWithKeyValuesArray:resultDic[@"rst"]];
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempdownArray = [InviteModel objectArrayWithKeyValuesArray:resultDic[@"rst"]];
                
                if (tempdownArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.datas addObjectsFromArray:tempdownArray];
                    
                }
                
                
            }
            
            /******************/
            
            [weakSelf.tableView reloadData];
            
            
            
        }

        
        /************/
        
    } failure:^(NSError *error) {
        
        self.page --;
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    InviteModel *model = self.datas[indexPath.row];
    cell.nameLabel.text = model.nickname;
    cell.numberLabel.text = model.money;
    cell.moneyLabel.text = [NSString timeHasSecondTimeIntervalString:model.add_time];
    cell.realnameStausLabel.text = [NSString realNameStaus:[model.is_authentication integerValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
