//
//  MoneyDetailsViewController.m
//  yituiyun
//
//  Created by 张强 on 2016/12/30.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "MoneyDetailsViewController.h"
#import "FXMoneyListModel.h"
#import "MoneyDetailsCell.h"

@interface MoneyDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *dataId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FXMoneyListModel *model;

@end

@implementation MoneyDetailsViewController
- (instancetype)initWithDataId:(NSString *)dataId{
    if (self = [super init]) {
        self.dataId = dataId;
    
    }
    return self;
}

- (void)getData
{
    __weak MoneyDetailsViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"adid"] = _dataId;
    params[@"uid"] = infoModel.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=burse.detail"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = responseObject[@"rst"];
            _model.serialNumber = [NSString stringWithFormat:@"%@", dic[@"serialno"]];
            _model.time = [NSString getDateFromTimeStamp:dic[@"inputtime"]];
            _model.num = [NSString stringWithFormat:@"%@", dic[@"money"]];
            _model.tradeType = [NSString stringWithFormat:@"%@", dic[@"t"]];
            _model.itemTitle = [NSString stringWithFormat:@"%@", dic[@"unumber"]];
            _model.type = [NSString stringWithFormat:@"%@", dic[@"type"]];
            _model.state = [NSString stringWithFormat:@"%@", dic[@"status"]];
            _model.note = [NSString stringWithFormat:@"%@", dic[@"intro"]];
            _model.balance = [NSString stringWithFormat:@"%@", dic[@"amount"]];
            _model.nickName = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
            _model.projectName = [NSString stringWithFormat:@"%@", dic[@"projectName"]];
            [_tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    self.model = [[FXMoneyListModel alloc] init];
    [self setUpTableView];
    [self getData];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpTableView{
    //初始化 tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //优化写成数组
    MoneyDetailsCell *cell = [MoneyDetailsCell cellWithTableView:tableView];
    cell.nameLabel.textColor = kUIColorFromRGB(0x404040);
    cell.detailLabel.textColor = [UIColor grayColor];
    if ([_model.type integerValue] == 1) {//充值
        if (indexPath.section == 0) {
            cell.nameLabel.text = @"流水号";
            cell.detailLabel.text = _model.serialNumber;
        } else if (indexPath.section == 1) {
            cell.nameLabel.text = @"类型";
            cell.detailLabel.text = @"充值";
        } else if (indexPath.section == 2) {
            cell.nameLabel.text = @"充值金额";
            cell.detailLabel.text = [_model.num stringByAppendingString:@"元"];
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 3) {
            cell.nameLabel.text = @"充值方式";
            if ([_model.tradeType integerValue] == 1) {
                cell.detailLabel.text = @"微信";
            } else if ([_model.tradeType integerValue] == 2) {
                cell.detailLabel.text = @"支付宝";
            } else {
                cell.detailLabel.text = @"银行卡";
            }
        } else if (indexPath.section == 4) {
            cell.nameLabel.text = @"时间";
            cell.detailLabel.text = _model.time;
        } else if (indexPath.section == 5) {
            cell.nameLabel.text = @"余额";
            cell.detailLabel.text = [_model.balance stringByAppendingString:@"元"];
        } else if (indexPath.section == 6) {
            cell.nameLabel.text = @"充值状态";
            if ([_model.state integerValue] == 0) {
                cell.detailLabel.text = @"排队等候";
            } else if ([_model.state integerValue] == 1) {
                cell.detailLabel.text = @"正在处理中";
            } else if ([_model.state integerValue] == 2) {
                cell.detailLabel.text = @"已完成";
            } else if ([_model.state integerValue] == 3) {
                cell.detailLabel.text = @"申请驳回";
            }
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 7) {
            cell.nameLabel.text = @"备注";
            cell.detailLabel.text = _model.note;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([_model.type integerValue] == 2) {//退款
        if (indexPath.section == 0) {
            cell.nameLabel.text = @"流水号";
            cell.detailLabel.text = _model.serialNumber;
        } else if (indexPath.section == 1) {
            cell.nameLabel.text = @"类型";
            cell.detailLabel.text = @"退款";
        } else if (indexPath.section == 2) {
            cell.nameLabel.text = @"退款金额";
            cell.detailLabel.text = [_model.num stringByAppendingString:@"元"];
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 3) {
            cell.nameLabel.text = @"退款方式";
            if ([_model.tradeType integerValue] == 1) {
                cell.detailLabel.text = @"微信";
            } else if ([_model.tradeType integerValue] == 2) {
                cell.detailLabel.text = @"支付宝";
            } else {
                cell.detailLabel.text = @"银行卡";
            }
        } else if (indexPath.section == 4) {
            cell.nameLabel.text = @"时间";
            cell.detailLabel.text = _model.time;
        } else if (indexPath.section == 5) {
            cell.nameLabel.text = @"余额";
            cell.detailLabel.text = [_model.balance stringByAppendingString:@"元"];
        } else if (indexPath.section == 6) {
            cell.nameLabel.text = @"退款状态";
            if ([_model.state integerValue] == 0) {
                cell.detailLabel.text = @"排队等候";
            } else if ([_model.state integerValue] == 1) {
                cell.detailLabel.text = @"正在处理中";
            } else if ([_model.state integerValue] == 2) {
                cell.detailLabel.text = @"已完成";
            } else if ([_model.state integerValue] == 3) {
                cell.detailLabel.text = @"申请驳回";
            }
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 7) {
            cell.nameLabel.text = @"备注";
            cell.detailLabel.text = _model.note;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([_model.type integerValue] == 3) {//支付工资
        UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
        if (indexPath.section == 0) {
            cell.nameLabel.text = @"类型";
            cell.detailLabel.text = [infoModel.identity integerValue] == 6 ? @"工资" : @"支付工资";
        } else if (indexPath.section == 1) {
            cell.nameLabel.text = @"工资金额";
            cell.detailLabel.text = [_model.num stringByAppendingString:@"元"];
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 2) {
            cell.nameLabel.text = @"项目名称";
            cell.detailLabel.text = _model.projectName;
        } else if (indexPath.section == 3) {
            cell.nameLabel.text = @"用户名称";
            cell.detailLabel.text = _model.nickName;
        } else if (indexPath.section == 4) {
            cell.nameLabel.text = @"时间";
            cell.detailLabel.text = _model.time;
        } else if (indexPath.section == 5) {
            cell.nameLabel.text = @"余额";
            cell.detailLabel.text = [_model.balance stringByAppendingString:@"元"];
        } else if (indexPath.section == 6) {
            cell.nameLabel.text = @"打款状态";
            if ([_model.state integerValue] == 0) {
                cell.detailLabel.text = @"排队等候";
            } else if ([_model.state integerValue] == 1) {
                cell.detailLabel.text = @"正在处理中";
            } else if ([_model.state integerValue] == 2) {
                cell.detailLabel.text = @"已完成";
            } else if ([_model.state integerValue] == 3) {
                cell.detailLabel.text = @"申请驳回";
            }
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 7) {
            cell.nameLabel.text = @"备注";
            cell.detailLabel.text = _model.note;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([_model.type integerValue] == 4) {//提现
        if (indexPath.section == 0) {
            cell.nameLabel.text = @"流水号";
            cell.detailLabel.text = _model.serialNumber;
        } else if (indexPath.section == 1) {
            cell.nameLabel.text = @"类型";
            cell.detailLabel.text = @"提现";
        } else if (indexPath.section == 2) {
            cell.nameLabel.text = @"提现金额";
            cell.detailLabel.text = [_model.num stringByAppendingString:@"元"];
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 3) {
            cell.nameLabel.text = @"提现方式";
            if ([_model.tradeType integerValue] == 1) {
                cell.detailLabel.text = @"微信";
            } else if ([_model.tradeType integerValue] == 2) {
                cell.detailLabel.text = @"支付宝";
            } else {
                cell.detailLabel.text = @"银行卡";
            }
        } else if (indexPath.section == 4) {
            cell.nameLabel.text = @"时间";
            cell.detailLabel.text = _model.time;
        } else if (indexPath.section == 5) {
            cell.nameLabel.text = @"余额";
            cell.detailLabel.text = [_model.balance stringByAppendingString:@"元"];
        } else if (indexPath.section == 6) {
            cell.nameLabel.text = @"提现状态";
            if ([_model.state integerValue] == 0) {
                cell.detailLabel.text = @"排队等候";
            } else if ([_model.state integerValue] == 1) {
                cell.detailLabel.text = @"正在处理中";
            } else if ([_model.state integerValue] == 2) {
                cell.detailLabel.text = @"已完成";
            } else if ([_model.state integerValue] == 3) {
                cell.detailLabel.text = @"申请驳回";
            }
            cell.detailLabel.textColor = MainColor;
        } else if (indexPath.section == 7) {
            cell.nameLabel.text = @"备注";
            cell.detailLabel.text = _model.note;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
