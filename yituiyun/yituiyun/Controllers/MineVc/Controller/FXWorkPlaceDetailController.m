//
//  FXWorkPlaceDetailController.m
//  yituiyun
//
//  Created by fx on 16/10/31.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXWorkPlaceDetailController.h"
#import "FXCompanyInfoController.h"
#import "FXWorkPlaceModel.h"

@interface FXWorkPlaceDetailController ()
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UITextField *detailField;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *locationStr;//定位的地址
@property (nonatomic, copy) NSString *logStr;//经度 x
@property (nonatomic, copy) NSString *latStr;//纬度 y

@end

@implementation FXWorkPlaceDetailController

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择办公地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    [self setUpViews];
    [self getPlaceData];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpViews{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 120)];
    backView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backView];
    
    UILabel *tipFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 30)];
    tipFirLabel.text = @"您定位的办公地址";
    tipFirLabel.textColor = kUIColorFromRGB(0xababab);
    tipFirLabel.textAlignment = NSTextAlignmentLeft;
    tipFirLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:tipFirLabel];
    
    self.placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tipFirLabel.frame), self.view.frame.size.width - 20, 20)];
    _placeLabel.text = @"";
    _placeLabel.textColor = kUIColorFromRGB(0x404040);
    _placeLabel.textAlignment = NSTextAlignmentLeft;
    _placeLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:_placeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_placeLabel.frame) + 10, self.view.frame.size.width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [backView addSubview:lineView];
    
    UILabel *tipSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame), self.view.frame.size.width - 20, 30)];
    tipSecLabel.text = @"具体地址";
    tipSecLabel.textColor = kUIColorFromRGB(0xababab);
    tipSecLabel.textAlignment = NSTextAlignmentLeft;
    tipSecLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:tipSecLabel];
    
    self.detailField = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tipSecLabel.frame), self.view.frame.size.width - 20, 20)];
    _detailField.text = self.placeString;
    _detailField.textColor = kUIColorFromRGB(0x404040);
    _detailField.font = [UIFont systemFontOfSize:15];
    _detailField.placeholder = @"请输入具体办公地址的楼层和门牌号";
    [backView addSubview:_detailField];
}

- (void)getPlaceData{
    
    [self showHudInView:self.view hint:@"加载中..."];
    __weak FXWorkPlaceDetailController *weakSelf = self;
    NSString *bodyStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=5I9f5xQb12qerHV6wMjWqpK3G9X4d546&mcode=com.yituiyun.YiTuiYun&callback=renderReverse&location=%@,%@&output=json&pois=0", self.latitude, self.longitudeStr];
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
        
        [weakSelf performSelectorOnMainThread:@selector(reloadViewData:) withObject:dic waitUntilDone:YES];
        [weakSelf hideHud];
    }];
}

- (void)reloadViewData:(NSDictionary *)dic
{
    NSDictionary *tempDic = dic[@"result"];
//    NSArray *tempArr = tempDic[@"pois"];
//    NSDictionary *subDic = [tempArr firstObject];
    self.locationStr = [NSString stringWithFormat:@"%@", tempDic[@"formatted_address"]];
    _placeLabel.text = self.locationStr;
    self.logStr = tempDic[@"location"][@"lng"];
    self.latStr = tempDic[@"location"][@"lat"];
}

- (void)sureBtnClick{
    [self.detailField resignFirstResponder];
    if ([self.detailField.text isEqualToString:@""]) {
        [self showHint:@"请填写具体地址"];
        return;
    }
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        if ([viewC isKindOfClass:[FXCompanyInfoController class]]) {
            [self.navigationController popToViewController:viewC animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(detailPlaceWith:WithLng:WithLat:)]) {
                [self.delegate detailPlaceWith:[NSString stringWithFormat:@"%@-%@",self.locationStr,self.detailField.text] WithLng:self.logStr WithLat:self.latStr];
            }
        }
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.detailField resignFirstResponder];
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
