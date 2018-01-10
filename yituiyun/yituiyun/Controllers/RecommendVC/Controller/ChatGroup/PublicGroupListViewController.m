/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "PublicGroupListViewController.h"

#import "PublicGroupDetailViewController.h"
#import "RealtimeSearchUtil.h"
#import "BaseTableViewCell.h"

#import "UIViewController+SearchController.h"

#define FetchPublicGroupsPageSize   50

@interface PublicGroupListViewController ()<EMSearchControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *cursor;

@property (strong, nonatomic) EMGroup *seleGroup;

@end

@implementation PublicGroupListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    self.title = @"公开群";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [self.view addSubview:_tableView];
    
    [_tableView setHeadRefreshWithTarget:self withAction:@selector(tableViewDidTriggerHeaderRefresh)];
    [_tableView setFootRefreshWithTarget:self withAction:@selector(tableViewDidTriggerFooterRefresh)];
    
    [self setupSearchController];
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EMGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    cell.avatarView.imageCornerRadius = 15;
    cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
    if (![ZQ_CommonTool isEmpty:group.subject]) {
        cell.titleLabel.text = group.subject;
    } else {
        cell.titleLabel.text = group.groupId;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    [self joinAction:group];
}

#pragma mark - EMSearchControllerDelegate

- (void)willSearchBegin
{
    [_tableView endRefreshing];
}

- (void)cancelButtonClicked
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
}

- (void)didSearchFinish
{
    if ([self.resultController.displaySource count]) {
        return;
    }
    
    UISearchBar *searchBar = self.searchController.searchBar;
    __block EMGroup *foundGroup= nil;
    [self.dataArray enumerateObjectsUsingBlock:^(EMGroup *group, NSUInteger idx, BOOL *stop){
        if ([group.groupId isEqualToString:searchBar.text]) {
            foundGroup = group;
            *stop = YES;
        }
    }];
    
    if (foundGroup) {
        [self.resultController.displaySource removeAllObjects];
        [self.resultController.displaySource addObject:foundGroup];
        [self.resultController.tableView reloadData];
    } else {
        __weak typeof(self) weakSelf = self;
        [self showHudInView:self.view hint:@"搜索中..."];
        dispatch_async(dispatch_get_main_queue(), ^{
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager searchPublicGroupWithId:searchBar.text error:&error];
            PublicGroupListViewController *strongSelf = weakSelf;
            [strongSelf hideHud];
            if (strongSelf) {
                if (!error) {
                    [strongSelf.resultController.displaySource removeAllObjects];
                    [strongSelf.resultController.displaySource addObject:group];
                    [strongSelf.resultController.tableView reloadData];
                } else {
                    [strongSelf showHint:@"没有搜索到相应的群组"];
                }
            }
        });
    }
}

- (void)searchTextChangeWithString:(NSString *)aString
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(subject) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.resultController.displaySource removeAllObjects];
                [weakSelf.resultController.displaySource addObjectsFromArray:results];
                [weakSelf.resultController.tableView reloadData];
            });
        }
    }];
}

#pragma mark - private

- (void)setupSearchController
{
    [self enableSearchController];
    
    __weak PublicGroupListViewController *weakSelf = self;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *CellIdentifier = @"ContactListCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        EMGroup *group = [weakSelf.resultController.displaySource objectAtIndex:indexPath.section];
        cell.avatarView.imageCornerRadius = 15;
        cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
        if (![ZQ_CommonTool isEmpty:group.subject]) {
            cell.titleLabel.text = group.subject;
        } else {
            cell.titleLabel.text = group.groupId;
        }
        
        return cell;
    }];
    
    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return 50;
    }];
    
    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [weakSelf.searchController.searchBar endEditing:YES];
        
        EMGroup *group = [weakSelf.resultController.displaySource objectAtIndex:indexPath.section];
        //        PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
        //        detailController.title = group.subject;
        //        [weakSelf.navigationController pushViewController:detailController animated:YES];
        
        [self joinAction:group];
        
        [weakSelf cancelSearch];
    }];
    
    UISearchBar *searchBar = self.searchController.searchBar;
    self.tableView.tableHeaderView = searchBar;
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    [self fetchGroups:YES];
}

- (void)tableViewDidTriggerFooterRefresh
{
    [self fetchGroups:NO];
}

- (void)fetchGroups:(BOOL)aIsHeader
{
    [_tableView endRefreshing];
    
    [self hideHud];
    [self showHudInView:self.view hint:@"加载中..."];
    
    if (aIsHeader) {
        _cursor = nil;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMCursorResult *result = [[EMClient sharedClient].groupManager getPublicGroupsFromServerWithCursor:_cursor pageSize:20 error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                NSMutableArray *array = [NSMutableArray array];
                for (EMGroup *gr in result.list) {
                    EMError *newError = nil;
                    EMGroup *NewGroup = [[EMClient sharedClient].groupManager fetchGroupInfo:gr.groupId includeMembersList:NO error:&newError];
                    if (!newError) {
                        [array addObject:NewGroup];
                    }
                }
                [self userAvatars:array with:aIsHeader With:result.cursor];
                
            } else {
                [self hideHud];
                [self showHint:@"加载失败，请检查网络"];
            }
        });
    });
}

- (void)userAvatars:(NSMutableArray *)array with:(BOOL)aIsHeader With:(NSString *)cursor
{
    if (![ZQ_CommonTool isEmptyArray:array]) {
        __weak typeof(self) weakself = self;
        NSString *uids = nil;
        for (EMGroup *group in array) {
            if (![ZQ_CommonTool isEmpty:group.owner]) {
                if ([ZQ_CommonTool isEmpty:uids]) {
                    uids = [NSString stringWithFormat:@"%@", group.owner];
                } else {
                    uids = [NSString stringWithFormat:@"%@,%@", uids, group.owner];
                }
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
                    if (aIsHeader) {
                        [self.dataArray removeAllObjects];
                        _cursor = cursor;
                    } else {
                        if (![ZQ_CommonTool isEmpty:cursor] && [cursor integerValue] > 0) {
                            _cursor = cursor;
                        }
                    }
                    for (EMGroup *group in array) {
                        if (![ZQ_CommonTool isEmpty:group.owner]) {
                            NSDictionary *infoDic = responseObject[@"rst"][group.owner];
                            if (![ZQ_CommonTool isEmptyDictionary:infoDic]) {
                                [ZQ_AppCache saveUserFriendInfo:infoDic WithName:group.owner];
                                UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
                                if ([userInfo.identity integerValue] == 6) {
                                    if ([infoDic[@"uModelid"] integerValue] == 6) {
                                        [self.dataArray addObject:group];
                                    }
                                } else if ([userInfo.identity integerValue] == 5) {
                                    if ([infoDic[@"uModelid"] integerValue] == 5) {
                                        [self.dataArray addObject:group];
                                    }
                                }
                                
                            }
                        }
                    }
                }
                [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakself hideHud];
            [weakself showHint:@"加载失败，请检查网络"];
        }];
    }
}

- (void)joinAction:(EMGroup *)group
{
    self.seleGroup = nil;
    self.seleGroup = group;
    
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:group.groupId includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            if (aGroup) {
                BOOL isHave = NO;
                for (NSString *str in aGroup.occupants) {
                    if ([infoModel.userID isEqualToString:str]) {
                        isHave = YES;
                        break;
                    }
                }
                if (isHave == YES) {
                    [ZQ_UIAlertView showMessage:@"已经在群组里，不可重复加入" cancelTitle:@"确定"];
                } else {
                    if (group.setting.style == EMGroupStylePublicJoinNeedApproval) {
                        [self showMessageAlertView];
                    }
                    else if (group.setting.style == EMGroupStylePublicOpenJoin)
                    {
                        [self joinGroup:group.groupId];
                    }
                }
            }
        }
    }];
    
    
}

- (void)joinGroup:(NSString *)groupId
{
    [self showHudInView:self.view hint:@"加入群组中..."];
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient].groupManager joinPublicGroup:groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if(!error) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf showHint:@"加入群组失败"];
            }
        });
    });
}

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"打声招呼" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        //        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@", messageTextField.text];
        }
        [self applyJoinGroup:self.seleGroup.groupId withGroupname:self.seleGroup.subject message:messageStr];
    }
}

- (void)applyJoinGroup:(NSString *)groupId withGroupname:(NSString *)groupName message:(NSString *)message
{
    [self showHudInView:self.view hint:@"发送中..."];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient].groupManager applyJoinPublicGroup:groupId message:message error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                [weakSelf showHint:@"发送成功"];
            } else {
                [weakSelf showHint:error.errorDescription];
            }
        });
    });}

@end
