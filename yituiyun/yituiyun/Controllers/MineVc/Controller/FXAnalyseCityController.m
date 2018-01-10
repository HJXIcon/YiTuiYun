//
//  FXAnalyseCityController.m
//  yituiyun
//
//  Created by fx on 16/11/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXAnalyseCityController.h"
#import "FXCityModel.h"
#import "FXChoseTityCell.h"
#import "FXAnalyseController.h"

#define SelectMax 1

@interface FXAnalyseCityController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray; //数据
@property (nonatomic, strong) NSMutableArray *selectArray;//选中的数据

@end

@implementation FXAnalyseCityController

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray new];
        self.selectArray = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地区";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItemClick)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(choseCityClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:self.tableView];
    
    [self getCityData];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
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
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXCityModel *cityModel = _dataArray[indexPath.row];
    FXChoseTityCell *cell = [FXChoseTityCell choseCellWithTableView:tableView];
    cell.cityModel = cityModel;
    cell.isSelect = [_selectArray containsObject:cityModel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    FXCityModel *cityModel = _dataArray[indexPath.row];
    
    if ([_selectArray containsObject:cityModel]) {
        [_selectArray removeObject:cityModel];
        [_tableView reloadData];
    }else{
        if (_selectArray.count < SelectMax || SelectMax == 0) {
            [_selectArray addObject:cityModel];
            [_tableView reloadData];
        } else if (SelectMax == 1) {
            [_selectArray removeAllObjects];
            [_selectArray addObject:cityModel];
            [_tableView reloadData];
        } else {
            [self showHint:[NSString stringWithFormat:@"最多选%d个",SelectMax]];
        }
    }
}
- (void)choseCityClick{
    
    
    if ([ZQ_CommonTool isEmptyArray:_selectArray]) {
        [self showHint:@"请选择要求"];
        return;
    }else{
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            if ([viewC isKindOfClass:[FXAnalyseController class]]) {
                [self.navigationController popToViewController:viewC animated:YES];
                if (self.delegate && [self.delegate respondsToSelector:@selector(choseCityWithArray:)]) {
                    [self.delegate choseCityWithArray:_selectArray];
                }
            }
        }
    }
}
- (void)getCityData{
    FXCityModel *model = [[FXCityModel alloc]init];
    model.cityName = @"北京";
    model.cityId = @"1";
    model.itemImg = @"";
    [_dataArray addObject:model];
    
    FXCityModel *model1 = [[FXCityModel alloc]init];
    model1.cityName = @"天津";
    model1.cityId = @"2";
    model1.itemImg = @"";
    [_dataArray addObject:model1];
    
    FXCityModel *model2 = [[FXCityModel alloc]init];
    model2.cityName = @"上海";
    model2.cityId = @"3";
    model2.itemImg = @"";
    [_dataArray addObject:model2];
    
    FXCityModel *model3 = [[FXCityModel alloc]init];
    model3.cityName = @"深圳";
    model3.cityId = @"4";
    model3.itemImg = @"";
    [_dataArray addObject:model3];
    
    FXCityModel *model4 = [[FXCityModel alloc]init];
    model4.cityName = @"广州";
    model4.cityId = @"5";
    model4.itemImg = @"";
    [_dataArray addObject:model4];
    
    [self.tableView reloadData];
    
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
