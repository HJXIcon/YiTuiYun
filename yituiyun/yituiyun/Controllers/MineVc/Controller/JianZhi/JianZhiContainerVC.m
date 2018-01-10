//
//  JianZhiContainerVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiContainerVC.h"
#import "JianZhiFistVc.h"
#import "JianZhiSecondVc.h"

@interface JianZhiContainerVC ()
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UIButton  * rightBtn;
@property(nonatomic,strong) UIButton * leftBtn;
@property(nonatomic,strong) JianZhiFistVc * fistVc;
@property(nonatomic,strong) JianZhiSecondVc * secondVc;

@end

@implementation JianZhiContainerVC

-(JianZhiFistVc *)fistVc{
    if (_fistVc == nil) {
        _fistVc = [[JianZhiFistVc alloc]init];
        _fistVc.detailmodel = self.detailModel;
        _fistVc.ismodfiy = self.ismodfiy;
         _fistVc.view.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-64);
        
    }
    return _fistVc;
}

-(JianZhiSecondVc *)secondVc{
    if (_secondVc == nil) {
        _secondVc = [[JianZhiSecondVc alloc]init];
        _secondVc.containerVc = self;
        _secondVc.detailmodel = self.detailModel;
        _secondVc.ismodfiy = self.ismodfiy;
        _secondVc.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.view.frame.size.height-64);
    }
    return _secondVc;
}
-(UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
        [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _rightBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -30);
        [_rightBtn addTarget:self action:@selector(rightToClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

-(UIButton *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 21)];
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [_leftBtn addTarget:self action:@selector(leftbackTo) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
    }
    return _leftBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth *2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftbackTo) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    self.navigationItem.title = @"发布招聘1/2";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    //左边
    //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.scrollView.scrollEnabled = NO;
    
    
    [self.scrollView addSubview:self.fistVc.view];
    [self.scrollView addSubview:self.secondVc.view];

}


//四个控制

-(void)rightToClick{
    
    [self.view endEditing:YES];
    
    
    if (self.detailModel == nil || self.ismodfiy) {
        
        /***********/
        //判断！
        
        NSString *titleStr = [JianZhiModel shareInstance].title;
        if ([ZQ_CommonTool isEmpty:titleStr]) {
            [self showHint:@"职位名称不能为空"];
            return;
        }
        
        if (titleStr.length<5 || titleStr.length>20) {
            [self showHint:@"职位名称为5-20个字"];
            return ;
        }
             
        
        
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].salary]) {
            [self showHint:@"薪资待遇不能为空"];
            return;
        }
        
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].unit]) {
//            [self showHint:@"请选择薪资待遇的单位"];
//            return;
            [JianZhiModel shareInstance].unit = @"1";
        }
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].settlement]) {
//            [self showHint:@"请选择结算方式"];
//            return;
            [JianZhiModel shareInstance].settlement = @"1";
            
        }

        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].person_number]) {
            [self showHint:@"招聘人数不能为空"];
            return;
        }
        
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].start_date]) {
            [self showHint:@"工作开始时间不能为空"];
            return;
        }

        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].end_date]) {
            [self showHint:@"工作截止时间不能为空"];
            return;
        }
        
        long long uptime = [NSString timeSwitchTimestamp:[JianZhiModel shareInstance].start_date andFormatter:@""];
        long long downtime = [NSString timeSwitchTimestamp:[JianZhiModel shareInstance].end_date andFormatter:@""];
        
        if (downtime<uptime) {
            [self showHint:@"截止时间不能小于开始时间"];
            return ;
        }
        
        
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].contact]) {
            [self showHint:@"联系人不能为空"];
            return;
        }
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].phone]) {
            [self showHint:@"联系电话不能为空"];
            return;
        }
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].email]) {
            [self showHint:@"联系邮箱不能为空"];
            return;
        }
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].email]) {
            [self showHint:@"联系邮箱不能为空"];
            return;
        }
        
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].province]) {
            [self showHint:@"工作地点不能为空"];
            return;
        }
        
        if ([ZQ_CommonTool isEmpty:[JianZhiModel shareInstance].address]) {
            [self showHint:@"详细地址不能为空"];
            return;
        }
        
        
        

        /************/
        
    }
    
    

    
    
    
    
    
    NSInteger  index = self.scrollView.contentOffset.x/ScreenWidth;
    switch (index) {
        case 0:
            
        {
           
            
                [self.scrollView  setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
                self.navigationItem.title = @"发布招聘2/2";
                self.rightBtn.hidden = YES;
            
            
        }
            break;
    
            
            
        default:
            break;
    }
    
    
    
}


-(void)leftbackTo{
    [self.view endEditing:YES];
    NSInteger  index = self.scrollView.contentOffset.x/ScreenWidth;
    switch (index) {
        case 0:
            
            [self.navigationController popViewControllerAnimated:YES];
            [[JianZhiModel shareInstance] cleanData];
            
            
            break;
        case 1:
            [self.scrollView  setContentOffset:CGPointMake(0, 0) animated:YES];
           
            
            self.navigationItem.title = @"发布兼职1/2";
            self.rightBtn.hidden = NO;
            
            break;
            
            
            
            
        default:
            break;
    }
    
    
}

@end
