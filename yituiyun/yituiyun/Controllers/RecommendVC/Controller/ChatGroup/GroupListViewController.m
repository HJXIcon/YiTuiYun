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

#import "GroupListViewController.h"

#import "BaseTableViewCell.h"
#import "ChatViewController.h"
#import "PublicGroupListViewController.h"
#import "RealtimeSearchUtil.h"
#import "RedPacketChatViewController.h"

#import "UIViewController+SearchController.h"

@interface GroupListViewController ()<EMSearchControllerDelegate,EMGroupManagerDelegate,EaseUserCellDelegate,UIActionSheetDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isManager;
@end

@implementation GroupListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    self.title = @"群组";
    self.showRefreshHeader = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self setupSearchController];
    
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [self reloadDataSource];
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.tableViewTag = 1;
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.avatarView.imageCornerRadius = 3;
            cell.avatarView.image = [UIImage imageNamed:@"group_joinpublicgroup"];
            cell.titleLabel.text = @"公开群";
        }
    } else {
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        cell.avatarView.imageCornerRadius = 15;
        cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
        if (![ZQ_CommonTool isEmpty:group.subject]) {
            cell.titleLabel.text = group.subject;
        } else {
            cell.titleLabel.text = group.groupId;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self showPublicGroupList];
        }
    } else {
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];

//        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        chatController.title = group.subject;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - EaseUserCellDelegate
- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath WithTableViewTag:(NSInteger)tableViewTag
{
    if (tableViewTag == 1) {
        if (indexPath.section == 0) {
            return;
        }
        
        _currentLongPressIndex = indexPath;
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        NSString *loginName = [[EMClient sharedClient] currentUsername];
        if ([group.owner isEqualToString:loginName]) {
            _isManager = YES;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解散群组" otherButtonTitles:nil, nil];
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        } else {
            _isManager = NO;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出群组" otherButtonTitles:nil, nil];
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex || _currentLongPressIndex == nil) {
        return;
    }
    
    NSIndexPath *indexPath = _currentLongPressIndex;
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    _currentLongPressIndex = nil;
    
    [self showHudInView:self.view hint:@"请等待..."];
    __weak GroupListViewController *weakSelf = self;
    if (_isManager == YES) {
        [[EMClient sharedClient].groupManager destroyGroup:group.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                [weakSelf hideHud];
                [weakSelf.tableView beginUpdates];
                [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf.tableView endUpdates];
            }
            else{
                [weakSelf hideHud];
                [weakSelf showHint:[NSString stringWithFormat:@"解散失败:%@", aError.errorDescription]];
                [weakSelf.tableView reloadData];
            }
        }];

    } else {
        [[EMClient sharedClient].groupManager leaveGroup:group.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                [weakSelf hideHud];
                [weakSelf.tableView beginUpdates];
                [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf.tableView endUpdates];
            }
            else{
                [weakSelf hideHud];
                [weakSelf showHint:[NSString stringWithFormat:@"退出失败:%@", aError.errorDescription]];
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    return contentView;
}

#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:groupList];
    [self.tableView reloadData];
}
                                                       
#pragma mark - EMSearchControllerDelegate
                                                       
- (void)willSearchBegin
{
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}
                                                       
- (void)cancelButtonClicked
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
}
                                               
- (void)searchTextChangeWithString:(NSString *)aString
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:aString collationStringSelector:@selector(subject) resultBlock:^(NSArray *results) {
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
    
    __weak GroupListViewController *weakSelf = self;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *CellIdentifier = @"ContactListCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        EMGroup *group = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.tableViewTag = 2;
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

        EMGroup *group = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        RedPacketChatViewController *chatVC = [[RedPacketChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];

//        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        chatVC.title = group.subject;
        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                                               
        [weakSelf cancelSearch];
    }];
    
    UISearchBar *searchBar = self.searchController.searchBar;
    self.tableView.tableHeaderView = searchBar;
}
                                                       
#pragma mark - data
                                                       
- (void)tableViewDidTriggerHeaderRefresh
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *groups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:groups];
                [weakself.tableView reloadData];
            }
            
            [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
        });
    });
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSArray *rooms = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:nil];
    [self.dataSource addObjectsFromArray:rooms];
    
    [self.tableView reloadData];
}

#pragma mark - action

- (void)showPublicGroupList
{
    PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] init];
    [self.navigationController pushViewController:publicController animated:YES];
}

@end
