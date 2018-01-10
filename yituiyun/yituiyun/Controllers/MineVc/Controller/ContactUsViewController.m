//
//  ContactUsViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ContactUsCell.h"
#import "ContactUsModel.h"
#import "ComplaintsViewController.h"
#import <MessageUI/MessageUI.h>

@interface ContactUsViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ContactUsModel *contactUsModel;

@end

@implementation ContactUsViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray arrayWithObjects:@{@"image":@"feedback",@"title":@"意见反馈"}, @{@"image":@"hotline",@"title":@"服务热线"}, @{@"image":@"email",@"title":@"服务邮箱"}, nil];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactUsModel = [[ContactUsModel alloc] init];
    [self setupNav];
    [self setupTableView];
    [self dataArrayFromNetwork];
    
    
//    [[BMPLbs shareManger] startLocation:^(BMKReverseGeoCodeResult *reslut) {
//        NSLog(@"----------%@------%@",reslut.addressDetail.city,reslut.poiList);
//    }];
}

#pragma mark 请求网络数据
- (void)dataArrayFromNetwork {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak ContactUsViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"f"] = @"serviceHotline,serviceEmail,serviceTime";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=data.contents"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        self.contactUsModel.serviceHotline = [NSString stringWithFormat:@"%@", responseObject[@"serviceHotline"]];
        self.contactUsModel.serviceEmail = [NSString stringWithFormat:@"%@", responseObject[@"serviceEmail"]];
        self.contactUsModel.serviceTime = [NSString stringWithFormat:@"%@", responseObject[@"serviceTime"]];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)setupNav{
    self.title = @"联系我们";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataArray.count - 1 == section) {
        return 150;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArray.count - 1 == section) {
        UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 150)];
        view.backgroundColor = [UIColor clearColor];
        
        UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(15, 20, ZQ_Device_Width - 30, 100)];
        view1.backgroundColor = kUIColorFromRGB(0xf8f8f8);
        [view addSubview:view1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(view1.frame), 25)];
        label.text = @"服务时间";
        label.textColor = kUIColorFromRGB(0x808080);
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [view1 addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), CGRectGetWidth(view1.frame) - 40, CGRectGetHeight(view1.frame) - 45)];
        label1.text = [NSString stringWithFormat:@"北京时间%@(周一至周日，法定节假日除外)。若您发送邮件，客服将在一个工作日内通过邮件回复。", _contactUsModel.serviceTime];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = kUIColorFromRGB(0x808080);
        label1.numberOfLines = 0;
        label1.textAlignment = NSTextAlignmentLeft;
        [view1 addSubview:label1];
        
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactUsCell *cell = [ContactUsCell cellWithTableView:tableView];
    NSDictionary *dic = _dataArray[indexPath.section];
    cell.leftImage.image = [UIImage imageNamed:dic[@"image"]];
    cell.titleLabel.text = dic[@"title"];
    
    if (indexPath.section == 1) {
        cell.detaiLabel.text = self.contactUsModel.serviceHotline;
    } else if (indexPath.section == 2) {
        cell.detaiLabel.text = self.contactUsModel.serviceEmail;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ComplaintsViewController *vc = [[ComplaintsViewController alloc] init];
        pushToControllerWithAnimated(vc)
    } else if (indexPath.section == 1) {
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"您确定给客服拨打电话吗？"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_contactUsModel.serviceHotline]]];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
    } else if (indexPath.section == 2) {
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"您确定给平台发送邮件吗？"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [self send];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"发邮件", nil];
    }
}

- (void)send{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if (controller) {  // 如果没有设置邮件帐户，mailController 为nil
        [controller setToRecipients:@[_contactUsModel.serviceEmail]];
        [controller setSubject:@"易推云-意见反馈"];
        [controller setMessageBody:model.nickname isHTML:NO];
        controller.mailComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
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
