//
//  ChatPersonnelListViewController.m
//  yituiyun
//
//  Created by 张强 on 2016/12/11.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ChatPersonnelListViewController.h"
#import "MineTableViewCell.h"
#import "FXPersonDetailController.h"
#import "FXCompanyDetailController.h"

@interface ChatPersonnelListViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, copy) NSString *groupManager;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSIndexPath *currentLongPressIndex;

@end

@implementation ChatPersonnelListViewController
- (instancetype)initWithConversationId:(NSString *)conversationId
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
        self.conversationId = conversationId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群组成员";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    [self getGroupPersonnel];
    [self setupTableView];
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getGroupPersonnel{
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:self.conversationId includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            if (aGroup) {
                self.groupType = aGroup.setting.style;
                self.groupManager = aGroup.owner;
                if (aGroup.occupants) {
                    [self userAvatars:aGroup.occupants];
                }
            }
        }
    }];
}

- (void)userAvatars:(NSArray *)array
{
    __weak typeof(self) weakself = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSString *uids = nil;
    for (NSString *string in array) {
        if ([ZQ_CommonTool isEmpty:uids]) {
            uids = [NSString stringWithFormat:@"%@", string];
        } else {
            uids = [NSString stringWithFormat:@"%@,%@", uids, string];
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uids"] = uids;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.avatars"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakself hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:@"rst"];
            if (![ZQ_CommonTool isEmptyDictionary:dic]) {
                for (NSString *string in array) {
                    NSDictionary *infoDic = responseObject[@"rst"][string];
                    if (![ZQ_CommonTool isEmptyDictionary:infoDic]) {
                        [ZQ_AppCache saveUserFriendInfo:infoDic WithName:string];
                        [_dataArray addObject:infoDic];
                    }
                }
                [_tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself hideHud];
        [weakself showHint:@"加载失败，请检查网络"];
    }];
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
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *const identifier = @"ChatPersonnelList";
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _dataArray[indexPath.section];
    cell.redView.hidden = YES;
    cell.lineView.hidden = YES;
    cell.leftImage.frame = ZQ_RECT_CREATE(12, 8, 34, 34);
    [[cell.leftImage layer] setCornerRadius:17];
    [[cell.leftImage layer] setMasksToBounds:YES];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, dic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"EaseUIResource.bundle/user"]];
    if ([self.groupManager isEqualToString:dic[@"uid"]]) {
        UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
        if ([userInfoModel.identity isEqualToString:@"6"]) {
            if (self.groupType == EMGroupStylePublicJoinNeedApproval) {
                cell.titleLabel.text = [NSString stringWithFormat:@"群主-%@",dic[@"nickname"]];
            } else {
                cell.titleLabel.text = [NSString stringWithFormat:@"项目主管-%@",dic[@"nickname"]];
            }
        } else if ([userInfoModel.identity isEqualToString:@"5"]) {
            if (self.groupType == EMGroupStylePublicJoinNeedApproval) {
                cell.titleLabel.text = [NSString stringWithFormat:@"群主-%@",dic[@"nickname"]];
            } else {
                cell.titleLabel.text = [NSString stringWithFormat:@"发起人-%@",dic[@"nickname"]];
            }
        }
    } else {
        cell.titleLabel.text = dic[@"nickname"];
    }
    cell.titleLabel.frame = ZQ_RECT_CREATE(CGRectGetMaxX(cell.leftImage.frame) + 10, 0, ZQ_Device_Width - CGRectGetMaxX(cell.leftImage.frame) - 30, 50);
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.section];
    if ([dic[@"uModelid"] integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:dic[@"uid"]];
        pushToControllerWithAnimated(detailVc)
    } else if ([dic[@"uModelid"] integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:dic[@"uid"]];
        pushToControllerWithAnimated(vc)
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];

    if ([model.userID integerValue] == [self.groupManager integerValue]) {
        
        return YES;
    }
    
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.section];
    [self showHudInView:self.view hint:@"加载中..."];
    __weak ChatPersonnelListViewController *weakSelf = self;
    [[EMClient sharedClient].groupManager removeMembers:@[dic[@"uid"]] fromGroup:self.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
        [weakSelf hideHud];
        if (!aError) {
            [_tableView beginUpdates];
            [_dataArray removeObject:dic];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            [ZQ_CallMethod setupNewMessageBoxCount];
        }
    }];
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
