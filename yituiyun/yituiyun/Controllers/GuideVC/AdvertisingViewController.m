//
//  AdvertisingViewController.m
//  yituiyun
//
//  Created by 张强 on 15/12/21.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "AdvertisingViewController.h"
#import "AppDelegate.h"

@interface AdvertisingViewController ()
@property (nonatomic, strong) UILabel *timelabelF;  //剩余时间Label
@property (nonatomic, strong) NSTimer *timerCode;   //定时器
@property (nonatomic, assign) int problemsTimer;    //剩余的时间
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation AdvertisingViewController
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.dic = [NSDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:_dic[@"imgLink"]];
    imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [imageView setUserInteractionEnabled:YES];
    [self.view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(ZQ_Device_Width - 100, 40, 80, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"translucent"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    
    self.timelabelF = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    _timelabelF.text = @"3";
    _timelabelF.font = [UIFont systemFontOfSize:15];
    _timelabelF.textAlignment = NSTextAlignmentCenter;
    _timelabelF.textColor = [UIColor whiteColor];
    [button addSubview:_timelabelF];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(20, 5, 60, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"跳过广告>";
    [button addSubview:label];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(0, 70, ZQ_Device_Width, self.view.bounds.size.height - 70);
    button1.backgroundColor = [UIColor clearColor];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button1];
    
    //计时器
    self.problemsTimer = 3;
    self.timerCode = [NSTimer scheduledTimerWithTimeInterval: 1
                                                      target: self
                                                    selector: @selector(timerFireMethod:)
                                                    userInfo: nil
                                                     repeats: YES];
    [[NSRunLoop currentRunLoop]addTimer:_timerCode forMode:UITrackingRunLoopMode];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    self.problemsTimer --;
    _timelabelF.text = [NSString stringWithFormat:@"%d", self.problemsTimer];
    
    if (self.problemsTimer > 0) {
        
    } else if(self.problemsTimer == 0){
        [_timerCode invalidate];
        [UIView animateWithDuration:1 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            //控制动画流程，动画执行完之后执行的方法
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loginHomePage];
        }];
    }else{
        _timerCode = nil;
    }
}

- (void)buttonClick
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate loginHomePage];
    [_timerCode invalidate];
    _timerCode = nil;
}

- (void)button1Click
{
   
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate loginAdvertising:_dic];
    
    [_timerCode invalidate];
    _timerCode = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
