//
//  FXNeedsDetailController.m
//  yituiyun
//
//  Created by fx on 16/11/1.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXNeedsDetailController.h"
#import "FXListModel.h"
#import "FXUploadPhotoController.h"
#import "FXNeedsPublishController.h"
#import "ChooseImageCell.h"
#import "ShowImageViewController.h"

@interface FXNeedsDetailController ()<UITableViewDelegate,UITableViewDataSource,FXUploadPhotoControllerDelegate,FXNeedsPublishControllerDelegate,ChooseImageCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) ChooseImageCell *chooseImageCell;
@property (nonatomic, copy) NSString *needsTitle;//项目名称
@property (nonatomic, copy) NSString *needsRequire;//项目要求
@property (nonatomic, copy) NSString *needsType;//项目类型
@property (nonatomic, copy) NSString *needsMoney;//项目经费
@property (nonatomic, copy) NSString *needsArea;//项目地区
@property (nonatomic, copy) NSString *wageId;//工资支付人
@property (nonatomic, copy) NSString *proportionId;//支付比例

@property (nonatomic, copy) NSString *statusStr;//0需求待审核 1需求未通过 2需求已通过 6任务执行中 7任务已停止 8任务已完成
@property (nonatomic, copy) NSString *cerStatus;//3凭证待审核 4凭证未通过 5凭证已通过

@property (nonatomic, copy) NSString *typeId;//类型id

@end

@implementation FXNeedsDetailController

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];

    }
    return self;
}

- (void)getNeedsData{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=get.demandDetail"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"demandid":self.needsId};
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            
            self.needsTitle = [NSString stringWithFormat:@"%@", tempDic[@"projectName"]];
            self.needsRequire = [NSString stringWithFormat:@"%@", tempDic[@"explain"]];
            self.wageId = [NSString stringWithFormat:@"%@", tempDic[@"payer"]];
            self.proportionId = [NSString stringWithFormat:@"%@", tempDic[@"ratio"]];
            self.needsType = [NSString stringWithFormat:@"%@", tempDic[@"typeStr"]];
            self.needsMoney = [NSString stringWithFormat:@"%@", tempDic[@"fund"]];
            self.statusStr = [NSString stringWithFormat:@"%@", tempDic[@"status"]];
            self.typeId = [NSString stringWithFormat:@"%@", tempDic[@"type"]];
            self.cerStatus = [NSString stringWithFormat:@"%@", tempDic[@"certificate"]];
            NSArray *idArray = [tempDic[@"citys"] componentsSeparatedByString:@"@"];//:截取
            NSArray *titleArray = tempDic[@"citysArr"];
            for (NSInteger i = 0; i < idArray.count; i++) {
                FXListModel *model = [[FXListModel alloc]init];
                model.linkID = [NSString stringWithFormat:@"%@", idArray[i]];
                model.title = [NSString stringWithFormat:@"%@", titleArray[i]];
                [self.dataArray addObject:model];
            }
            NSArray *imageArray = tempDic[@"paymentImg"];
            for (NSDictionary *dic in imageArray) {
                [self.imageArray addObject:dic[@"url"]];
            }
            [self.view addSubview:self.tableView];
            [self setUpBottomView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"需求详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self getNeedsData];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView{
    if (!_tableView) {
        if ([self.cerStatus isEqualToString:@""]) {
            if ([self.statusStr isEqualToString:@"1"] || [self.statusStr isEqualToString:@"2"]) {//需求未通过 需求通过未上传凭证
                _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
            }else{
                _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
            }
        }else if ([self.cerStatus isEqualToString:@"4"]){//凭证未通过
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
        }else if ([self.cerStatus isEqualToString:@"3"] || [self.cerStatus isEqualToString:@"5"]){//凭证待审核 凭证通过
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        [_tableView setShowsVerticalScrollIndicator:NO];

    }
    return _tableView;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 280)];
        _headView.backgroundColor = kUIColorFromRGB(0xffffff);
        
        //项目名称
        UILabel *titleTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 70)];
        titleTipLabel.text = @"项目名称";
        titleTipLabel.textColor = kUIColorFromRGB(0x404040);
        titleTipLabel.textAlignment = NSTextAlignmentLeft;
        titleTipLabel.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:titleTipLabel];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleTipLabel.frame) + 10, 0, self.view.frame.size.width - titleTipLabel.frame.size.width - 30, 70)];
        titleLabel.text = self.needsTitle;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [_headView addSubview:titleLabel];
        
        UIView *lineFirView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleTipLabel.frame), self.view.frame.size.width, 1)];
        lineFirView.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineFirView];
        
        //项目要求
        UILabel *requireTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineFirView.frame), 100, 70)];
        requireTipLabel.text = @"项目执行要求";
        requireTipLabel.textColor = kUIColorFromRGB(0x404040);
        requireTipLabel.textAlignment = NSTextAlignmentLeft;
        requireTipLabel.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:requireTipLabel];
        
        //动态计算要求的高度
        CGSize requireSize = [self.needsRequire sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(self.view.frame.size.width - requireTipLabel.frame.size.width - 30, CGFLOAT_MAX)];
        UILabel *requireLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(requireTipLabel.frame) + 10, CGRectGetMaxY(lineFirView.frame), self.view.frame.size.width - requireTipLabel.frame.size.width - 30, requireSize.height + 50)];
        requireLabel.text = self.needsRequire;
        requireLabel.textColor = [UIColor grayColor];
        requireLabel.textAlignment = NSTextAlignmentRight;
        requireLabel.font = [UIFont systemFontOfSize:14];
        requireLabel.numberOfLines = 0;
        requireLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_headView addSubview:requireLabel];
        
        //set backView的高度
        if ([_wageId integerValue] == 1 || [ZQ_CommonTool isEmpty:_wageId] || [_wageId integerValue] == 0) {
            _headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 70 * 4 + 4 + requireSize.height + 50);
        } else if ([_wageId integerValue] == 2) {
            _headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 70 * 5 + 5 + requireSize.height + 50);
        }
        UIView *lineSecView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(requireLabel.frame), self.view.frame.size.width, 1)];
        lineSecView.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineSecView];
        
        //项目类型
        UILabel *typeTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineSecView.frame), 100, 70)];
        typeTipLabel.text = @"项目类型";
        typeTipLabel.textColor = kUIColorFromRGB(0x404040);
        typeTipLabel.textAlignment = NSTextAlignmentLeft;
        typeTipLabel.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:typeTipLabel];
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeTipLabel.frame) + 10, CGRectGetMaxY(lineSecView.frame), self.view.frame.size.width - typeTipLabel.frame.size.width - 30, 70)];
        typeLabel.text = self.needsType;
        typeLabel.textColor = [UIColor grayColor];
        typeLabel.textAlignment = NSTextAlignmentRight;
        typeLabel.font = [UIFont systemFontOfSize:14];
        [_headView addSubview:typeLabel];
        
        UIView *lineThiView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(typeTipLabel.frame), self.view.frame.size.width, 1)];
        lineThiView.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineThiView];
        
        //项目预算经费
        UILabel *moneyTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineThiView.frame), 100, 70)];
        moneyTipLabel.text = @"项目预算经费";
        moneyTipLabel.textColor = kUIColorFromRGB(0x404040);
        moneyTipLabel.textAlignment = NSTextAlignmentLeft;
        moneyTipLabel.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:moneyTipLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyTipLabel.frame) + 10, CGRectGetMaxY(lineThiView.frame), self.view.frame.size.width - moneyTipLabel.frame.size.width - 30, 70)];
        moneyLabel.text = [self.needsMoney stringByAppendingString:@"元"];
        moneyLabel.textColor = [UIColor grayColor];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = [UIFont systemFontOfSize:14];
        [_headView addSubview:moneyLabel];
     //////////////////////
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyTipLabel.frame), self.view.frame.size.width, 1)];
        lineView1.backgroundColor = kUIColorFromRGB(0xededed);
        [_headView addSubview:lineView1];
        
        //项目预算经费
        UILabel *wageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView1.frame), 100, 70)];
        wageLabel.text = @"工资支付人";
        wageLabel.textColor = kUIColorFromRGB(0x404040);
        wageLabel.textAlignment = NSTextAlignmentLeft;
        wageLabel.font = [UIFont systemFontOfSize:15];
        [_headView addSubview:wageLabel];
        
        UILabel *wageLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wageLabel.frame) + 10, CGRectGetMaxY(lineView1.frame), self.view.frame.size.width - wageLabel.frame.size.width - 30, 70)];
        if ([_wageId integerValue] == 1 || [ZQ_CommonTool isEmpty:_wageId] || [_wageId integerValue] == 0) {
            wageLabel1.text = @"平台垫支付";
        } else if ([_wageId integerValue] == 2) {
            wageLabel1.text = @"企业自己支付";
        }
        wageLabel1.textColor = [UIColor grayColor];
        wageLabel1.textAlignment = NSTextAlignmentRight;
        wageLabel1.font = [UIFont systemFontOfSize:14];
        [_headView addSubview:wageLabel1];
        /////////////////
        if ([_wageId integerValue] == 2) {
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(wageLabel.frame), self.view.frame.size.width, 1)];
            lineView2.backgroundColor = kUIColorFromRGB(0xededed);
            [_headView addSubview:lineView2];
            
            //项目预算经费
            UILabel *proportionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView2.frame), 140, 70)];
            proportionLabel.text = @"平台加收服务费率";
            proportionLabel.textColor = kUIColorFromRGB(0x404040);
            proportionLabel.textAlignment = NSTextAlignmentLeft;
            proportionLabel.font = [UIFont systemFontOfSize:15];
            [_headView addSubview:proportionLabel];
            
            UILabel *proportionLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(proportionLabel.frame) + 10, CGRectGetMaxY(lineView2.frame), self.view.frame.size.width - proportionLabel.frame.size.width - 30, 70)];
            proportionLabel1.text = [_proportionId stringByAppendingString:@"%"];
            proportionLabel1.textColor = [UIColor grayColor];
            proportionLabel1.textAlignment = NSTextAlignmentRight;
            proportionLabel1.font = [UIFont systemFontOfSize:14];
            [_headView addSubview:proportionLabel1];
        }
    }
    return _headView;
}

- (void)setUpBottomView{
    //底部按钮
    if ([self.statusStr isEqualToString:@"0"] || [self.cerStatus isEqualToString:@"3"] || [self.cerStatus isEqualToString:@"5"]) {//审核中
        
    }else{
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- 50, self.view.frame.size.width, 50)];
        bottomView.backgroundColor = kUIColorFromRGB(0xffffff);
        [self.view addSubview:bottomView];
        if ([self.cerStatus isEqualToString:@""]) {
            if ([self.statusStr isEqualToString:@"1"]) {//需求未通过
                UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
                delButton.frame = CGRectMake(10, 5, self.view.frame.size.width / 2 - 20, 40);
                delButton.layer.cornerRadius = 5;
                delButton.backgroundColor = MainColor;
                [delButton setTitle:@"删除需求" forState:UIControlStateNormal];
                [delButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [delButton addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
                delButton.titleLabel.font = [UIFont systemFontOfSize:16];
                [bottomView addSubview:delButton];
                
                UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                changeButton.frame = CGRectMake(CGRectGetMaxX(delButton.frame) + 20, 5, self.view.frame.size.width / 2 - 20, 40);
                changeButton.layer.cornerRadius = 5;
                changeButton.backgroundColor = MainColor;
                [changeButton setTitle:@"修改需求" forState:UIControlStateNormal];
                [changeButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                changeButton.titleLabel.font = [UIFont systemFontOfSize:16];
                [bottomView addSubview:changeButton];
                
            }else if ([self.statusStr isEqualToString:@"2"]){//需求通过未上传凭证
                UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
                uploadButton.frame = CGRectMake(10, 5, self.view.frame.size.width - 20, 40);
                uploadButton.layer.cornerRadius = 5;
                uploadButton.backgroundColor = MainColor;
                [uploadButton setTitle:@"上传付款凭证" forState:UIControlStateNormal];
                [uploadButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [uploadButton addTarget:self action:@selector(uploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
                uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
                [bottomView addSubview:uploadButton];
                
            }
        }else if([self.cerStatus isEqualToString:@"4"]){
            UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            delButton.frame = CGRectMake(10, 5, self.view.frame.size.width / 2 - 20, 40);
            delButton.layer.cornerRadius = 5;
            delButton.backgroundColor = MainColor;
            [delButton setTitle:@"删除需求" forState:UIControlStateNormal];
            [delButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [delButton addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
            delButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:delButton];
            
            UIButton *reUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            reUploadButton.frame = CGRectMake(CGRectGetMaxX(delButton.frame) + 20, 5, self.view.frame.size.width / 2 - 20, 40);
            reUploadButton.layer.cornerRadius = 5;
            reUploadButton.backgroundColor = MainColor;
            [reUploadButton setTitle:@"重新上传付款凭证" forState:UIControlStateNormal];
            [reUploadButton setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [reUploadButton addTarget:self action:@selector(reUploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
            reUploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:reUploadButton];

        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![ZQ_CommonTool isEmptyArray:self.imageArray]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return _chooseImageCell.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        backView.backgroundColor = [UIColor clearColor];
        
        return backView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ChooseImageCell *cell = [ChooseImageCell cellWithTableView:tableView];
        _chooseImageCell = cell;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.nameLabel.text = @"付款凭证";
        [cell.imageArray removeAllObjects];
        if (![ZQ_CommonTool isEmptyArray:self.imageArray]) {
            [cell.imageArray addObjectsFromArray:self.imageArray];
        }
        [cell readOnlyMakeView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;

    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"needsPublishCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"needsPublishCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = kUIColorFromRGB(0x404040);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [NSString stringWithFormat:@"执行区域%d",indexPath.row + 1];
    FXListModel *model = _dataArray[indexPath.row];
    cell.detailTextLabel.text = model.title;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

//删除
- (void)delButtonClick{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.delDemand"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"uid":userModel.userID,
                          @"demandid":self.needsId
                            };
    [weakSelf showHudInView:weakSelf.view hint:@"删除中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(detailChangeStatus)]) {
                [weakSelf.delegate detailChangeStatus];
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}
//修改
- (void)changeButtonClick{
    FXNeedsPublishController *pubVc = [[FXNeedsPublishController alloc]init];
    pubVc.title = @"修改需求";
    pubVc.delegate = self;
    pubVc.titleStr = self.needsTitle;
    pubVc.requireStr = self.needsRequire;
    pubVc.typeId = self.typeId;
    pubVc.typeStr = self.needsType;
    pubVc.moneyNum = self.needsMoney;
    pubVc.dataArray = self.dataArray;
    pubVc.needId = self.needsId;
    if (![ZQ_CommonTool isEmpty:_wageId] && [_wageId integerValue] != 0) {
        if ([_wageId integerValue] == 1) {
            pubVc.wageStr = @"平台垫支付";
        } else if ([_wageId integerValue] == 2) {
            pubVc.wageStr = @"企业自己支付";
        }
        pubVc.wageId = _wageId;
    }
    if (![ZQ_CommonTool isEmpty:_proportionId] && [_proportionId integerValue] != 0) {
        pubVc.proportionId = _proportionId;
        pubVc.proportionStr = [_proportionId stringByAppendingString:@"%"];
    }
    [self.navigationController pushViewController:pubVc animated:YES];
}

//上传凭证
- (void)uploadButtonClick{
    FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
    upVc.tipStr = @"付款凭证照片上传(最多4张)";
    upVc.title = @"上传付款凭证";
    upVc.dataID = self.needsId;
    upVc.delegate = self;
    [self.navigationController pushViewController:upVc animated:YES];
}
- (void)uploadSuccess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailChangeStatus)]) {
        [self.delegate detailChangeStatus];
    }
}
- (void)publishSuccessReloadList{
    [self uploadSuccess];
}
//重新上传凭证
- (void)reUploadButtonClick{
    FXUploadPhotoController *upVc = [[FXUploadPhotoController alloc]init];
    upVc.tipStr = @"付款凭证照片上传(最多4张)";
    upVc.title = @"重新上传付款凭证";
    upVc.dataID = self.needsId;
    upVc.delegate = self;
    [self.navigationController pushViewController:upVc animated:YES];
}

#pragma mark - ChooseImageCellDelegate
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:self.imageArray];
    [vc seleImageLocation:tag];
    pushToControllerWithAnimated(vc)
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
