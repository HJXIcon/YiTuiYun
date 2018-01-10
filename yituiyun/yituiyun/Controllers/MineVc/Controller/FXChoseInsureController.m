//
//  FXChoseInsureController.m
//  yituiyun
//
//  Created by fx on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXChoseInsureController.h"
#import "HFPickerView.h"
#import "FXUploadPhotoController.h"
#import "ProjectModel.h"
#import "FXInSurePayController.h"

@interface FXChoseInsureController ()<HFPickerViewDelegate>

@property (nonatomic, copy) NSString *alipayNum;//保险支付宝账号
@property (nonatomic, strong) UILabel *startTimeFirLabel;//工资险开始时间
@property (nonatomic, strong) UILabel *endTimeFirLabel;  //工资险结束时间
@property (nonatomic, strong) UILabel *startTimeSecLabel;//人身险开始时间
@property (nonatomic, strong) UILabel *endTimeSecLabel;  //人身险结束时间
@property (nonatomic, strong) UIImageView *choseFirImg; //工资险选择图
@property (nonatomic, strong) UIImageView *choseSecImg; //人身险选择图
@property (nonatomic, copy) NSString *salNum;//工资险金额 元/日
@property (nonatomic, copy) NSString *perNum;//人身险金额 元/日
@property (nonatomic, copy) NSString *salDay;//工资险购买的天数
@property (nonatomic, copy) NSString *perDay;//人身险购买的天数

@property (nonatomic, copy) NSString *salIsBuy;//工资险审核状态 0审核中 2审核失败
@property (nonatomic, copy) NSString *perIsBuy;//人身险审核状态 0审核中 2审核失败
@property (nonatomic, copy) NSString *salIsPay;//工资险支付状态 0未支付 1已支付
@property (nonatomic, copy) NSString *perIsPay;//人身险支付状态 0未支付 1已支付

@property (nonatomic, strong) UILabel *totalLabel;//
@property (nonatomic, copy) NSString *totalMoney;//总金额

@property (nonatomic, strong) UIButton *payButton;//立即支付

@property (nonatomic, copy) NSString *salOrderNum;//工资订单号
@property (nonatomic, copy) NSString *salMoney;   //工资金额
@property (nonatomic, copy) NSString *salStarTime;//工资开始时间
@property (nonatomic, copy) NSString *salEndTime; //工资结束时间

@property (nonatomic, copy) NSString *perOrderNum;//人身险订单号
@property (nonatomic, copy) NSString *perMoney;  //人身险金额
@property (nonatomic, copy) NSString *perStarTime;//人身开始时间
@property (nonatomic, copy) NSString *perEndTime;//人身结束时间

@property (nonatomic, copy) NSString *totalType;//总状态类型判断

@property (nonatomic, strong) ProjectModel *model;
@end

@implementation FXChoseInsureController{
    BOOL _salIsChose;//工资险选中
    BOOL _perIsChose;//人身险选中
}
- (instancetype)initWithProjectModel:(ProjectModel *)projectModel{
    self = [super init];
    if (self) {
        self.model = projectModel;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAlipayNum];
    [self getInsureData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择保险类型";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpAlipayView{
    UILabel *miLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
    miLabel.text = @"*";
    miLabel.textColor = MainColor;
    miLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:miLabel];
    
    UILabel *zhifuLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.frame.size.width - 40, 40)];
    zhifuLabel.text = @"请您选择一种保险类型，并点击“立即支付”按钮进行支付。支付成功后并上传截图即可申请保险";
    zhifuLabel.textColor = kUIColorFromRGB(0x808080);
    zhifuLabel.textAlignment = NSTextAlignmentLeft;
    zhifuLabel.font = [UIFont systemFontOfSize:13];
    zhifuLabel.numberOfLines = 2;
    zhifuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:zhifuLabel];
}
- (void)setUpViews{
    
    //工资险
    UIView *backFirView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 140)];
    backFirView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backFirView];
    
//    UIImageView *salaryImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//    salaryImg.image = [UIImage imageNamed:@"act_icon.png"];
//    [backFirView addSubview:salaryImg];
    
    UILabel *salarTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    salarTipLabel.text = @"工资险";
    salarTipLabel.textColor = MainColor;
    salarTipLabel.textAlignment = NSTextAlignmentCenter;
    salarTipLabel.font = [UIFont systemFontOfSize:13];
    salarTipLabel.layer.borderWidth = 1;
    salarTipLabel.layer.borderColor = MainColor.CGColor;
    salarTipLabel.layer.cornerRadius = salarTipLabel.frame.size.height / 2;
    salarTipLabel.clipsToBounds = YES;
    [backFirView addSubview:salarTipLabel];
    
    UILabel *salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(salarTipLabel.frame) + 10, 20, 200, 20)];
    salaryLabel.text = @"保证您的工资不会被拖欠";
    salaryLabel.textColor = kUIColorFromRGB(0x404040);
    salaryLabel.textAlignment = NSTextAlignmentLeft;
    salaryLabel.font = [UIFont systemFontOfSize:14];
    [backFirView addSubview:salaryLabel];
    
    UILabel *priceFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(salarTipLabel.frame) + 10, CGRectGetMaxY(salaryLabel.frame), 100, 20)];
    priceFirLabel.text = [NSString stringWithFormat:@"每天%@元",self.salNum];
    priceFirLabel.textColor = kUIColorFromRGB(0x808080);
    priceFirLabel.textAlignment = NSTextAlignmentLeft;
    priceFirLabel.font = [UIFont systemFontOfSize:13];
    [backFirView addSubview:priceFirLabel];
    
    //工资勾选对号
    UIButton *choseSalaryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choseSalaryBtn.frame = CGRectMake(backFirView.frame.size.width - 70, 0, 70, 70);
    [backFirView addSubview:choseSalaryBtn];
    if ([_totalType isEqualToString:@"1"] || [_totalType isEqualToString:@"11"]) {//两种都没选 人身险已购买
        [choseSalaryBtn addTarget:self action:@selector(choseSalaryInsure) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([ZQ_CommonTool isEmpty:_salIsPay]) {
        self.choseFirImg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 20, 20)];
        _choseFirImg.image = [UIImage imageNamed:@"unchose.png"];
        [choseSalaryBtn addSubview:_choseFirImg];
    }else if ([_totalType isEqualToString:@"2"] || [_totalType isEqualToString:@"12"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"waitpay.png"];
        [choseSalaryBtn addSubview:buyView];
    }else if([_totalType isEqualToString:@"3"] || [_totalType isEqualToString:@"13"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"checking.png"];
        [choseSalaryBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"4"] || [_totalType isEqualToString:@"14"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"checkFaild.png"];
        [choseSalaryBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"5"] || [_totalType isEqualToString:@"15"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"waituouload.png"];
        [choseSalaryBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"6"] || [_totalType isEqualToString:@"16"] || [_totalType isEqualToString:@"17"]|| [_totalType isEqualToString:@"18"]|| [_totalType isEqualToString:@"19"]|| [_totalType isEqualToString:@"20"]|| [_totalType isEqualToString:@"21"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"isbuy.png"];
        [choseSalaryBtn addSubview:buyView];
    }
    
    UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(salarTipLabel.frame) + 10, self.view.frame.size.width, 1)];
    lineFirView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [backFirView addSubview:lineFirView];
    
    UILabel *startFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineFirView.frame) + 15, self.view.frame.size.width / 2, 20)];
    startFirLabel.text = @"开始时间";
    startFirLabel.textColor = kUIColorFromRGB(0x808080);
    startFirLabel.textAlignment = NSTextAlignmentCenter;
    startFirLabel.font = [UIFont systemFontOfSize:14];
    [backFirView addSubview:startFirLabel];
    
    //工资开始时间选择器
    self.startTimeFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(startFirLabel.frame), self.view.frame.size.width / 2, 20)];
    if ([ZQ_CommonTool isEmpty:_salIsPay]) {
        _startTimeFirLabel.text = [NSString stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    }else{
        _startTimeFirLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:[self.salStarTime floatValue]] withFormat:@"yyyy-MM-dd"];
    }
    _startTimeFirLabel.textColor = kUIColorFromRGB(0x404040);
    _startTimeFirLabel.textAlignment = NSTextAlignmentCenter;
    _startTimeFirLabel.font = [UIFont systemFontOfSize:14];
    _startTimeFirLabel.userInteractionEnabled = YES;
    [backFirView addSubview:_startTimeFirLabel];
    
    UIView *lineHFirView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, CGRectGetMaxY(lineFirView.frame) + 10, 1, 50)];
    lineHFirView.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [backFirView addSubview:lineHFirView];
    
    UILabel *endFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineHFirView.frame), CGRectGetMaxY(lineFirView.frame) + 15, self.view.frame.size.width / 2 - 1, 20)];
    endFirLabel.text = @"结束时间";
    endFirLabel.textColor = kUIColorFromRGB(0x808080);
    endFirLabel.textAlignment = NSTextAlignmentCenter;
    endFirLabel.font = [UIFont systemFontOfSize:14];
    [backFirView addSubview:endFirLabel];
    
    //工资结束时间选择器
    self.endTimeFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineHFirView.frame), CGRectGetMaxY(endFirLabel.frame), self.view.frame.size.width / 2 - 1, 20)];
    if ([ZQ_CommonTool isEmpty:_salIsPay]) {
        _endTimeFirLabel.text = [NSString stringWithDate:[[NSDate date] dateByAddingDays:1] withFormat:@"yyyy-MM-dd"];
    }else{
        _endTimeFirLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:[self.salEndTime floatValue]] withFormat:@"yyyy-MM-dd"];
    }
    _endTimeFirLabel.textColor = kUIColorFromRGB(0x404040);
    _endTimeFirLabel.textAlignment = NSTextAlignmentCenter;
    _endTimeFirLabel.font = [UIFont systemFontOfSize:14];
    _endTimeFirLabel.userInteractionEnabled = YES;
    [backFirView addSubview:_endTimeFirLabel];
    
    //判断是否购买 时间选择控制点击
    if ([_totalType isEqualToString:@"1"] || [_totalType isEqualToString:@"11"]) {
        [_startTimeFirLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(salaryStartTimeClick)]];
        [_endTimeFirLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(salaryendTimeClick)]];
    }
    //人身险
    UIView *backSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backFirView.frame) + 10, self.view.frame.size.width, 140)];
    backSecView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:backSecView];
    
    UILabel *personTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    personTipLabel.text = @"人身险";
    personTipLabel.textColor = MainColor;
    personTipLabel.textAlignment = NSTextAlignmentCenter;
    personTipLabel.font = [UIFont systemFontOfSize:13];
    personTipLabel.layer.borderWidth = 1;
    personTipLabel.layer.borderColor = MainColor.CGColor;
    personTipLabel.layer.cornerRadius = salarTipLabel.frame.size.height / 2;
    personTipLabel.clipsToBounds = YES;
    [backSecView addSubview:personTipLabel];
    
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(personTipLabel.frame) + 10, 20, self.view.frame.size.width - 50 - 30 - 30, 20)];
    personLabel.text = @"以人的寿命和身体为保险标的保险";
    personLabel.textColor = kUIColorFromRGB(0x404040);
    personLabel.textAlignment = NSTextAlignmentLeft;
    personLabel.font = [UIFont systemFontOfSize:14];
    [backSecView addSubview:personLabel];
    
    UILabel *priceSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(personTipLabel.frame) + 10, CGRectGetMaxY(personLabel.frame), 100, 20)];
    priceSecLabel.text = [NSString stringWithFormat:@"每日%@元",self.perNum];
    priceSecLabel.textColor = kUIColorFromRGB(0x808080);
    priceSecLabel.textAlignment = NSTextAlignmentLeft;
    priceSecLabel.font = [UIFont systemFontOfSize:13];
    [backSecView addSubview:priceSecLabel];
    
    //人身勾选对号
    UIButton *chosePersonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chosePersonBtn.frame = CGRectMake(backSecView.frame.size.width - 70, 0, 70, 70);
    [backSecView addSubview:chosePersonBtn];
    
    if ([_totalType isEqualToString:@"1"] || [_totalType isEqualToString:@"6"]) {
        [chosePersonBtn addTarget:self action:@selector(chosePersonInsure) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([ZQ_CommonTool isEmpty:_perIsPay]) {
        self.choseSecImg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 20, 20)];
        _choseSecImg.image = [UIImage imageNamed:@"unchose.png"];
        [chosePersonBtn addSubview:_choseSecImg];
    }else if ([_totalType isEqualToString:@"7"] || [_totalType isEqualToString:@"17"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"waitpay.png"];
        [chosePersonBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"8"] || [_totalType isEqualToString:@"18"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"checking.png"];
        [chosePersonBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"9"] || [_totalType isEqualToString:@"19"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"checkFaild.png"];
        [chosePersonBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"10"] || [_totalType isEqualToString:@"20"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"waituouload.png"];
        [chosePersonBtn addSubview:buyView];
    }else if ([_totalType isEqualToString:@"11"] || [_totalType isEqualToString:@"12"] || [_totalType isEqualToString:@"13"]|| [_totalType isEqualToString:@"14"]|| [_totalType isEqualToString:@"15"]|| [_totalType isEqualToString:@"16"]|| [_totalType isEqualToString:@"21"]){
        UIImageView *buyView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 54, 54)];
        buyView.image = [UIImage imageNamed:@"isbuy.png"];
        [chosePersonBtn addSubview:buyView];
    }
    
    UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(personTipLabel.frame) + 10, self.view.frame.size.width, 1)];
    lineSecView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backSecView addSubview:lineSecView];
    
    UILabel *startSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineSecView.frame) + 15, self.view.frame.size.width / 2, 20)];
    startSecLabel.text = @"开始时间";
    startSecLabel.textColor = kUIColorFromRGB(0x808080);
    startSecLabel.textAlignment = NSTextAlignmentCenter;
    startSecLabel.font = [UIFont systemFontOfSize:14];
    [backSecView addSubview:startSecLabel];
    
    //人身开始时间选择器
    self.startTimeSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(startSecLabel.frame), self.view.frame.size.width / 2, 20)];
    if ([ZQ_CommonTool isEmpty:_perIsPay]) {
        _startTimeSecLabel.text =[NSString stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    }else{
        _startTimeSecLabel.text =[NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:[self.perStarTime floatValue]] withFormat:@"yyyy-MM-dd"];
    }
    _startTimeSecLabel.textColor = kUIColorFromRGB(0x404040);
    _startTimeSecLabel.textAlignment = NSTextAlignmentCenter;
    _startTimeSecLabel.font = [UIFont systemFontOfSize:14];
    _startTimeSecLabel.userInteractionEnabled = YES;
    [backSecView addSubview:_startTimeSecLabel];
    
    UIView *lineHSecView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, CGRectGetMaxY(lineSecView.frame) + 10, 1, 50)];
    lineHSecView.backgroundColor = kUIColorFromRGB(0xdddddd);
    [backSecView addSubview:lineHSecView];
    
    UILabel *endSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineHSecView.frame), CGRectGetMaxY(lineSecView.frame) + 15, self.view.frame.size.width / 2 - 1, 20)];
    endSecLabel.text = @"结束时间";
    endSecLabel.textColor = kUIColorFromRGB(0x808080);
    endSecLabel.textAlignment = NSTextAlignmentCenter;
    endSecLabel.font = [UIFont systemFontOfSize:14];
    [backSecView addSubview:endSecLabel];
    
    //人身结束时间选择器
    self.endTimeSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineHSecView.frame), CGRectGetMaxY(endSecLabel.frame), self.view.frame.size.width / 2 - 1, 20)];
    if ([ZQ_CommonTool isEmpty:_perIsPay]) {
        _endTimeSecLabel.text = [NSString stringWithDate:[[NSDate date] dateByAddingDays:1] withFormat:@"yyyy-MM-dd"];
    }else{
        _endTimeSecLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:[self.perEndTime floatValue]] withFormat:@"yyyy-MM-dd"];
    }
    _endTimeSecLabel.textColor = kUIColorFromRGB(0x404040);
    _endTimeSecLabel.textAlignment = NSTextAlignmentCenter;
    _endTimeSecLabel.font = [UIFont systemFontOfSize:14];
    _endTimeSecLabel.userInteractionEnabled = YES;
    [backSecView addSubview:_endTimeSecLabel];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    
    //判断是否购买 时间选择控制点击
    if ([_totalType isEqualToString:@"1"] || [_totalType isEqualToString:@"6"]) {
        [_startTimeSecLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personStartTimeClick)]];
        [_endTimeSecLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personendTimeClick)]];
        
    }
    CGSize strSize = [@"需要支付金额:" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, 50)];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, strSize.width, 50)];
    moneyLabel.text = [NSString stringWithFormat:@"需要支付金额:"];
    moneyLabel.textColor = kUIColorFromRGB(0x404040);
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:moneyLabel];
    
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyLabel.frame), 0, 80, 50)];
    if ([_totalType isEqualToString:@"2"] || [_totalType isEqualToString:@"3"] ||[_totalType isEqualToString:@"4"] || [_totalType isEqualToString:@"5"] || [_totalType isEqualToString:@"6"] || [_totalType isEqualToString:@"12"] || [_totalType isEqualToString:@"13"] || [_totalType isEqualToString:@"14"] || [_totalType isEqualToString:@"15"]) {
        _totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_salMoney floatValue]];
    }else if ([_totalType isEqualToString:@"7"] || [_totalType isEqualToString:@"8"] || [_totalType isEqualToString:@"9"] || [_totalType isEqualToString:@"10"] || [_totalType isEqualToString:@"11"] || [_totalType isEqualToString:@"17"] || [_totalType isEqualToString:@"18"] || [_totalType isEqualToString:@"19"] || [_totalType isEqualToString:@"20"]){
        _totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_perMoney floatValue]];
    }else if ([_totalType isEqualToString:@"16"] || [_totalType isEqualToString:@"21"]){
        _totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_salMoney floatValue] + [_perMoney floatValue]];

    }else{
        _totalLabel.text = @"";

    }
    _totalLabel.textColor = MainColor;
    _totalLabel.textAlignment = NSTextAlignmentLeft;
    _totalLabel.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:_totalLabel];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(CGRectGetMaxX(_totalLabel.frame) + 20, 5, self.view.frame.size.width - moneyLabel.frame.size.width - self.totalLabel.frame.size.width - 40, 40);
    _payButton.layer.cornerRadius = 5;
    [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([_totalType isEqualToString:@"2"] || [_totalType isEqualToString:@"7"] || [_totalType isEqualToString:@"12"] || [_totalType isEqualToString:@"17"]) {
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = MainColor;
        [_payButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else if ([_totalType isEqualToString:@"4"] || [_totalType isEqualToString:@"9"] || [_totalType isEqualToString:@"14"] || [_totalType isEqualToString:@"19"]){//审核失败
        [_payButton setTitle:@"重新上传截图" forState:UIControlStateNormal];
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = MainColor;
        [_payButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else if ([_totalType isEqualToString:@"5"] || [_totalType isEqualToString:@"10"] || [_totalType isEqualToString:@"15"] || [_totalType isEqualToString:@"20"]){//未上传截图
        [_payButton setTitle:@"上传付款截图" forState:UIControlStateNormal];
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = MainColor;
        [_payButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        _payButton.userInteractionEnabled = NO;
        _payButton.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [_payButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    }
    [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:_payButton];

//    if (!_salIsBuy && !_perIsBuy) {
//        [uploadButton addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
//    }else if (!_salIsBuy && ![_perIsBuy isEqualToString:@"0"]){
//        [uploadButton addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
//    }else if (!_perIsBuy && ![_salIsBuy isEqualToString:@"0"]){
//        [uploadButton addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
//    }
    
}

#pragma mark 生日时间选择后对时间格式处理
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    if (pickerView.tag == 10) {
        _startTimeFirLabel.text = confromTimespStr;
    }else if (pickerView.tag == 20){
        _endTimeFirLabel.text = confromTimespStr;
    }else if (pickerView.tag == 30){
        _startTimeSecLabel.text = confromTimespStr;
    }else if (pickerView.tag == 40){
        _endTimeSecLabel.text = confromTimespStr;
    }
    [self howMuch];
}

//工资险选择
- (void)choseSalaryInsure{
    if (_salIsChose) {
        _salIsChose = NO;
        _choseFirImg.image = [UIImage imageNamed:@"unchose.png"];
        _payButton.userInteractionEnabled = NO;
        _payButton.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [_payButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    }else{
        _salIsChose = YES;
        _choseFirImg.image = [UIImage imageNamed:@"chose.png"];
        _perIsChose = NO;
        _choseSecImg.image = [UIImage imageNamed:@"unchose.png"];
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = MainColor;
        [_payButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
    [self howMuch];
}
//工资险开始时间
- (void)salaryStartTimeClick{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *endDate = [formatter dateFromString:self.taskEndDate];
    HFPickerView *timePickView = [[HFPickerView alloc]initWithPickerMode:UIDatePickerModeDate];
    timePickView.delegate = self;
    timePickView.minimumDate = [NSDate date];
    timePickView.maximumDate = [endDate dateByAddingDays:-1];
    timePickView.tag = 10;
    [timePickView showSelf];
}
//工资险结束时间
- (void)salaryendTimeClick{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *endDate = [formatter dateFromString:self.taskEndDate];    HFPickerView *timePickView = [[HFPickerView alloc]initWithPickerMode:UIDatePickerModeDate];
    timePickView.minimumDate = [[NSDate date] dateByAddingDays:1];
    timePickView.maximumDate = endDate;
    timePickView.delegate = self;
    timePickView.tag = 20;
    [timePickView showSelf];
}
//人身险选择
- (void)chosePersonInsure{
    if (_perIsChose) {
        _perIsChose = NO;
        _choseSecImg.image = [UIImage imageNamed:@"unchose.png"];
        _payButton.userInteractionEnabled = NO;
        _payButton.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [_payButton setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    }else{
        _perIsChose = YES;
        _choseSecImg.image = [UIImage imageNamed:@"chose.png"];
        _salIsChose = NO;
        _choseFirImg.image = [UIImage imageNamed:@"unchose.png"];
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = MainColor;
        [_payButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
    [self howMuch];
}
//人身险开始时间
- (void)personStartTimeClick{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *endDate = [formatter dateFromString:self.taskEndDate];    HFPickerView *timePickView = [[HFPickerView alloc]initWithPickerMode:UIDatePickerModeDate];
    timePickView.delegate = self;
    timePickView.minimumDate = [NSDate date];
    timePickView.maximumDate = [endDate dateByAddingDays:-1];
    timePickView.tag = 30;
    [timePickView showSelf];
}
//人身险结束时间
- (void)personendTimeClick{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *endDate = [formatter dateFromString:self.taskEndDate];
    HFPickerView *timePickView = [[HFPickerView alloc]initWithPickerMode:UIDatePickerModeDate];
    timePickView.delegate = self;
    timePickView.minimumDate = [[NSDate date] dateByAddingDays:1];;
    timePickView.maximumDate = endDate;
    timePickView.tag = 40;
    [timePickView showSelf];
}
//计算总金额
- (void)howMuch{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *startFirDate = [formatter dateFromString:self.startTimeFirLabel.text];
    NSDate *endFirDate = [formatter dateFromString:self.endTimeFirLabel.text];
    NSTimeInterval salTime = [endFirDate timeIntervalSinceDate:startFirDate];
    int saldays;//工资险天数
    saldays = (salTime)/(3600*24.0);
    self.salDay = [NSString stringWithFormat:@"%i",saldays];
    if (saldays <= 0) {
        [self showHint:@"请正确选择时间段"];
        return;
    }
    self.salMoney = [NSString stringWithFormat:@"%0.2f",[_salNum floatValue] * [self.salDay floatValue]];

    NSDate *starSecDate = [formatter dateFromString:self.startTimeSecLabel.text];
    NSDate *endSecDate = [formatter dateFromString:self.endTimeSecLabel.text];
    NSTimeInterval perTime = [endSecDate timeIntervalSinceDate:starSecDate];
    int perdays;//人身险天数
    perdays = (perTime)/(3600*24.0);
    self.perDay = [NSString stringWithFormat:@"%i",perdays];
    if (perdays <= 0) {
        [self showHint:@"请正确选择时间段"];
        return;
    }
    self.perMoney = [NSString stringWithFormat:@"%0.2f",[_perNum floatValue] * [self.perDay floatValue]];

    if ([_totalType isEqualToString:@"1"]) {
        if (_salIsChose) {
            self.totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_salMoney floatValue]];

        }else if (_perIsChose){
            self.totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_perMoney floatValue]];

        }
    }else if ([_totalType isEqualToString:@"16"] || [_totalType isEqualToString:@"21"]) {
        self.totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_salMoney floatValue]+ [_perMoney floatValue]];
    }else if ([_totalType isEqualToString:@"11"] || [_totalType isEqualToString:@"2"] || [_totalType isEqualToString:@"3"] ||[_totalType isEqualToString:@"4"] || [_totalType isEqualToString:@"5"] || [_totalType isEqualToString:@"12"] || [_totalType isEqualToString:@"13"] || [_totalType isEqualToString:@"14"] || [_totalType isEqualToString:@"15"]){
        self.totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_salMoney floatValue]];
    }else if([_totalType isEqualToString:@"6"] || [_totalType isEqualToString:@"7"] || [_totalType isEqualToString:@"8"] ||[_totalType isEqualToString:@"9"] || [_totalType isEqualToString:@"10"] || [_totalType isEqualToString:@"17"] || [_totalType isEqualToString:@"18"] || [_totalType isEqualToString:@"19"] || [_totalType isEqualToString:@"20"]){
        self.totalLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_perMoney floatValue]];
    }else{
        self.totalLabel.text = @"";
    }
}
//上传截图  立即支付
- (void)payButtonClick{
    if ([_totalType isEqualToString:@"4"] || [_totalType isEqualToString:@"14"]){
        FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
        upVc.dataID = self.salOrderNum;
        upVc.title = @"重新上传截图";
        upVc.tipStr = @"请选择";
        [self.navigationController pushViewController:upVc animated:YES];
    }else if ([_totalType isEqualToString:@"9"] || [_totalType isEqualToString:@"19"]){
        FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
        upVc.dataID = self.perOrderNum;
        upVc.title = @"重新上传截图";
        upVc.tipStr = @"请选择";
        [self.navigationController pushViewController:upVc animated:YES];
    }
    else if ([_totalType isEqualToString:@"5"] || [_totalType isEqualToString:@"15"]){
        FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
        upVc.dataID = self.salOrderNum;
        upVc.title = @"上传截图";
        upVc.tipStr = @"请选择";
        [self.navigationController pushViewController:upVc animated:YES];
    }else if ([_totalType isEqualToString:@"10"] || [_totalType isEqualToString:@"20"]){
        FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
        upVc.dataID = self.perOrderNum;
        upVc.title = @"上传截图";
        upVc.tipStr = @"请选择";
        [self.navigationController pushViewController:upVc animated:YES];
    }
    else{
        FXInSurePayController *payVc = [[FXInSurePayController alloc]init];
        payVc.dataID = self.taskId;
        if ([_totalType isEqualToString:@"1"]) {
            if (_salIsChose) {
                payVc.type = @"1";
                payVc.startDateStr = self.startTimeFirLabel.text;
                payVc.endDateStr = self.endTimeFirLabel.text;
                payVc.orderNum = self.salOrderNum;
            }else if (_perIsChose){
                payVc.type = @"2";
                payVc.startDateStr = self.startTimeSecLabel.text;
                payVc.endDateStr = self.endTimeSecLabel.text;
                payVc.orderNum = self.perOrderNum;
            }
        }else if ([_totalType isEqualToString:@"2"] || [_totalType isEqualToString:@"11"] || [_totalType isEqualToString:@"12"]) {
            payVc.type = @"1";
            payVc.startDateStr = self.startTimeFirLabel.text;
            payVc.endDateStr = self.endTimeFirLabel.text;
            payVc.orderNum = self.salOrderNum;
        }else if ( [_totalType isEqualToString:@"6"] || [_totalType isEqualToString:@"7"] || [_totalType isEqualToString:@"17"]){
            payVc.type = @"2";
            payVc.startDateStr = self.startTimeSecLabel.text;
            payVc.endDateStr = self.endTimeSecLabel.text;
            payVc.orderNum = self.perOrderNum;
        }
        payVc.price = [self.totalLabel.text substringFromIndex:1];
        [self.navigationController pushViewController:payVc animated:YES];

    }
}
//获取支付宝账号
- (void)getAlipayNum{
    [self setUpAlipayView];
//    __block typeof(self) weakSelf = self;
//    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=data.contents"];
//    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
//    NSDictionary *dic = @{@"f":@"zhifubao"
//                          };
//    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        self.alipayNum = responseObject[@"zhifubao"];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
//        
//    }];
}
//获取保险状态数据
- (void)getInsureData{
    
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.getInsurance"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    self.salNum = userModel.gzprice;
    self.perNum = userModel.rsprice;
    NSDictionary *dic = @{@"memberid":userModel.userID,
                          @"demandid":self.taskId,
                          };
    [weakSelf showHudInView:weakSelf.navigationController.view hint:@""];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];
            
            NSDictionary *tempDic = responseObject[@"rst"];
             if ([tempDic[@"gongzi"] isKindOfClass:[NSArray class]] && [tempDic[@"renshen"] isKindOfClass:[NSArray class]]) {
                _salIsChose = NO;
                _perIsChose = NO;
            }
            if ([tempDic[@"renshen"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *rsDic = tempDic[@"renshen"];
                NSDate *rsStartDate = [formatter dateFromString:rsDic[@"startDate"]];
                NSDate *rsEndDate = [formatter dateFromString:rsDic[@"endDate"]];
                NSTimeInterval perTime = [rsEndDate timeIntervalSinceDate:rsStartDate];
                int perdays;//天数
                perdays = ((int)perTime)/(3600*24);
                self.perMoney = [NSString stringWithFormat:@"%0.2f",[_perNum floatValue] * perdays];
                self.perStarTime = [NSString stringWithFormat:@"%d", (long)[rsStartDate timeIntervalSince1970]];
                self.perEndTime = [NSString stringWithFormat:@"%d", (long)[rsEndDate timeIntervalSince1970]];
                self.perIsBuy = rsDic[@"status"];
                self.perOrderNum = rsDic[@"orderNo"];
                self.perIsPay = rsDic[@"payStatus"];
//                _salIsChose = NO;
                _perIsChose = YES;

            }
            if ([tempDic[@"gongzi"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *gzDic = tempDic[@"gongzi"];
                NSDate *gzStartDate = [formatter dateFromString:gzDic[@"startDate"]];
                NSDate *gzEndDate = [formatter dateFromString:gzDic[@"endDate"]];
                NSTimeInterval salTime = [gzEndDate timeIntervalSinceDate:gzStartDate];
                int saldays;//天数
                saldays = ((int)salTime)/(3600*24);
                self.salMoney = [NSString stringWithFormat:@"%0.2f",[_salNum floatValue] * saldays];
                self.salStarTime = [NSString stringWithFormat:@"%d", (long)[gzStartDate timeIntervalSince1970]];
                self.salEndTime = [NSString stringWithFormat:@"%d", (long)[gzEndDate timeIntervalSince1970]];;
                self.salIsBuy = gzDic[@"status"];
                self.salOrderNum = gzDic[@"orderNo"];
                self.salIsPay = gzDic[@"payStatus"];
                _salIsChose = YES;
//                _perIsChose = NO;

            }
            if ([ZQ_CommonTool isEmpty:_salIsPay] && [ZQ_CommonTool isEmpty:_perIsPay]) {//两种都没有
                self.totalType = @"1";
            }else if ([_salIsPay isEqualToString:@"0"] && [ZQ_CommonTool isEmpty:_perIsPay]){//工资险下单未支付 人身险未选择
                self.totalType = @"2";
            }else if ([_salIsPay isEqualToString:@"1"] && [ZQ_CommonTool isEmpty:_perIsPay]){//工资险已支付 人身险未选择
                if ([_salIsBuy isEqualToString:@"0"]) {//工资险凭证审核中
                    self.totalType = @"3";
                }else if ([_salIsBuy isEqualToString:@"2"]){//工资险凭证审核失败
                    self.totalType = @"4";
                }else if ([_salIsBuy isEqualToString:@"3"]){//工资险未上传凭证
                    self.totalType = @"5";
                }else{                   //工资险凭证审核通过，已购买
                    self.totalType = @"6";
                }
            }else if ([ZQ_CommonTool isEmpty:_salIsPay] && [_perIsPay isEqualToString:@"0"]){//工资险未选择 人身险下单未支付
                self.totalType = @"7";
            }else if ([ZQ_CommonTool isEmpty:_salIsPay] && [_perIsPay isEqualToString:@"1"]){//工资险未选择 人身险已支付
                if ([_perIsBuy isEqualToString:@"0"]) {//人身险凭证审核中
                    self.totalType = @"8";
                }else if ([_perIsBuy isEqualToString:@"2"]){//人身险凭证审核失败
                    self.totalType = @"9";
                }else if ([_perIsBuy isEqualToString:@"3"]){//人身险未上传凭证
                    self.totalType = @"10";
                }else {                    //人身险凭证审核通过，已购买
                    self.totalType = @"11";
                }
            }else if ([_salIsPay isEqualToString:0] && [_perIsBuy isEqualToString:@"1"]){//工资险下单未支付 人身险已购买
                self.totalType = @"12";
            }else if ([_salIsPay isEqualToString:@"1"] && [_perIsBuy isEqualToString:@"1"]){//工资险已支付 人身险已购买
                if ([_salIsBuy isEqualToString:@"0"]) {//工资险凭证审核中
                    self.totalType = @"13";
                }else if ([_salIsBuy isEqualToString:@"2"]){//工资险凭证审核失败
                    self.totalType = @"14";
                }else if ([_salIsBuy isEqualToString:@"3"]){//工资险未上传凭证
                    self.totalType = @"15";
                }else{                   //工资险凭证审核通过，已购买
                    self.totalType = @"16";
                }
            }else if ([_salIsBuy isEqualToString:@"1"] && [_perIsPay isEqualToString:@"0"]){//工资险已购买 人身险下单未支付
                self.totalType = @"17";
            }else if ([_salIsBuy isEqualToString:@"1"] && [_perIsPay isEqualToString:@"1"]){//工资险已购买 人身险已支付
                if ([_perIsBuy isEqualToString:@"0"]) {//人身险凭证审核中
                    self.totalType = @"18";
                }else if ([_perIsBuy isEqualToString:@"2"]){//人身险凭证审核失败
                    self.totalType = @"19";
                }else if ([_perIsBuy isEqualToString:@"3"]){//人身险未上传凭证
                    self.totalType = @"20";
                }else {                    //人身险凭证审核通过，已购买
                    self.totalType = @"21";
                }
            }
         }
        [self setUpViews];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
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
