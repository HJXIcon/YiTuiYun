//
//  CompanyWorkDetail.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/3.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyWorkDetail.h"
#import "TaskNodeModel.h"
#import "ChooseImageCell.h"
#import "CancelTaskCell.h"
#import "UploadTextModel.h"
#import "UploadImageModel.h"
#import "InputTextFieldViewController.h"
#import "ShowImageViewController.h"
#import "ZYQAssetPickerController.h"
#import "KNPickerController.h"
#import "TaskNodeHeadView.h"
#import "NSString+LHKExtension.h"
#import "WorkResonVC.h"
#import "JXRepeatButton.h"
@interface CompanyWorkDetail ()<UITableViewDataSource,UITableViewDelegate,ChooseImageCellDelegate,InputTextFieldViewControllerDelegate,ShowImageViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>
@property (nonatomic, strong) TaskNodeModel *model;
@property (nonatomic, strong) ChooseImageCell *chooseImageCell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *seledIndexPath;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) NSMutableArray *textDataArray;
@property (nonatomic, strong) NSMutableArray *imageDataArray;

@property(nonatomic,strong) JXRepeatButton * otherBtn;

@property(nonatomic,strong) JXRepeatButton * nopassBtn;

@property(nonatomic,strong) JXRepeatButton * passBtn;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * tel;
@property(nonatomic,strong) NSString * uploadTime;


@end

@implementation CompanyWorkDetail

-(NSMutableArray *)textDataArray{
    if (_textDataArray == nil) {
        _textDataArray = [NSMutableArray array];
    }
    return _textDataArray;
}


-(JXRepeatButton *)otherBtn{
    if (_otherBtn == nil) {
        CGFloat h = 44;
        CGFloat y = ScreenHeight -44-64;
        
        
        _otherBtn = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
        _otherBtn.frame = CGRectMake(0, y, ZQ_Device_Width , h);
        _otherBtn.backgroundColor = kUIColorFromRGB(0xcacaca);
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        _otherBtn.userInteractionEnabled = NO;
        [_otherBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
 
    }
    return _otherBtn;
}

-(JXRepeatButton *)nopassBtn{
    if (_nopassBtn == nil) {
        
        //不通过
        
        CGFloat h = 44;
        CGFloat y = ScreenHeight -44-64;

        _nopassBtn = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
        _nopassBtn.frame = CGRectMake(0, y, ZQ_Device_Width*0.5 , h);
        _nopassBtn.backgroundColor = [UIColor whiteColor];
        _nopassBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nopassBtn addTarget:self action:@selector(nopassBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_nopassBtn setTitle:@"不通过" forState:UIControlStateNormal];
        [_nopassBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

        
    }
    return _nopassBtn;
}

-(void)nopassBtnClick{
    
    WorkResonVC *vc = [[WorkResonVC alloc]init];
    vc.nodeID = self.nodeID;
    vc.navigationItem.title = @"填写理由";
    [self.navigationController pushViewController:vc animated:YES];

}
-(JXRepeatButton *)passBtn{
    if (_passBtn == nil) {
        //通过
        CGFloat h = 44;
        CGFloat y = ScreenHeight -44-64;
        _passBtn = [JXRepeatButton buttonWithType:UIButtonTypeCustom];
        _passBtn.frame = CGRectMake(ZQ_Device_Width*0.5, y, ZQ_Device_Width*0.5 , h);
        _passBtn.backgroundColor = UIColorFromRGBString(@"0xf16156");
        _passBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_passBtn addTarget:self action:@selector(passBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        [_passBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    }
    return _passBtn;
}


-(void)passBtnClick{
    
    
    
    LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"通过后佣金将直接发放到该用户账号上" WithCancelBlock:^(LHKAlterView *alterView) {
        [alterView removeFromSuperview];
    } WithMakeSure:^(LHKAlterView *alterView) {
      
        /***************/
        MJWeakSelf
        [SVProgressHUD showWithStatus:@"加载中.."];
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        parm[@"nodeid"] = self.nodeID;
        parm[@"user_id"] = model.userID;
        parm[@"t"] = @(1);
//        parm[@"remark"] = @"";
        
        [XKNetworkManager POSTToUrlString:CompanyNeedShenHeSucess parameters:parm progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *resultDict = JSonDictionary;
            NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
            NSString *reson = [NSString stringWithFormat:@"%@",resultDict[@"errmsg"]];
            
//            NSLog(@"-----%@-%@-",resultDict,self.nodeID);
            if ([code isEqualToString:@"0"]) {
                
                
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showHint:reson];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf showHint:error.localizedDescription];
        }];

        
        /***************/
        
        [alterView removeFromSuperview];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alt];
    
    
}

-(NSMutableArray *)imageDataArray{
    if (_imageDataArray == nil) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}
- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithWhere:(NSInteger)where{
    self = [super init];
    if (self) {
//        self.model = taskNodeModel;
//        self.textDataArray = [NSMutableArray array];
//        self.imageDataArray = [NSMutableArray array];
//        self.textArray = [NSMutableArray array];
//        self.imageArray = [NSMutableArray array];
//        self.where = where;
    }
    return self;
}

- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithTextDataArray:(NSArray *)textDataArray WithImageDataArray:(NSArray *)imageDataArray WithWhere:(NSInteger)where{
    self = [super init];
    if (self) {
//        self.model = taskNodeModel;
//        self.where = where;
//       
//        self.textDataArray = [NSMutableArray arrayWithArray:textDataArray];
//        self.imageDataArray = [NSMutableArray arrayWithArray:imageDataArray];
    }
    return self;
}

#pragma mark 请求网络数据
- (void)dataArrayFrom {
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"nodeid"] =self.nodeID;
    
    [XKNetworkManager POSTToUrlString:TaskNodeTimeDetail parameters:parm progress:^(CGFloat progress) {
        [SVProgressHUD  dismiss];
    } success:^(id responseObject) {
        [SVProgressHUD  dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        
        if (![resultDict[@"errno"] isEqualToString:@"0"]) {
            [weakSelf showHint:resultDict[@"errmsg"]];
            return ;
        }
        
        
        //姓名
        weakSelf.name = resultDict[@"rst"][@"node"][@"nickname"];
        //tel
        weakSelf.tel =  resultDict[@"rst"][@"node"][@"mobile"];
        //上传时间
        weakSelf.uploadTime = [NSString timeHasSecondTimeIntervalString:resultDict[@"rst"][@"node"][@"inputtime"]];
        
        //状态码
        NSString *statusCode =   resultDict[@"rst"][@"node"][@"auditing_status"];
        
        
        if ([statusCode isEqualToString:@"2"]) { //是企业审核中
            [weakSelf.view addSubview:weakSelf.nopassBtn];
            [weakSelf.view addSubview:weakSelf.passBtn];
            
        }else{
            [weakSelf.view addSubview:weakSelf.otherBtn];
            
            [weakSelf.otherBtn setTitle:[NSString getStringWithCompanyType:[statusCode integerValue]] forState:UIControlStateNormal];
            
        }
       

        weakSelf.navigationItem.title = resultDict[@"rst"][@"node"][@"projectName"];
        [weakSelf.textDataArray removeAllObjects];
        [weakSelf.imageDataArray removeAllObjects];
        
        NSArray *imgs =resultDict[@"rst"][@"imgs"];
        NSArray *text =resultDict[@"rst"][@"text"];
        if (![ZQ_CommonTool isEmptyArray:text]) {

            for (NSDictionary *subDic in text) {
                UploadTextModel *model = [[UploadTextModel alloc] init];
                model.taskName = [NSString stringWithFormat:@"%@",  subDic[@"name_zh"]];
                model.taskField = [NSString stringWithFormat:@"%@",  subDic[@"name_en"]];
                model.taskId = _model.nodeId;
                model.taskText = [NSString stringWithFormat:@"%@",  subDic[@"value"]];
                [self.textDataArray addObject:model];
            }
        }
        if (![ZQ_CommonTool isEmptyArray:imgs]) {
            
            for (NSDictionary *subDic in imgs) {
                UploadImageModel *model = [[UploadImageModel alloc] init];
                model.taskName = [NSString stringWithFormat:@"%@",  subDic[@"name_zh"]];
                model.taskField = [NSString stringWithFormat:@"%@",  subDic[@"name_en"]];
                model.taskId = _model.nodeId;
                model.imageArray = [NSMutableArray array];
                for (NSDictionary *dic in subDic[@"value"]) {
                    [model.imageArray addObject:dic[@"url"]];
                }
                [self.imageDataArray addObject:model];
            }
        }

        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD  dismiss];
    }];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
    
    [self dataArrayFrom];
    

    
    

}


#pragma mark - setupNav
- (void)setupNav{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.title = @"审核失败";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64  - 60) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
}



-(void)uploadButtonClick:(UIButton *)btn{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return _textDataArray.count;
    } else if (section == 2) {
        return _imageDataArray.count;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf
    if (indexPath.section == 0) {
        
        CancelTaskCell *cell = [CancelTaskCell cellWithTableView:tableView];
        cell.textField.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"上传用户:";
            cell.textField.text = self.name;
        }else if(indexPath.row == 1) {
            cell.nameLabel.text = @"联系方式:";
            cell.textField.text = self.tel;
 
        }else{
            cell.nameLabel.text = @"签到时间";
            cell.textField.text = self.uploadTime;
        }

        return cell;
        
        
    }else if (indexPath.section == 1){
        
        CancelTaskCell *cell = [CancelTaskCell cellWithTableView:tableView];
        cell.textField.userInteractionEnabled
        = NO;
        __block  UploadTextModel *model = _textDataArray[indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@:",model.taskName];
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", model.taskName];
        cell.textField.text = model.taskText;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //nodeText回调
        cell.nodetextBlock = ^(NSString *text) {
            model.taskText = text;
        } ;
        return cell;

        
    }else{
        ChooseImageCell *cell = [ChooseImageCell cellWithTableView:tableView];
        _chooseImageCell = cell;
        cell.indexPath = indexPath;
        cell.delegate = self;
        UploadImageModel *imageModel = _imageDataArray[indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@(最多上传10张)", imageModel.taskName];
        [cell.imageArray removeAllObjects];
        [cell.imageArray addObjectsFromArray:imageModel.imageArray];
        //    [cell makeView];
        [cell readOnlyMakeView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
 
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }
    return _chooseImageCell.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1 || section == 2) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 50)];
        view1.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ZQ_Device_Width, 40)];
        view.backgroundColor = kUIColorFromRGB(0xffffff);
        [view1 addSubview:view];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 12.5, 15, 15)];
        [view addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, ZQ_Device_Width - 33, 39)];
        label.textColor = kUIColorFromRGB(0x000000);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15.f];
        [view addSubview:label];
        
        if (section == 1) {
            label.text = @"文字信息";
            imageV.image = [UIImage imageNamed:@"textMessage"];
        } else if (section == 2) {
            label.text = @"图片信息";
            imageV.image = [UIImage imageNamed:@"imageMessage"];
        }
        return view1;
    }
    return nil;
}

#pragma mark - InputTextFieldViewControllerDelegate
- (void)inputTextFieldString:(NSString *)string WithIndex:(NSIndexPath *)index
{
    UploadTextModel *model = _textDataArray[index.row];
    model.taskText = string;
    [_tableView reloadData];
}

#pragma mark - ChooseImageCellDelegate
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    UploadImageModel *model = _imageDataArray[indexPath.row];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:model.imageArray];
    vc.delegate = self;
    vc.hideRightBtn = YES;
    vc.indexPath = indexPath;
    [vc seleImageLocation:tag];
    [vc showDeleteButton];
    pushToControllerWithAnimated(vc)
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

@end
