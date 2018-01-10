//
//  InviteNumberVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "InviteNumberVc.h"
#import "InviteCell.h"
#import "InviteModel.h"

@interface InviteNumberVc ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * datas;

@end

@implementation InviteNumberVc

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteCell" bundle:nil] forCellReuseIdentifier:@"InviteCell"];
    [self getDataFromServer];
}

-(void)getDataFromServer{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parm= [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"memberid"] = model.userID;
    [XKNetworkManager POSTToUrlString:InviteCountPaiMing parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        weakSelf.tableView.hidden = NO;
        NSDictionary *resultDic = JSonDictionary;
        if ([resultDic[@"errno"] isEqualToString:@"0"]) {
            weakSelf.datas = [InviteModel objectArrayWithKeyValuesArray:resultDic[@"rst"]];
            [weakSelf.tableView reloadData];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    InviteModel *model = self.datas[indexPath.row];
    cell.nameLabel.text = model.nickname;
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.moneyLabel.text = model.money;
     cell.realnameStausLabel.text = [NSString realNameStaus:[model.is_authentication integerValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
