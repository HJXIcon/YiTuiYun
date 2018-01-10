//
//  FXChoseCityController.m
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXChoseCityController.h"
#import "FXChoseTityCell.h"
//#import "FXNeedsPublishController.h"
#import "FXAnalyseController.h"
#import "FXListModel.h"
#import "CompanyNeedscontainer.h"

#define SelectMax 1

@interface FXChoseCityController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray; //数据
@property (nonatomic, strong) NSMutableArray *selectArray;//选中的数据

@end

@implementation FXChoseCityController

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
    self.title = @"选择地区";//选择城市
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(choseCitySureClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    
    [self.view addSubview:self.tableView];
    [self getData];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
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
    FXListModel *tempModel = [[FXListModel alloc]init];
    tempModel.title = [NSString stringWithFormat:@"%@-%@",_pModel.cityName,cityModel.cityName];
    tempModel.linkID = [NSString stringWithFormat:@"%@,%@",_pModel.cityId,cityModel.cityId];
    for (FXListModel *subModel in self.compareArray) {
        if ([subModel.title isEqualToString:tempModel.title] && [subModel.linkID isEqualToString:tempModel.linkID]) {
            cell.isSelect = YES;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FXCityModel *cityModel = _dataArray[indexPath.row];
    
    FXListModel *tempModel = [[FXListModel alloc] init];
    tempModel.title = [NSString stringWithFormat:@"%@-%@",_pModel.cityName,cityModel.cityName];
    tempModel.linkID = [NSString stringWithFormat:@"%@,%@",_pModel.cityId,cityModel.cityId];
    
    for (FXListModel *subModel in self.compareArray) {
        if ([subModel.title isEqualToString:tempModel.title] && [subModel.linkID isEqualToString:tempModel.linkID]) {
            [self showHint:@"您已经添加过此区域"];
            return;
        }
    }
    if ([_selectArray containsObject:cityModel]) {
        [_selectArray removeObject:cityModel];
        [_tableView reloadData];
    }else{
        [_selectArray addObject:cityModel];
        [_tableView reloadData];
//        if (_selectArray.count < SelectMax || SelectMax == 0) {
//            
//        } else if (SelectMax == 1) {
//            [_selectArray removeAllObjects];
//            [_selectArray addObject:cityModel];
//            [_tableView reloadData];
//        } else {
//            [self showHint:[NSString stringWithFormat:@"最多选%d个城市",SelectMax]];
//        }
    }
}
- (void)choseCitySureClick{
    
  
   
    if (_selectArray.count == 0 || !_selectArray) {
        [self showHint:@"请选择一个区域"];
        return;
    }
    FXCityModel *model = _selectArray[0];
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        if ([viewC isKindOfClass:[CompanyNeedscontainer class]]) {
            [self.navigationController popToViewController:viewC animated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(choseCityWithModel:)]) {
                [self.delegate choseCityWithModel:_selectArray];
            }
        }else if ([viewC isKindOfClass:[FXAnalyseController class]]){
            [self.navigationController popToViewController:viewC animated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(choseCityWithModel:)]) {
                [self.delegate choseCityWithModel:model];
            }
        }
    }
}
- (void)getData{
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=linkage.get"];
    NSDictionary *dic = @{@"keyid":@"1",
                          @"parentid":self.pModel.cityId
                          };
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            FXCityModel *model = [[FXCityModel alloc]init];
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
