//
//  ChooseOtherCityViewController.m
//  yituiyun
//
//  Created by NIT on 16/8/26.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "ChooseOtherCityViewController.h"
#import "ChooseCityCell.h"

@interface ChooseOtherCityViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseCityCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ChooseCityCell *cityCell;
@property (nonatomic, strong) NSDictionary *superDic;
@end

@implementation ChooseOtherCityViewController
- (instancetype)initWithCity:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.superDic = [NSDictionary dictionaryWithDictionary:dic];
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

//获取数据
- (void)sendRequestGet
{
    __weak ChooseOtherCityViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyid"] = @"1";
    params[@"parentid"] = [NSString stringWithFormat:@"%@", _superDic[@"linkageid"]];
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=linkage.get"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if (![ZQ_CommonTool isEmptyArray:responseObject]) {
            for (NSDictionary *dic in responseObject) {
                [_dataArray addObject:dic];
            }
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败,请重试" yOffset:-200];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self setupTableView];
    [self sendRequestGet];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChooseCityCell";
    ChooseCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChooseCityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    NSDictionary *dic = _dataArray[indexPath.row];
    cell.cityNameLabel.text = dic[@"name"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 40)];
    view.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ZQ_Device_Width - 24, 40)];
    label.textColor = kUIColorFromRGB(0x888888);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = _superDic[@"name"];
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.row];

    NSDictionary *dicc = @{@"provinceId":[NSString stringWithFormat:@"%@", dic[@"parentid"]], @"cityId":[NSString stringWithFormat:@"%@", dic[@"linkageid"]],@"province":_superDic[@"name"],@"city":dic[@"name"]};
    
    [USERDEFALUTS setObject:dicc forKey:@"location"];
    [USERDEFALUTS synchronize];

    if (_delegate && [_delegate respondsToSelector:@selector(seleOtherCity:)]){
        [_delegate seleOtherCity:dicc];
    }
    [self.view endEditing:YES];
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
