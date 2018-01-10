//
//  CompanyNeedscontainer.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/16.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyNeedscontainer.h"
#import "FXNeedsPublishController.h"
#import "FXNeedsPublishControllerTwoVc.h"
#import "FXNeedPublisThreeVc.h"
#import "CompanyPulishFourVC.h"
#import "NeedDataModel.h"
#import "UploadImageModel.h"

@interface CompanyNeedscontainer ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong)  FXNeedsPublishController* onevc;
@property(nonatomic,strong) FXNeedsPublishControllerTwoVc * twoVc;
@property(nonatomic,strong) FXNeedPublisThreeVc * threeVc;
@property(nonatomic,strong) CompanyPulishFourVC * fourVc;
@property(nonatomic,strong) NSMutableArray * arrayvcs;
@property(nonatomic,strong) UIButton  * rightBtn;
@property(nonatomic,strong) UIButton * leftBtn;

@end

@implementation CompanyNeedscontainer
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
-(NSMutableArray *)arrayvcs{
    if (_arrayvcs == nil) {
        _arrayvcs = [NSMutableArray array];
    
    }
    return _arrayvcs;
}
-(FXNeedsPublishController *)onevc{
    if (_onevc == nil) {
        _onevc = [[FXNeedsPublishController alloc]init];
        _onevc.view.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-64);
        _onevc.containVc = self;
        
        _onevc.isCanEding = self.isCanEditing;
        _onevc.descModel = self.model;
        
        }
    return _onevc;
}

-(FXNeedsPublishControllerTwoVc *)twoVc{
    if (_twoVc == nil) {
        _twoVc = [[FXNeedsPublishControllerTwoVc alloc]init];
          _twoVc.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.view.frame.size.height-64);
        _twoVc.containVc = self;
        
        _twoVc.isCanEding = self.isCanEditing;
         _twoVc.descModel = self.model;
    }
    return _twoVc;
}
-(FXNeedPublisThreeVc *)threeVc{
    if (_threeVc == nil) {
        _threeVc = [[FXNeedPublisThreeVc alloc]init];
          _threeVc.view.frame = CGRectMake(2*ScreenWidth, 0, ScreenWidth, self.view.frame.size.height-64);
        _threeVc.contavC = self;
        
       _threeVc.isCanEding = self.isCanEditing;
        _threeVc.descModel = self.model;
    }
    return _threeVc;
}
-(CompanyPulishFourVC *)fourVc{
    if (_fourVc == nil) {
        _fourVc = [[CompanyPulishFourVC alloc]init];
          _fourVc.view.frame = CGRectMake(3*ScreenWidth, 0, ScreenWidth, self.view.frame.size.height);
        _fourVc.containVc = self;
       
        _fourVc.isCanEding = self.isCanEditing;
        
         _fourVc.descModel = self.model;
    }
    return _fourVc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    

   
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth *4, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftbackTo) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    self.navigationItem.title = @"发布任务1/4";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    //左边
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.scrollView.scrollEnabled = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加数据容器
    [self.scrollView addSubview:self.onevc.view];
    [self.scrollView addSubview:self.twoVc.view];
    [self.scrollView addSubview:self.threeVc.view];
    [self.scrollView addSubview:self.fourVc.view];
}

//四个控制

-(void)rightToClick{
    
       [self.view endEditing:YES];
    NSInteger  index = self.scrollView.contentOffset.x/ScreenWidth;
    switch (index) {
        case 0:
            
        {
            if (self.model !=nil) {
                if (self.isCanEditing) {
                   
                    if (![self OneTaskPanduan]) {
                        return ;
                    }
                }
                
                [self.scrollView  setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
                self.navigationItem.title = @"发布任务2/4";
                self.rightBtn.hidden = NO;

            }else if ([self OneTaskPanduan]) {
                [MobClick event:@"diyiyexiayiye"];
               [self.scrollView  setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
                self.navigationItem.title = @"发布任务2/4";
                self.rightBtn.hidden = NO;
            }
           
        }
            break;
        case 1:
        {
            if (self.model !=nil) {
                [self.scrollView  setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
                self.navigationItem.title = @"发布任务3/4";
                self.rightBtn.hidden = NO;
 
            }else if ([self twoTaskPanDuan]) {
            [self.scrollView  setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
                [MobClick event:@"dieryexiayiye"];
                self.navigationItem.title = @"发布任务3/4";
                self.rightBtn.hidden = NO;

            }

            
        }
            break;
            
        case 2:
            
            if (self.model !=nil) {
                
                [self.scrollView  setContentOffset:CGPointMake(ScreenWidth*3, 0) animated:YES];
                self.navigationItem.title = @"发布任务4/4";
                
                if (self.fourVc.isCanEding) {
                    
                    [self setupFourData];
                    
                }
                
                self.rightBtn.hidden = YES;
                
            }else if ([self ThreePanDuan]) {
                [self.scrollView  setContentOffset:CGPointMake(ScreenWidth*3, 0) animated:YES];
                [MobClick event:@"disanyexiayiye"];
                self.navigationItem.title = @"发布任务4/4";
                
                if (self.model ==nil) {
                    
                    [self setupFourData];
                    
                }
                
                self.rightBtn.hidden = YES;
 
            }

            break;
            
            
            
        default:
            break;
    }

    
    
}


-(BOOL)OneTaskPanduan{
    
     [NeedDataModel shareInstance].taskZone = self.onevc.dataArray;
    
    NSString *projectStr = [NeedDataModel shareInstance].taskName;
    
    if ([projectStr isEqualToString:@""] || projectStr.length<5 || projectStr.length>20) {
        [self showHint:@"请填写项目名称(5-20字)"];
         return NO;
        
    } else if ([[NeedDataModel shareInstance].taskType isEqualToString:@""]) {
        [self showHint:@"请选择任务类型"];
        return NO;
    }else if ( ![NSString isSuccesspriceNumber:[NeedDataModel shareInstance].tasksingle]) {
        [self showHint:@"请选择正确的任务单价"];
        return NO;
        
        

    }else if ( ![NSString isSuccesspriceNumber:[NeedDataModel shareInstance].taskNumber]) {
        [self showHint:@"请填写正确的任务数量"];
        return NO;

    }else if ([[NeedDataModel shareInstance].taskTime isEqualToString:@""]) {
        [self showHint:@"请选择任务截止时间"];
        return NO;

    }else if ([NeedDataModel shareInstance].taskZone.count == 0 ) {
        [self showHint:@"请选择执行区域"];
        return NO;
    }else{
        return YES;
    }

}

-(BOOL)twoTaskPanDuan{
    
    [NeedDataModel shareInstance].taskSetpArray = self.twoVc.allDatas;

    
    if ([[NeedDataModel shareInstance].taskDesc isEqualToString:@""]) {
        [self showHint:@"请填写任务介绍"];
        return NO;
    } else if ([NeedDataModel shareInstance].taskSetpArray.count == 0 ) {
        [self showHint:@"请添加执行步骤"];
        return NO;
    }else if ([NeedDataModel shareInstance].taskSetpArray.count >0){
    
        NSArray *alldatas = [NeedDataModel shareInstance].taskSetpArray;
        
        for (UploadImageModel *upmodel in alldatas) {
            if ([ZQ_CommonTool isEmpty:upmodel.taskField]) {
                [self showHint:@"请填写完整的步骤文字描述"];
                return NO;
            }
        }
        return YES;
        
        
    }else{
        return YES;
    }

}

-(BOOL)ThreePanDuan{
    [NeedDataModel shareInstance].taskrequireArray = self.threeVc.datalabels;
    if (self.threeVc.datalabels.count == 0) {
        [self showHint:@"请选择要求"];
        return NO;
    }else{
        return YES;
    }
}

-(void)leftbackTo{
       [self.view endEditing:YES];
    NSInteger  index = self.scrollView.contentOffset.x/ScreenWidth;
    switch (index) {
        case 0:
            [MobClick event:@"diyiyefanhui"];
            [self.navigationController popViewControllerAnimated:YES];
               [[NeedDataModel shareInstance] cleanData];
            self.rightBtn.hidden = NO;
            
            break;
        case 1:
            [self.scrollView  setContentOffset:CGPointMake(0, 0) animated:YES];
            [MobClick event:@"dieryefanhui"];

            self.navigationItem.title = @"发布任务1/4";
            self.rightBtn.hidden = NO;
            
            break;
            
        case 2:
            [self.scrollView  setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
            self.navigationItem.title = @"发布任务2/4";
            [MobClick event:@"disanyefanhui"];
            self.rightBtn.hidden = NO;
            
            break;
            case 3:
            
            
            [self.scrollView  setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
            [MobClick event:@"disiyefanhui"];

            self.navigationItem.title = @"发布任务3/4";
            
            self.rightBtn.hidden = NO;

            
            
        default:
            break;
    }

    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    NSInteger  index = scrollView.contentOffset.x/ScreenWidth;
    switch (index) {
        case 0:
            self.navigationItem.title = @"发布任务1/4";
            self.rightBtn.hidden = NO;

            
            break;
        case 1:
            self.navigationItem.title = @"发布任务2/4";
            self.rightBtn.hidden = NO;


            break;

        case 2:
            self.navigationItem.title = @"发布任务3/4";
            self.rightBtn.hidden = NO;

            break;

        case 3:
            self.navigationItem.title = @"发布任务4/4";
            
            if (self.model ==nil) {
                
                [self setupFourData];

            }
            

            self.rightBtn.hidden = YES;
            
            break;

            
        default:
            break;
    }
}

-(void)setupFourData{
    
    [NeedDataModel shareInstance].taskrequireArray = self.threeVc.datalabels;
    [NeedDataModel shareInstance].taskZone = self.onevc.dataArray;
    [NeedDataModel shareInstance].taskSetpArray = self.twoVc.allDatas;

    self.fourVc.nameLabel.text = [NeedDataModel shareInstance].taskName;
    NSString *priceString = [NSString stringWithFormat:@"%@元",[NeedDataModel shareInstance].tasksingle];
    self.fourVc.priceLabel.text = priceString;
    NSString *numberString = [NSString stringWithFormat:@"%@个",[NeedDataModel shareInstance].taskNumber];
    self.fourVc.numbeLabel.text = numberString;
    CGFloat totol = [self.fourVc.priceLabel.text floatValue] *[self.fourVc.numbeLabel.text floatValue];
    [NeedDataModel shareInstance].totalFee = totol;
    self.fourVc.totalMoney.text = [NSString stringWithFormat:@"¥%.2f",totol];
}
-(void)dealloc{
    
//    NSLog(@"----contailer控制器死了---");
    
}


@end
