//
//  FXWorkPlaceListController.m
//  yituiyun
//
//  Created by fx on 16/10/29.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXWorkPlaceListController.h"
#import "FXWorkPlaceModel.h"
#import "FXWorkPlaceCell.h"
#import "FXWorkPlaceDetailController.h"

#define SelectMax 1

@interface FXWorkPlaceListController ()<UITableViewDelegate,UITableViewDataSource,FXWorkPlaceDetailControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *choseArray;
@property (nonatomic, copy) NSString *placeLng;//选中地址的经度
@property (nonatomic, copy) NSString *placeLat;//选中地址的纬度


@end

@implementation FXWorkPlaceListController

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
    self.title = @"选择办公地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self.view addSubview:self.tableView];
    [self setUpRightBtn];
    [self getPlaceData];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpRightBtn{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(makesureClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
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
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXWorkPlaceModel *placeModel = _dataArray[indexPath.row];
    FXWorkPlaceCell *cell = [FXWorkPlaceCell placeCellWithTableView:tableView];
    cell.placeModel = placeModel;
    cell.isChose = [_choseArray containsObject:placeModel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    FXWorkPlaceModel *placeModel = self.dataArray[indexPath.row];
    if ([_choseArray containsObject:placeModel]) {
        [_choseArray removeObject:placeModel];
        [_tableView reloadData];
    }else{
        if (_choseArray.count < SelectMax || SelectMax == 0) {
            [_choseArray addObject:placeModel];
            [_tableView reloadData];
        } else if (SelectMax == 1) {
            [_choseArray removeAllObjects];
            [_choseArray addObject:placeModel];
            [_tableView reloadData];
        } else {
//            [self showHint:[NSString stringWithFormat:@"最多选%d个地址",SelectMax]];
        }
    }
}
//确定
- (void)makesureClick{
    FXWorkPlaceModel *model = _choseArray[0];
    FXWorkPlaceDetailController *detailVc = [[FXWorkPlaceDetailController alloc]init];
    detailVc.placeString = [model.buildPlace stringByAppendingString:model.detailPlace];
    detailVc.delegate = self;
    self.placeLng = model.lngStr;
    self.placeLat = model.latStr;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)workPlaceWith:(NSString *)workPlace{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailPlaceWith:WithLng:WithLat:)]) {
        [self.delegate detailPlaceWith:workPlace WithLng:self.placeLng WithLat:self.placeLat];
    }
}
- (void)getPlaceData{
    __weak FXWorkPlaceListController *weakSelf = self;
    
    //假数据
//    self.longitudeStr =@"116.31751093934";
//    self.latitude =@"40.040807852237";
    
    NSString *bodyStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=pn8B4yEuClbl9Gy84rGSd3oK&callback=renderReverse&location=%@,%@&output=json&pois=10", self.latitude, self.longitudeStr];
    NSURL *url = [NSURL URLWithString:bodyStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //转变其中的内容
        str=[str stringByReplacingOccurrencesOfString:@"renderReverse&&renderReverse(" withString:@""];
        str=[str stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        
//        [weakSelf performSelectorOnMainThread:@selector(getValueForContentViewFromDict:) withObject:dic waitUntilDone:YES];
        NSDictionary *tempDic = dic[@"result"];
        NSArray *tempArr = tempDic[@"pois"];
        for (NSDictionary *subDic in tempArr) {
            FXWorkPlaceModel *model = [[FXWorkPlaceModel alloc]init];
            model.buildPlace = subDic[@"addr"];
            model.detailPlace = subDic[@"name"];
            NSDictionary *pointDic = subDic[@"point"];
            model.lngStr = pointDic[@"x"];
            model.latStr = pointDic[@"y"];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];

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
