//
//  FXChoseProvinceController.m
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXChoseProvinceController.h"
#import "FXChoseCityController.h"

@interface FXChoseProvinceController ()<UITableViewDataSource,UITableViewDelegate,FXChoseCityControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray; //数据
@property (nonatomic, strong) NSMutableArray *choseArray;//存 选择的数据

@end

@implementation FXChoseProvinceController

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray new];
        self.choseArray = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地区"; //选择省
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];

    [self getProvinceData];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"provinceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"provinceCell"];
    }
    FXCityModel *model = _dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = kUIColorFromRGB(0x404040);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = model.cityName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_choseArray removeAllObjects];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FXCityModel *model = _dataArray[indexPath.row];
    FXChoseCityController *cityVc = [[FXChoseCityController alloc] init];
    cityVc.pModel = model;
    cityVc.compareArray = self.compareArray;
    cityVc.delegate = self;
    [_choseArray addObject:model];
    [self.navigationController pushViewController:cityVc animated:YES];
}

- (void)choseCityWithModel:(NSArray *)cityArray{
    FXCityModel *provinceModel = _choseArray[0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseProviceWithProvince:andWithCityArray:)]) {
        [self.delegate choseProviceWithProvince:provinceModel andWithCityArray:cityArray];
    }
}
- (void)getProvinceData{
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=linkage.get"];
    NSDictionary *dic = @{@"keyid":@"1",
                          @"parentid":@"0"
                          };
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            FXCityModel *model = [[FXCityModel alloc] init];
            model.cityId = dic[@"linkageid"];
            model.cityName = dic[@"name"];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
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
