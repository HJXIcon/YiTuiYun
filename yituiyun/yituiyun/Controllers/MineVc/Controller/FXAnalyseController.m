//
//  FXAnalyseController.m
//  yituiyun
//
//  Created by fx on 16/10/25.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXAnalyseController.h"
#import "FXChoseRequestController.h"
#import "FXAnalyseResultController.h"
#import "FXListModel.h"
#import "FXCityModel.h"
#import "FXAnalyseCityController.h"

@interface FXAnalyseController ()<UITableViewDelegate,UITableViewDataSource,FXChoseRequestControllerDelegate,FXAnalyseCityControllerDelegate>

@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSMutableArray *industryArray;//行业列表数据
@property (nonatomic, strong) UILabel *choseLabel;//选择行业
@property (nonatomic, copy) NSString *industryId;//选择的行业id

@property (nonatomic, strong) UILabel *requestLabel;//推广要求
@property (nonatomic, copy) NSString *requestId;

@property (nonatomic, strong) UILabel *placeLabel;//推广区域
@property (nonatomic, copy) NSString *placeId;

@property (nonatomic, strong) UIImageView *triangleView;
@property (nonatomic, strong) NSMutableArray *placeArray;//区域的数字

@end

@implementation FXAnalyseController{
    BOOL _isFold;//下拉是否收起
}
- (instancetype)init{
    if (self = [super init]) {
        self.industryArray = [NSMutableArray new];
        self.placeArray = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分析助手";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self getIndustryListData];
    [self setUpviews];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpviews{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    headView.backgroundColor = MainColor;
    [self.view addSubview:headView];
    
    UIView *backFirView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, headView.frame.size.width - 40, 80)];
    backFirView.backgroundColor = kUIColorFromRGB(0xffffff);
    backFirView.layer.cornerRadius = 5;
    backFirView.clipsToBounds = YES;
    [headView addSubview:backFirView];
    
    UILabel *tipLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, backFirView.frame.size.width, 20)];
    tipLabel1.text = @"输入感兴趣的行业信息";
    tipLabel1.textColor = kUIColorFromRGB(0x404040);
    tipLabel1.textAlignment = NSTextAlignmentCenter;
    tipLabel1.font = [UIFont systemFontOfSize:15];
    [backFirView addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, backFirView.frame.size.width, 20)];
    tipLabel2.text = @"自动生成当前的推广详情";
    tipLabel2.textColor = kUIColorFromRGB(0x404040);
    tipLabel2.textAlignment = NSTextAlignmentCenter;
    tipLabel2.font = [UIFont systemFontOfSize:15];
    [backFirView addSubview:tipLabel2];
    
    //选项
    UIView *backSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 10, self.view.frame.size.width, 210)];
    backSecView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backSecView];
    
    UILabel *tipFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 100, 20)];
    tipFirLabel.text = @"行业";
    tipFirLabel.textColor = kUIColorFromRGB(0x404040);
    tipFirLabel.textAlignment = NSTextAlignmentLeft;
    tipFirLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:tipFirLabel];
    
    _isFold = YES;
    UIButton *choseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    choseButton.frame = CGRectMake(self.view.frame.size.width - 190, 15, 180, 40);
    //    choseButton.layer.cornerRadius = 5;
    choseButton.layer.borderWidth = 1;
    choseButton.layer.borderColor = kUIColorFromRGB(0xe1e1e1).CGColor;
    choseButton.backgroundColor =[UIColor whiteColor];
    [choseButton setTitle:@"" forState:UIControlStateNormal];
    [choseButton setTitleColor:MainColor forState:UIControlStateNormal];
    [choseButton addTarget:self action:@selector(choseIndustryClick:) forControlEvents:UIControlEventTouchUpInside];
    [backSecView addSubview:choseButton];
    
    self.choseLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 130, 30)];
    _choseLabel.text = @"请选择感兴趣的行业";
    _choseLabel.textColor = [UIColor grayColor];
    _choseLabel.textAlignment = NSTextAlignmentCenter;
    _choseLabel.font = [UIFont systemFontOfSize:14];
    [choseButton addSubview:_choseLabel];
    
    self.triangleView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choseLabel.frame) + 15, 13, 14, 14)];
    _triangleView.image = [UIImage imageNamed:@"jianangel.png"];
    //                _triangleView.backgroundColor = [UIColor whiteColor];
    [choseButton addSubview:_triangleView];
    
    UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipFirLabel.frame) + 25, self.view.frame.size.width, 1)];
    lineFirView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [backSecView addSubview:lineFirView];
    
    UILabel *tipSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineFirView.frame) + 25, 100, 20)];
    tipSecLabel.text = @"要求";
    tipSecLabel.textColor = kUIColorFromRGB(0x404040);
    tipSecLabel.textAlignment = NSTextAlignmentLeft;
    tipSecLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:tipSecLabel];
    
    self.requestLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipSecLabel.frame), CGRectGetMaxY(lineFirView.frame) + 25, self.view.frame.size.width - 120, 20)];
    _requestLabel.userInteractionEnabled = YES;
    [_requestLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseRequestClick)]];
    _requestLabel.text = @"请选择您的推广要求";
    _requestLabel.textColor = [UIColor grayColor];
    _requestLabel.textAlignment = NSTextAlignmentRight;
    _requestLabel.font = [UIFont systemFontOfSize:14];
    [backSecView addSubview:_requestLabel];
    
    UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipSecLabel.frame) + 25, self.view.frame.size.width, 1)];
    lineSecView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [backSecView addSubview:lineSecView];
    
    UILabel *tipThrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineSecView.frame) + 25, 100, 20)];
    tipThrLabel.text = @"区域";
    tipThrLabel.textColor = kUIColorFromRGB(0x404040);
    tipThrLabel.textAlignment = NSTextAlignmentLeft;
    tipThrLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:tipThrLabel];
    
    self.placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipThrLabel.frame), CGRectGetMaxY(lineSecView.frame) + 25, self.view.frame.size.width - 120, 20)];
    _placeLabel.userInteractionEnabled = YES;
    [_placeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chosePlaceClick)]];
    _placeLabel.text = @"请选择您的推广区域";
    _placeLabel.textColor = [UIColor grayColor];
    _placeLabel.textAlignment = NSTextAlignmentRight;
    _placeLabel.font = [UIFont systemFontOfSize:14];
    
    [backSecView addSubview:_placeLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(10, CGRectGetMaxY(backSecView.frame) + 30, self.view.frame.size.width - 20, 40);
    sureButton.layer.cornerRadius = 5;
    sureButton.backgroundColor = MainColor;
    [sureButton setTitle:@"开始分析" forState:UIControlStateNormal];
    [sureButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:sureButton];

}

//选择行业
- (void)choseIndustryClick:(UIButton *)button{
    if (_isFold) {
        [self transform];
        
        _isFold = NO;
        CGRect rectSize = [button.superview convertRect:CGRectMake(button.x, button.y, button.width, button.height) toView:self.view];
        
        self.typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(rectSize.origin.x, rectSize.origin.y + 40, rectSize.size.width, rectSize.size.height * 5) style:UITableViewStyleGrouped];
        [_typeTableView setDelegate:(id<UITableViewDelegate>) self];
        [_typeTableView setDataSource:(id<UITableViewDataSource>) self];
        [_typeTableView setShowsVerticalScrollIndicator:NO];
        _typeTableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        
        [self.view addSubview:self.typeTableView];
    }else{
        [self untransform];
        _isFold = YES;
        [_typeTableView removeFromSuperview];
    }
    
}
- (void)transform{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation( 180 / 180.0 * M_PI);
        [self.triangleView setTransform:transform];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)untransform{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation( 0 / 180.0 * M_PI);
        [self.triangleView setTransform:transform];
    }completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.industryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"typeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = kUIColorFromRGB(0x404040);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    FXListModel *model = _industryArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.backgroundColor = kUIColorFromRGB(0xededed);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isFold = YES;
    [self untransform];
    FXListModel *model = _industryArray[indexPath.row];
    _choseLabel.text = model.title;
    _choseLabel.textColor = [UIColor grayColor];
    self.industryId = model.linkID;
    [_typeTableView removeFromSuperview];
}


//选择推广要求
- (void)choseRequestClick{
    _isFold = YES;
    [self untransform];
    [_typeTableView removeFromSuperview];
    FXChoseRequestController *reqVc = [[FXChoseRequestController alloc]init];
    reqVc.delegate = self;
    [self.navigationController pushViewController:reqVc animated:YES];
}
- (void)choseRequestWithArray:(NSMutableArray *)requestArray{
    for (FXCityModel *reqModel in requestArray) {
        _requestLabel.text = [NSString stringWithFormat:@"%@",reqModel.cityName];
        _requestId = [NSString stringWithFormat:@"%@",reqModel.cityId];
        _requestLabel.textColor = [UIColor grayColor];
    }
}

//选择省市
- (void)chosePlaceClick{
    _isFold = YES;
    [self untransform];
    [_typeTableView removeFromSuperview];
    FXAnalyseCityController *proVc = [[FXAnalyseCityController alloc]init];
    proVc.delegate = self;
    [self.navigationController pushViewController:proVc animated:YES];
}
- (void)choseCityWithArray:(NSMutableArray *)cityArray{
    FXCityModel *cityModel = [cityArray firstObject];
    _placeLabel.text = cityModel.cityName;
    _placeLabel.textColor = [UIColor grayColor];
    _placeId = cityModel.cityId;

}

//获取行业下拉列表数据
- (void)getIndustryListData{
    FXListModel *model = [[FXListModel alloc]init];
    model.linkID = @"1";
    model.title = @"金融类";
    [self.industryArray addObject:model];
    
    FXListModel *model1 = [[FXListModel alloc]init];
    model1.linkID = @"2";
    model1.title = @"社交类";
    [self.industryArray addObject:model1];
    
    FXListModel *model2 = [[FXListModel alloc]init];
    model2.linkID = @"3";
    model2.title = @"旅游类";
    [self.industryArray addObject:model2];
    
    FXListModel *model3 = [[FXListModel alloc]init];
    model3.linkID = @"4";
    model3.title = @"农产品";
    [self.industryArray addObject:model3];
    
    FXListModel *model4 = [[FXListModel alloc]init];
    model4.linkID = @"5";
    model4.title = @"电商类";
    [self.industryArray addObject:model4];
    
    FXListModel *model5 = [[FXListModel alloc]init];
    model5.linkID = @"6";
    model5.title = @"教育类";
    [self.industryArray addObject:model5];
    
    FXListModel *model6 = [[FXListModel alloc]init];
    model6.linkID = @"7";
    model6.title = @"医疗类";
    [self.industryArray addObject:model6];
    
    FXListModel *model7 = [[FXListModel alloc]init];
    model7.linkID = @"8";
    model7.title = @"餐饮类";
    [self.industryArray addObject:model7];
    
    FXListModel *model8 = [[FXListModel alloc]init];
    model8.linkID = @"9";
    model8.title = @"环保类";
    [self.industryArray addObject:model8];
    
    FXListModel *model9 = [[FXListModel alloc]init];
    model9.linkID = @"10";
    model9.title = @"交通类";
    [self.industryArray addObject:model9];

    [self.typeTableView reloadData];
}
//开始分析
- (void)sureButtonClick{
    if ([_choseLabel.text isEqualToString:@"请选择感兴趣的行业"] || [_requestLabel.text isEqualToString:@"请选择您的推广要求"] || [_placeLabel.text isEqualToString:@"请选择您的推广区域"]) {
        [self showHint:@"请填写完整"];
        return;
    }
    FXAnalyseResultController *resVc = [[FXAnalyseResultController alloc]init];
    resVc.placeId = self.placeId;
    resVc.requestId = self.requestId;
    [self.navigationController pushViewController:resVc animated:YES];
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
