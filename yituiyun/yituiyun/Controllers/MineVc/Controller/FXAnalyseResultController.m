//
//  FXAnalyseResultController.m
//  yituiyun
//
//  Created by fx on 16/10/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXAnalyseResultController.h"

@interface FXAnalyseResultController ()

@property (nonatomic, copy) NSString *priceNum;//价格
@property (nonatomic, copy) NSString *coverNum;//覆盖
@property (nonatomic, copy) NSString *changeNum;//转换

@end

@implementation FXAnalyseResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分析助手";//分析结果页面
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self getResultData];
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
    
    UILabel *tipLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backFirView.frame.size.width, 80)];
    tipLabel1.text = @"分析结果";
    tipLabel1.textColor = kUIColorFromRGB(0x404040);
    tipLabel1.textAlignment = NSTextAlignmentCenter;
    tipLabel1.font = [UIFont systemFontOfSize:17];
    [backFirView addSubview:tipLabel1];
    
    //选项
    UIView *backSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 10, self.view.frame.size.width, 140)];
    backSecView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backSecView];
    
//    UILabel *tipFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 100, 20)];
//    tipFirLabel.text = @"价格";
//    tipFirLabel.textColor = kUIColorFromRGB(0x808080);
//    tipFirLabel.textAlignment = NSTextAlignmentLeft;
//    tipFirLabel.font = [UIFont systemFontOfSize:14];
//    [backSecView addSubview:tipFirLabel];
//    
//    UILabel* priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipFirLabel.frame), 25, self.view.frame.size.width - 120, 20)];
//    priceLabel.text = [@"¥" stringByAppendingString:self.priceNum];
//    priceLabel.textColor = kUIColorFromRGB(0x404040);
//    priceLabel.textAlignment = NSTextAlignmentRight;
//    priceLabel.font = [UIFont systemFontOfSize:14];
//    [backSecView addSubview:priceLabel];
//    
//    UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipFirLabel.frame) + 25, self.view.frame.size.width, 1)];
//    lineFirView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
//    [backSecView addSubview:lineFirView];
    
    UILabel *tipSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 100, 20)];
    tipSecLabel.text = @"覆盖率";
    tipSecLabel.textColor = kUIColorFromRGB(0x404040);
    tipSecLabel.textAlignment = NSTextAlignmentLeft;
    tipSecLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:tipSecLabel];
    
    UILabel* coverLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipSecLabel.frame), 25, self.view.frame.size.width - 120, 20)];
    coverLabel.text = self.coverNum;
    coverLabel.textColor = [UIColor grayColor];
    coverLabel.textAlignment = NSTextAlignmentRight;
    coverLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:coverLabel];
    
    UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipSecLabel.frame) + 25, self.view.frame.size.width, 1)];
    lineSecView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [backSecView addSubview:lineSecView];
    
    UILabel *tipThrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineSecView.frame) + 25, 100, 20)];
    tipThrLabel.text = @"转换率";
    tipThrLabel.textColor = kUIColorFromRGB(0x404040);
    tipThrLabel.textAlignment = NSTextAlignmentLeft;
    tipThrLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:tipThrLabel];
    
    UILabel* changeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipThrLabel.frame), CGRectGetMaxY(lineSecView.frame) + 25, self.view.frame.size.width - 120, 20)];
    changeLabel.text = self.changeNum;
    changeLabel.textColor = [UIColor grayColor];
    changeLabel.textAlignment = NSTextAlignmentRight;
    changeLabel.font = [UIFont systemFontOfSize:15];
    [backSecView addSubview:changeLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(12, CGRectGetMaxY(backSecView.frame) + 30, self.view.frame.size.width - 24, 40);
    sureButton.layer.cornerRadius = 5;
    sureButton.backgroundColor = MainColor;
    [sureButton setTitle:@"完 成" forState:UIControlStateNormal];
    [sureButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:sureButton];
    
}

//完成
- (void)sureButtonClick{
     [self.navigationController popViewControllerAnimated:YES];
}

//获取数据
- (void)getResultData{
//    self.priceNum = @"100000";
//    self.coverNum = @"50%"; //覆盖率
//    self.changeNum = @"30%"; //转换率
    
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=get.calculator"];
    NSDictionary *dic = @{@"c":self.requestId,
                          @"d":self.placeId
                          };
    [weakSelf showHudInView:weakSelf.navigationController.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            self.coverNum = tempDic[@"e2"];
            self.changeNum = tempDic[@"e3"];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        
        [self setUpviews];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
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
