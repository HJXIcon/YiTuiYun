//
//  CancelTaskViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/19.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "CancelTaskViewController.h"
#import "InputTextFieldViewController.h"
#import "InputTextViewController.h"
#import "CancelTaskCell.h"

@interface CancelTaskViewController ()<UITableViewDataSource,UITableViewDelegate,InputTextFieldViewControllerDelegate,UIActionSheetDelegate,InputTextViewControllerDelegate>
/** 主视图 */
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,copy) NSString *dataId;
@property (nonatomic,assign) NSInteger where;
@property (nonatomic,copy) NSString *nameStr;//名称
@property (nonatomic,copy) NSString *natureStr;//性质
@property (nonatomic,copy) NSString *natureId;//性质id
@property (nonatomic,copy) NSString *reasonStr;//原因
@property (nonatomic,strong) NSMutableArray *natureArray;//性质array
@end

@implementation CancelTaskViewController
- (instancetype)initWithDataId:(NSString *)dataId WithTaskName:(NSString *)taskName With:(NSInteger)where{
    self = [super init];
    if (self) {
        self.dataId = dataId;
        self.where = where;
        self.natureArray = [NSMutableArray arrayWithObjects:@{@"name":@"全职",@"natureId":@"1"},@{@"name":@"兼职",@"natureId":@"2"},@{@"name":@"校园兼职",@"natureId":@"3"}, nil];
        self.nameStr = taskName;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setUpTableView];
}

#pragma mark 提交
- (void)submitFromNetwork {
    
    __weak CancelTaskViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = _dataId;
    params[@"memberid"] = infoModel.userID;
    params[@"status"] = @"3";
    params[@"jobType"] = _natureId;
    if (![ZQ_CommonTool isEmpty:_reasonStr]) {
        params[@"reason"] = _reasonStr;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.taskStatus"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"您成功申请取消任务，在正式取消前您可继续任务"
                         customizationBlock:^(WCAlertView *alertView) {
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     if (_where == 1) {
                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                     } else {
                         [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                     }
                 }
             } cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"取消任务";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItem
{
    if ([ZQ_CommonTool isEmpty:_nameStr] || [ZQ_CommonTool isEmpty:_natureStr]) {
        [ZQ_UIAlertView showMessage:@"请完善取消任务相关的信息" cancelTitle:@"确定"];
        return;
    } else {
        [self submitFromNetwork];
    }
}

-(void)setUpTableView{
    //初始化 tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CancelTaskCell *cell = [CancelTaskCell cellWithTableView:tableView];

    if (indexPath.section == 0) {
        cell.nameLabel.text = @"任务名称";
        cell.textField.placeholder = @"请输入任务名称";
        cell.textField.text = _nameStr;
    } else if (indexPath.section == 1) {
        cell.nameLabel.text = @"职业性质";
        cell.textField.placeholder = @"请选择职业性质";
        cell.textField.text = _natureStr;
    } else if (indexPath.section == 2) {
        cell.nameLabel.text = @"取消任务原因";
        cell.textField.placeholder = @"请输入取消原因";
        cell.textField.text = _reasonStr;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([ZQ_CommonTool isEmpty:_nameStr]) {
            InputTextFieldViewController *vc = [[InputTextFieldViewController alloc] initWithTitle:@"任务名称"];
            vc.delegate = self;
            vc.index = indexPath;
            pushToControllerWithAnimated(vc)
        }
    } else if (indexPath.section == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全职", @"兼职", @"校园兼职", nil];
        [actionSheet showInView:self.view];
    } else if (indexPath.section == 2) {
        InputTextViewController *vc = [[InputTextViewController alloc] initWithTitle:@"取消原因" WithDesc:_reasonStr];
        vc.delegate = self;
        vc.index = indexPath.section;
        pushToControllerWithAnimated(vc)
    }
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - InputTextFieldViewControllerDelegate
- (void)inputTextFieldString:(NSString *)string WithIndex:(NSIndexPath *)index
{
    if (index.section == 0) {
        _nameStr = string;
    }
    [_tableView reloadData];
}

#pragma mark - InputTextViewControllerDelegate
- (void)inputTextViewString:(NSString *)string WithIndex:(NSInteger)index
{
    if (index == 2) {
        _reasonStr = string;
    }
    
    [_tableView reloadData];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex >= 0 && buttonIndex <= 2){
        NSDictionary *dic = _natureArray[buttonIndex];
        _natureStr = dic[@"name"];
        _natureId = dic[@"natureId"];
        [_tableView reloadData];
    }
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
