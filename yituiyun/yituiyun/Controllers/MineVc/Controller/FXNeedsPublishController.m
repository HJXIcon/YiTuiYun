//
//  FXNeedsPublishController.m
//  yituiyun
//
//  Created by fx on 16/11/2.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXNeedsPublishController.h"
#import "FXListModel.h"
#import "FXInPutViewController.h"
#import "FXChoseProvinceController.h"
#import "FXNeedsListController.h"
#import "ChoseProportionController.h"
#import "FillUserAgreementViewController.h"
#import "CompanyNeedsOneView.h"
#import "FXNeedsPublishControllerTwoVc.h"
#import "LHKNavController.h"
#import "WSDatePickerView.h"
#import "NeedDataModel.h"
#import "CompanyNeedscontainer.h"
#import "LHKCustomPickView.h"
#import "LHKImageUpHandle.h"


@interface FXNeedsPublishController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,FXInPutViewControllerDelegate,FXChoseProvinceControllerDelegate,ChoseProportionControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FillUserAgreementViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, strong) UIView *proportionView;

@property (nonatomic, strong) NSArray *nameArray;
@property (strong, nonatomic) UIView *pickerView;
@property (nonatomic, strong) UIPickerView *pickerView1;

@property(nonatomic,strong) CompanyNeedsOneView * oneHeadView;
@property(nonatomic,strong) LHKCustomPickView * fieldView;
@property(nonatomic,strong) UIButton * fieldBtn;

@property(nonatomic,strong) UIButton * quanguoBtn;
@end

@implementation FXNeedsPublishController{
    NSString *_selectRow;//记录填写的行
}
-(LHKCustomPickView *)fieldView{
    if (_fieldView == nil) {
        _fieldView = [LHKCustomPickView pickView];
        _fieldView.frame = [UIScreen mainScreen].bounds;
//        _fieldView.delegate  = self;
        _fieldView.cancelblock = ^(LHKCustomPickView *pick, FXListModel *fixmodel) {
            [pick removeFromSuperview];
        };
    }
    return _fieldView;
}
-(CompanyNeedsOneView *)oneHeadView{
    if (_oneHeadView == nil) {
        MJWeakSelf
        _oneHeadView = [CompanyNeedsOneView oneView];
        _oneHeadView.frame = CGRectMake(0, 0, ScreenWidth, 280);
        _oneHeadView.timeBlock = ^(UIButton *btn) {
            
            
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
                NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
//                NSLog(@"时间： %@",date);
                [weakSelf.view endEditing:YES];
                [NeedDataModel shareInstance].taskTime = date;
                [btn setTitle:date forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }];
            datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
            [datepicker show];
            [weakSelf.view endEditing:YES];
            
        };
        
        _oneHeadView.typeBlock = ^(UIButton *btn) {
            [weakSelf.view endEditing:YES];
//            NSLog(@"----%@----",self.typeArray);
          
//                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            weakSelf.fieldBtn = btn;
            
//            [weakSelf typeClickTo:btn];
            weakSelf.fieldView.datas = weakSelf.typeArray;
            
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.fieldView];
            weakSelf.fieldView.makesureblock = ^(LHKCustomPickView *pick, FXListModel *fixmodel) {
               
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitle:fixmodel.title forState:UIControlStateNormal];

                 [NeedDataModel shareInstance].taskType = fixmodel.linkID;

                [weakSelf.fieldView removeFromSuperview];
                                weakSelf.fieldView = nil;
            };
            
            weakSelf.fieldView.cancelblock = ^(LHKCustomPickView *pick, FXListModel *fixmodel) {
                [weakSelf.fieldView removeFromSuperview];
                weakSelf.fieldView = nil;

            };
            
        };
        
        
        //提示block
        _oneHeadView.tishiBlock = ^{
           LHKAlterView *alterView = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"显示的价格=任务单价-手续费" WithMakeSure:^(LHKAlterView *alterView) {
               [alterView removeFromSuperview];
           }];
            [[UIApplication sharedApplication].keyWindow addSubview:alterView];
        };
        
        
        //logoBlock
        
        _oneHeadView.logoblock = ^(UIButton *btn) {
            
            [[LHKImageUpHandle shareHandle]uploadimagesFromXiangeCe:^(NSArray *images) {
                UIImage *image = [images lastObject];
                [btn setImage:image forState:UIControlStateNormal];
               
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     weakSelf.oneHeadView.deleteBtn.hidden = NO;
                });
            } withPaths:^(NSArray *imagePaths) {
                
                NSDictionary *reslutDict = [imagePaths lastObject];
                [NeedDataModel shareInstance].logoImageurl = reslutDict[@"url"];
            } with:weakSelf.containVc];
        };
        //删除
        _oneHeadView.deleteblock = ^(UIButton *btn) {
            LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"确认删除" WithCancelBlock:^(LHKAlterView *alterView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    btn.hidden = NO;
                });
                [alterView removeFromSuperview];
                
            } WithMakeSure:^(LHKAlterView *alterView) {
                [weakSelf.oneHeadView.logoBtn setImage:[UIImage imageNamed:@"need_xiangji"] forState:UIControlStateNormal];
                [NeedDataModel shareInstance].logoImageurl = @"";
                dispatch_async(dispatch_get_main_queue(), ^{
                    btn.hidden = YES;
                });
                [alterView removeFromSuperview];
            }];
            
            [[UIApplication sharedApplication].keyWindow addSubview:alt];
        };
    }
    return _oneHeadView;
}

-(void) typeClickTo:(UIButton *)btn{
    
//    if (self.typeArray.count == 0) {
//        [self getTypeData];
//        return ;
//    }
//    self.fieldView.dataArray = self.typeArray;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.fieldView];
//    
//    
//    return ;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    __block typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < self.typeArray.count; i++) {
        FXListModel *model = _typeArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _typeLabel.text = model.title;
            _typeLabel.textColor = kUIColorFromRGB(0x404040);
            _typeId = model.linkID;
            [NeedDataModel shareInstance].taskType = model.linkID;
            
            [btn setTitle:model.title forState:UIControlStateNormal];
        }];
        [alert addAction:action];
        
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray new];
        self.typeArray = [NSMutableArray new];
        self.nameArray = [NSArray arrayWithObjects:@"1%",@"2%",@"3%",@"4%",@"5%",@"6%",@"7%",@"8%",@"9%",@"10%",@"11%",@"12%",@"13%",@"14%",@"15%",@"16%",@"17%",@"18%",@"19%",@"20%", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(publishClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    [self.view addSubview:self.oneHeadView];
    [self.view addSubview:self.tableView];
//    [self set];
    [self getTypeData];
    
   //任务详情处理空间上的东西
    
    
    
}

#pragma mark - desc数据

-(void)setDescModel:(CompanyNeedDesc *)descModel{
    _descModel = descModel;
  
    if (_descModel !=nil) {
       
       //名称
        self.oneHeadView.projectNameLabel.enabled =  self.isCanEding;
        self.oneHeadView.projectNameLabel.text = descModel.projectName;
        //任务类型
        self.oneHeadView.typeStrLabel.userInteractionEnabled =  self.isCanEding;
        [self.oneHeadView.typeStrLabel setTitle:descModel.typeStr forState:UIControlStateNormal];
        [self.oneHeadView.typeStrLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //任务单价
        self.oneHeadView.priceLabel.enabled= self.isCanEding;
        self.oneHeadView.priceLabel.text = descModel.price;
        //任务数量
        self.oneHeadView.total_singleLabel.enabled = self.isCanEding;
        self.oneHeadView.total_singleLabel.text = descModel.total_single;
        //任务截止时间
        self.oneHeadView.endDataBtn.userInteractionEnabled = self.isCanEding;
       [ self.oneHeadView.endDataBtn setTitle:descModel.endDate forState:UIControlStateNormal];
           [self.oneHeadView.endDataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.quanguoBtn.hidden = !self.isCanEding;
        
        //处理logo
        self.oneHeadView.logoBtn.userInteractionEnabled = self.isCanEding;
        [self.oneHeadView.logoBtn sd_setImageWithURL:[NSURL URLWithString:_descModel.logoImageUrl] forState:UIControlStateNormal];
        
        //处理行政区域
        
        if (descModel.citysArr.count>0) {
            [self.dataArray removeAllObjects];
            
//            for (NSString *str in descModel.citysArr) {
//                FXListModel *model = [[FXListModel alloc]init];
//                model.title = str;
//                model.linkID = @"";
//                [self.dataArray addObject:model];
//                
//            }
            
            
            if (descModel.citysArr.count == 1) {
                FXListModel *model = [[FXListModel alloc]init];
                                model.title = @"全国";
                                model.linkID = @"-1";
                                [self.dataArray addObject:model];
            }else{
                
                NSArray *IDarry = [descModel.citys componentsSeparatedByString:@"@"];
                NSArray *titleArray = descModel.citysArr;
                
            
                
                if (IDarry.count == titleArray.count) {
                    
                    for (int i = 0; i<IDarry.count; i++) {
                        FXListModel *model = [[FXListModel alloc]init];
                                        model.title = titleArray[i];
                                        model.linkID = IDarry[i];
                                        [self.dataArray addObject:model];
                    }
                    
                }else{
                    
                    FXListModel *model = [[FXListModel alloc]init];
                    model.title = @"全国";
                    model.linkID = @"-1";
                    [self.dataArray addObject:model];
                }
            }
            
            [self.tableView reloadData];
            
        }
        
        
        if (self.isCanEding) {
            //任务名称
            [NeedDataModel shareInstance].taskName = descModel.projectName;
            //任务类型
            [NeedDataModel shareInstance].taskType = descModel.typeID;
            //任务单价
            [NeedDataModel shareInstance].tasksingle = descModel.price;
            //任务数量
            [NeedDataModel shareInstance].taskNumber = descModel.total_single;
            //截止时间
            [NeedDataModel shareInstance].taskTime = descModel.endDate;
            //企业logo
            [NeedDataModel shareInstance].logoImageurl = descModel.logoImageUrl;
            
            //执行区域
            [NeedDataModel shareInstance].taskZone = self.dataArray;
            
            if (self.dataArray.count>0) {
                FXListModel *model = self.dataArray[0];
                if ([model.linkID isEqualToString:@"-1"]) {
                    self.footView.hidden = YES;
                    self.quanguoBtn.selected = YES;
                }else{
                    self.footView.hidden = NO;
                    self.quanguoBtn.selected = NO;
                }
            }
            
           
        }else{
            self.footView.hidden = YES;
        }
        
      
    }
    

}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)set{
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, ZQ_Device_Height, ZQ_Device_Width, ZQ_Device_Height/3)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    self.pickerView1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ZQ_Device_Width, CGRectGetHeight(_pickerView.frame) - 40)];
    _pickerView1.backgroundColor = [UIColor clearColor];
    _pickerView1.delegate = self;
    _pickerView1.dataSource = self;
    [_pickerView addSubview:_pickerView1];
    [_pickerView1 reloadAllComponents];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, 10, 50, 20);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView addSubview:cancelButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ZQ_Device_Width, 20)];
    label.text = @"平台加收服务费率";
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [_pickerView addSubview:label];
    
    UIButton* determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(ZQ_Device_Width - 10 - 50, 10, 50, 20);
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    [determineButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView addSubview:determineButton];
}

#pragma mark - pickerview function
//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_nameArray count];
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}
//返回指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  ZQ_Device_Width;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [_nameArray objectAtIndex:row];
    return str;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.proportionStr = [_nameArray objectAtIndex:row];

}

- (void)cancelButtonClick
{
    [self ViewAnimation:self.pickerView willHidden:YES];
}

- (void)determineButtonClick
{
    [self ViewAnimation:self.pickerView willHidden:YES];
    //添加支付比例
    _proportionLabel.text = _proportionStr;
    _proportionLabel.textColor = kUIColorFromRGB(0x404040);
    NSString *proportionId = [_proportionStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
    _proportionId = proportionId;
}

- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, self.view.frame.size.height, ZQ_Device_Width, ZQ_Device_Height/3);
        } else {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, self.view.frame.size.height - ZQ_Device_Height/3, ZQ_Device_Width, ZQ_Device_Height/3);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 280, self.view.frame.size.width, self.view.frame.size.height-280-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footView;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setShowsVerticalScrollIndicator:NO];


    }
    return _tableView;
}

- (UIView *)headView{
    if (!_headView) {
        if ([self.proportionStr isEqualToString:@""] || !_proportionStr) {
            _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 350)];
        } else {
            _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 420)];
        }
        _headView.backgroundColor = kUIColorFromRGB(0xffffff);
        
        //项目名称
        UILabel *titleTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
        titleTipLabel.text = @"项目名称";
        titleTipLabel.textColor = kUIColorFromRGB(0x808080);
        titleTipLabel.textAlignment = NSTextAlignmentLeft;
        titleTipLabel.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:titleTipLabel];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleTipLabel.frame) + 10, 0, self.view.frame.size.width - titleTipLabel.frame.size.width - 30, 70)];
        if ([self.titleStr isEqualToString:@""] || !_titleStr) {
          _titleLabel.text = @"请输入需求名称";
            _titleLabel.textColor = kUIColorFromRGB(0x808080);

        }else{
            _titleLabel.text = self.titleStr;
            _titleLabel.textColor = kUIColorFromRGB(0x404040);

        }
        
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick)]];
        [_headView addSubview:_titleLabel];
        
        UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTipLabel.frame), self.view.frame.size.width, 1)];
        lineFirView.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineFirView];
        
        //项目要求
        UILabel *requireTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineFirView.frame), 100, 70)];
        requireTipLabel.text = @"项目执行要求";
        requireTipLabel.textColor = kUIColorFromRGB(0x808080);
        requireTipLabel.textAlignment = NSTextAlignmentLeft;
        requireTipLabel.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:requireTipLabel];
        
        self.requireLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(requireTipLabel.frame) + 10, CGRectGetMaxY(lineFirView.frame), self.view.frame.size.width - requireTipLabel.frame.size.width - 30, 70)];
        if ([self.requireStr isEqualToString:@""] || !_requireStr) {
            _requireLabel.text = @"请输入项目执行要求";
            _requireLabel.textColor = kUIColorFromRGB(0x808080);

        }else{
            _requireLabel.text = self.requireStr;
            _requireLabel.textColor = kUIColorFromRGB(0x404040);

        }
        
        _requireLabel.textAlignment = NSTextAlignmentRight;
        _requireLabel.font = [UIFont systemFontOfSize:14];
        _requireLabel.userInteractionEnabled = YES;
        [_requireLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requireClick)]];
        [_headView addSubview:_requireLabel];
        
        UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(requireTipLabel.frame), self.view.frame.size.width, 1)];
        lineSecView.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineSecView];
        
        //项目类型
        UILabel *typeTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineSecView.frame), 100, 70)];
        typeTipLabel.text = @"项目类型";
        typeTipLabel.textColor = kUIColorFromRGB(0x808080);
        typeTipLabel.textAlignment = NSTextAlignmentLeft;
        typeTipLabel.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:typeTipLabel];
        
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeTipLabel.frame) + 10, CGRectGetMaxY(lineSecView.frame), self.view.frame.size.width - typeTipLabel.frame.size.width - 30, 70)];
        if ([self.typeStr isEqualToString:@""] || !_typeStr) {
            _typeLabel.text = @"请选择项目类型";
            _typeLabel.textColor = kUIColorFromRGB(0x808080);

        }else{
            _typeLabel.text = self.typeStr;
            _typeLabel.textColor = kUIColorFromRGB(0x404040);

        }
        
        _typeLabel.textAlignment = NSTextAlignmentRight;
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.userInteractionEnabled = YES;
        [_typeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeClick)]];
        [_headView addSubview:_typeLabel];
        
        UIView *lineThiView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(typeTipLabel.frame), self.view.frame.size.width, 1)];
        lineThiView.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineThiView];
        
        //项目预算经费
        UILabel *moneyTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineThiView.frame), 100, 70)];
        moneyTipLabel.text = @"项目预算经费";
        moneyTipLabel.textColor = kUIColorFromRGB(0x808080);
        moneyTipLabel.textAlignment = NSTextAlignmentLeft;
        moneyTipLabel.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:moneyTipLabel];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyTipLabel.frame) + 10, CGRectGetMaxY(lineThiView.frame), self.view.frame.size.width - moneyTipLabel.frame.size.width - 30, 70)];
        if ([self.moneyNum isEqualToString:@""] || !_moneyNum) {
            _moneyLabel.text = @"请输入项目预算经费";
            _moneyLabel.textColor = kUIColorFromRGB(0x808080);

        }else{
            _moneyLabel.text = [NSString stringWithFormat:@"%@元",self.moneyNum];
            _moneyLabel.textColor = kUIColorFromRGB(0x404040);

        }
        
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        _moneyLabel.userInteractionEnabled = YES;
        [_moneyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyClick)]];
        [_headView addSubview:_moneyLabel];
        
        
        UIView *lineThiView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyTipLabel.frame), self.view.frame.size.width, 1)];
        lineThiView1.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineThiView1];
        
        //工资支付人
        UILabel *wageLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineThiView1.frame), 100, 70)];
        wageLabel1.text = @"工资支付人";
        wageLabel1.textColor = kUIColorFromRGB(0x808080);
        wageLabel1.textAlignment = NSTextAlignmentLeft;
        wageLabel1.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:wageLabel1];
        
        self.wageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wageLabel1.frame) + 10, CGRectGetMaxY(lineThiView1.frame), self.view.frame.size.width - wageLabel1.frame.size.width - 30, 70)];
        if ([self.wageStr isEqualToString:@""] || !_wageStr) {
            _wageLabel.text = @"请选择工资支付人";
            _wageLabel.textColor = kUIColorFromRGB(0x808080);
            
        }else{
            _wageLabel.text = self.wageStr;
            _wageLabel.textColor = kUIColorFromRGB(0x404040);
            
        }
        _wageLabel.textAlignment = NSTextAlignmentRight;
        _wageLabel.font = [UIFont systemFontOfSize:14];
        _wageLabel.userInteractionEnabled = YES;
        [_wageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wageClick)]];
        [_headView addSubview:_wageLabel];
        
        self.proportionView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(wageLabel1.frame), ZQ_Device_Width, 70)];
        _proportionView.backgroundColor = [UIColor whiteColor];
        _proportionView.hidden = YES;
        [_headView addSubview:_proportionView];
        
        UIView *lineThiView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        lineThiView2.backgroundColor = kUIColorFromRGB(0xededed);
        [_proportionView addSubview:lineThiView2];
        
        //支付比例
        UILabel *proportionLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineThiView2.frame), 140, 70)];
        proportionLabel1.text = @"平台加收服务费率";
        proportionLabel1.textColor = kUIColorFromRGB(0x808080);
        proportionLabel1.textAlignment = NSTextAlignmentLeft;
        proportionLabel1.font = [UIFont systemFontOfSize:13];
        [_proportionView addSubview:proportionLabel1];
        
        self.proportionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(proportionLabel1.frame) + 10, CGRectGetMaxY(lineThiView2.frame), self.view.frame.size.width - proportionLabel1.frame.size.width - 30, 70)];
        if ([self.proportionStr isEqualToString:@""] || !_proportionStr) {
            _proportionLabel.text = @"请选择支付费率";
            _proportionLabel.textColor = kUIColorFromRGB(0x808080);
            
        }else{
            _proportionView.hidden = NO;
            _proportionLabel.text = self.proportionStr;
            _proportionLabel.textColor = kUIColorFromRGB(0x404040);
            
        }
        _proportionLabel.textAlignment = NSTextAlignmentRight;
        _proportionLabel.font = [UIFont systemFontOfSize:14];
        _proportionLabel.userInteractionEnabled = YES;
        [_proportionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(proportionClick)]];
        [_proportionView addSubview:_proportionLabel];
    }
    return _headView;
}


- (UIView *)footView{
    if (!_footView) {
        
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        _footView.backgroundColor = kUIColorFromRGB(0xffffff);
        _footView.userInteractionEnabled = YES;
        [_footView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAreaClick)]];
        CGSize labelSize = [@"添加项目执行区域" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, 20)];
        UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake((_footView.frame.size.width - labelSize.width - 20) / 2, 0, labelSize.width + 20, 60)];
        addLabel.text = @"添加项目执行区域";
        addLabel.textColor = MainColor;
        addLabel.textAlignment = NSTextAlignmentCenter;
        addLabel.font = [UIFont systemFontOfSize:14];
        [_footView addSubview:addLabel];
        
        UIImageView *addView = [[UIImageView alloc]initWithFrame:CGRectMake((_footView.frame.size.width - labelSize.width - 20) / 2 - 20, 23, 14, 14)];
        addView.image = [UIImage imageNamed:@"addNewNode.png"];
        [_footView addSubview:addView];
        

    }
    return _footView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        backView.backgroundColor = [UIColor clearColor];
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
        titleView.backgroundColor = kUIColorFromRGB(0xffffff);
        [backView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        titleLabel.text = @"项目执行区域";
        titleLabel.textColor = kUIColorFromRGB(0x404040);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:titleLabel];
        
        
        //添加执行区域全国
        
        [titleView addSubview:self.quanguoBtn];
    
        
        return backView;
    }
    return nil;
}


-(UIButton *)quanguoBtn{
    if (_quanguoBtn == nil) {
        _quanguoBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-70, 10, 70, 20)];
        [_quanguoBtn addTarget:self action:@selector(chinaCitySelect:) forControlEvents:UIControlEventTouchUpInside];
        [_quanguoBtn setImage:[UIImage imageNamed:@"quanguo-defatult"] forState:UIControlStateNormal];
        [_quanguoBtn setImage:[UIImage imageNamed:@"quanguo-gouxuan"] forState:UIControlStateSelected];
        [_quanguoBtn setTitle:@"全国" forState:UIControlStateNormal];
        _quanguoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _quanguoBtn.imageEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, 10);
        [_quanguoBtn setTitleColor:UIColorFromRGBString(@"f16156") forState:UIControlStateNormal];
    }
    return _quanguoBtn;
}


//全国城市选择
-(void)chinaCitySelect:(UIButton *)btn{
    MJWeakSelf
    if (!btn.selected) {
        if (self.dataArray.count != 0) {
            
            LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"执行区域将会全部清空，确定选择全国为执行区域吗?" WithCancelBlock:^(LHKAlterView *alterView) {
                
                [alterView removeFromSuperview];

                            } WithMakeSure:^(LHKAlterView *alterView) {
                                weakSelf.footView.hidden = YES;
                                btn.selected = YES;
                [weakSelf.dataArray removeAllObjects];
                FXListModel *listmodel = [[FXListModel alloc]init];
                listmodel.linkID = @"-1";
                listmodel.title = @"全国";
                [weakSelf.dataArray addObject:listmodel];
                [weakSelf.tableView reloadData];
                [alterView removeFromSuperview];
                

            }];
            
            [[UIApplication sharedApplication].keyWindow  addSubview:alt];
        }
        else{
            btn.selected = YES;
 weakSelf.footView.hidden = YES;
            [weakSelf.dataArray removeAllObjects];
            FXListModel *listmodel = [[FXListModel alloc]init];
            listmodel.linkID = @"-1";
            listmodel.title = @"全国";
            [weakSelf.dataArray addObject:listmodel];
            [weakSelf.tableView reloadData];
            
           


        }
    }else{//btn 从选中到未选中
        btn.selected = NO;
        weakSelf.footView.hidden = NO;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.tableView reloadData];
        

        
        
    }
    
    
    
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"needsPublishCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"needsPublishCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = kUIColorFromRGB(0x808080);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [NSString stringWithFormat:@"执行区域%d",indexPath.row + 1];
    FXListModel *model = _dataArray[indexPath.row];
    cell.detailTextLabel.text = model.title;
    cell.detailTextLabel.textColor = kUIColorFromRGB(0x404040);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    FXListModel *model = _dataArray[indexPath.row];
    [_dataArray removeObject:model];
    
     [NeedDataModel shareInstance].taskZone = self.dataArray;
    [self.tableView reloadData];
}
//输入项目名称
- (void)titleClick{
    FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
    inputVc.title = @"请输入需求名称";
    inputVc.delegate = self;
    _selectRow = @"1";
    if (![_titleLabel.text isEqualToString:@"请输入需求名称"]) {
        inputVc.textStr = _titleLabel.text;
    }
    [self.navigationController pushViewController:inputVc animated:YES];
}
//输入项目要求
- (void)requireClick{
    FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
    inputVc.title = @"请输入项目执行要求";
    inputVc.delegate = self;
    _selectRow = @"2";
    if (![_requireLabel.text isEqualToString:@"请输入项目执行要求"]) {
        inputVc.textStr = _requireLabel.text;
    }
    [self.navigationController pushViewController:inputVc animated:YES];
}
//选择类型

#pragma mark - 选择的类型

- (void)typeClick{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.fieldView];
    return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    __block typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < self.typeArray.count; i++) {
        FXListModel *model = _typeArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _typeLabel.text = model.title;
            _typeLabel.textColor = kUIColorFromRGB(0x404040);
            _typeId = model.linkID;
        }];
        [alert addAction:action];

    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];

    [self presentViewController:alert animated:YES completion:nil];
}

//输入金额
- (void)moneyClick{
    FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
    inputVc.title = @"请输入项目预算经费";
    inputVc.delegate = self;
    _selectRow = @"3";
    if (![_moneyLabel.text isEqualToString:@"请输入项目预算经费"]) {
        inputVc.textStr = _moneyNum;
    }
    [self.navigationController pushViewController:inputVc animated:YES];
}
//添加项目执行区域
#pragma mark - 执行区域
- (void)addAreaClick{
    FXChoseProvinceController *proVc = [[FXChoseProvinceController alloc]init];
    proVc.delegate = self;
    proVc.compareArray = self.dataArray;
    
    [self.containVc.navigationController pushViewController:proVc animated:YES];
//    LHKNavController *nav = [[LHKNavController alloc]initWithRootViewController:proVc];
    
//    [self presentViewController:nav animated:YES completion:nil];
}
//获取项目类型数据
- (void)getTypeData{
    MJWeakSelf
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=linkage.get"];
    NSDictionary *dic = @{@"keyid":@"3384",
                          @"parentid":@"0"
                          };
    [SVProgressHUD showWithStatus:@"获取项目类型"];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self.typeArray removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            FXListModel *model = [[FXListModel alloc]init];
            model.linkID = dic[@"linkageid"];
            model.title = dic[@"name"];
            [self.typeArray addObject:model];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
}


//选择工资支付人
- (void)wageClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *array = [NSArray arrayWithObjects:@{@"name":@"平台垫支付",@"wageId":@"1"},@{@"name":@"企业自己支付",@"wageId":@"2"}, nil];
    for (NSInteger i = 0; i < 2; i++) {
        NSDictionary *dic = array[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:dic[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _wageLabel.text = dic[@"name"];
            _wageLabel.textColor = kUIColorFromRGB(0x404040);
            _wageId = dic[@"wageId"];
            if (i == 0) {
                _headView.frame =CGRectMake(0, 10, self.view.frame.size.width, 350);
                _proportionView.hidden = YES;
                [_tableView reloadData];
            } else if (i == 1) {
                _headView.frame =CGRectMake(0, 10, self.view.frame.size.width, 420);
                _proportionView.hidden = NO;
                [_tableView reloadData];
            }
        }];
        [alert addAction:action];
        
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)proportionClick{
    [self ViewAnimation:self.pickerView willHidden:NO];
}
//
//- (void)choseProportionWithDictionary:(NSDictionary *)proportionDic
//{
//    
//}

- (void)choseProviceWithProvince:(FXCityModel *)provinceModel andWithCityArray:(NSArray *)cityArray{
    for (FXCityModel *cityModel in cityArray) {
        FXListModel *listModel = [[FXListModel alloc] init];
        listModel.title = [NSString stringWithFormat:@"%@-%@",provinceModel.cityName,cityModel.cityName];
        listModel.linkID = [NSString stringWithFormat:@"%@,%@",provinceModel.cityId,cityModel.cityId];
        [self.dataArray addObject:listModel];
    }
    [NeedDataModel shareInstance].taskZone = self.dataArray;
    [self.tableView reloadData];
}

#pragma mark 每行选择填写
- (void)saveTextWith:(NSString *)text{
    if ([_selectRow isEqualToString:@"1"]) {
        _titleLabel.text = text;
        _titleLabel.textColor = kUIColorFromRGB(0x404040);
    }else if ([_selectRow isEqualToString:@"2"]){
        _requireLabel.text = text;
        _requireLabel.textColor = kUIColorFromRGB(0x404040);
    }else if ([_selectRow isEqualToString:@"3"]){
        _moneyNum = text;
        _moneyLabel.text = [_moneyNum stringByAppendingString:@"元"];
        _moneyLabel.textColor = kUIColorFromRGB(0x404040);
    }
}
//确定 发布需求
- (void)publishClick{
    
    FXNeedsPublishControllerTwoVc *twoVc = [FXNeedsPublishControllerTwoVc new];
    twoVc.navigationItem.title = @"发布任务2/4";
    [self.navigationController pushViewController:twoVc animated:YES];
    
    return ;
    if ([_titleLabel.text isEqualToString:@"请输入需求名称"] || [_titleLabel.text isEqualToString:@""]) {
        [self showHint:@"请输入需求名称"];
        return;
    }
    if ([_requireLabel.text isEqualToString:@"请输入项目执行要求"] || [_requireLabel.text isEqualToString:@""]) {
        [self showHint:@"请输入项目执行要求"];
        return;
    }
    if ([_typeLabel.text isEqualToString:@"请选择项目类型"]) {
        [self showHint:@"请选择项目类型"];
        return;
    }
    if ([_moneyLabel.text isEqualToString:@"请输入项目预算经费"]) {
        [self showHint:@"请输入项目预算经费"];
        return;
    }
    if ([_wageLabel.text isEqualToString:@"请选择工资支付人"] || [ZQ_CommonTool isEmpty:_wageId]) {
        [self showHint:@"请选择工资支付人"];
        return;
    }
    if ([_wageId integerValue] == 2) {
        if ([_proportionLabel.text isEqualToString:@"请选择支付费率"] || [ZQ_CommonTool isEmpty:_proportionId])  {
            [self showHint:@"请选择支付费率"];
            return;
        }
    }
    if (_dataArray.count == 0) {
        [self showHint:@"请添加项目执行区域"];
        return;
    }
    
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    FillUserAgreementViewController *vc = [[FillUserAgreementViewController alloc] initWithCompanyName:userModel.nickname WithNeedsName:_titleLabel.text];
    vc.delegate = self;
    pushToControllerWithAnimated(vc)
}

- (void)userAgreementWithCompanyName:(NSString *)companyName WithNeedsName:(NSString *)needsName
{
    __block typeof(self) weakSelf = self;
    NSString *cityString = [NSString new];
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        FXListModel *model = _dataArray[i];
        if ([cityString isEqualToString:@""]) {
            cityString = [NSString stringWithFormat:@"%@",model.linkID];
        }else{
            cityString = [NSString stringWithFormat:@"%@@%@",cityString,model.linkID];
        }
    }
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=add.demand"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    dic[@"memberid"] = userModel.userID;
    dic[@"projectName"] = _titleLabel.text;
    dic[@"type"] = _typeId;
    dic[@"explain"] = _requireLabel.text;
    dic[@"fund"] = _moneyNum;
    dic[@"citys"] = cityString;
    dic[@"payer"] = _wageId;
    if ([_wageId integerValue] == 1) {
        dic[@"ratio"] = @"0";
    } else if ([_wageId integerValue] == 2) {
        dic[@"ratio"] = _proportionId;
    }
    if ([weakSelf.title isEqualToString:@"修改需求"]) {
        dic[@"demandid"] = self.needId;
        dic[@"status"] = @"0";
    }
    [weakSelf showHudInView:weakSelf.view hint:@"发布中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            for (UIViewController *viewC in weakSelf.navigationController.viewControllers) {
                if ([viewC isKindOfClass:[FXNeedsListController class]]) {
                    [weakSelf.navigationController popToViewController:viewC animated:YES];
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(publishSuccessReloadList)]) {
                        [weakSelf.delegate publishSuccessReloadList];
                    }
                }
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
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
