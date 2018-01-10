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

#import "ContactListViewController.h"
#import "BaseTableViewCell.h"
#import "RealtimeSearchUtil.h"
#import "EaseChineseToPinyin.h"
#import "EMSearchBar.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"

#import "AddFriendViewController.h"
#import "RedPacketChatViewController.h"

#import "UIViewController+SearchController.h"
#import "BlackListViewController.h"
#import "FXPersonDetailController.h"
#import "FXCompanyDetailController.h"
@interface ContactListViewController ()<UISearchBarDelegate, UIActionSheetDelegate, EaseUserCellDelegate, EMSearchControllerDelegate,BlackListViewControllerDelegate,ApplyViewControllerDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;//字母
@property (strong, nonatomic) NSMutableArray *contactsSource;//好友信息
@property (strong, nonatomic) NSMutableArray *searchDataSource;//搜索源
@property (strong, nonatomic) NSMutableArray *searchData;//搜索接收源
@property (strong, nonatomic) UITableView *searchTableView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) UILabel *label;

@property (nonatomic) NSInteger unapplyCount;

@property (nonatomic) NSIndexPath *indexPath;

@end

@implementation ContactListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
        self.contactsSource = [NSMutableArray array];
        self.sectionTitles = [NSMutableArray array];
        self.searchDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    self.tableView.sectionIndexColor = kUIColorFromRGB(0x808080);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height) style:UITableViewStylePlain];
    _searchTableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _searchTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _searchTableView.tag = 20;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.hidden = YES;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchTableView];
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 30)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"无结果";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = kUIColorFromRGB(0xd5d5d5);
    _label.font = [UIFont systemFontOfSize:15.f];
    _label.hidden = YES;
    [_searchTableView addSubview:_label];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (NSArray *)rightItems
{
    if (_rightItems == nil) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        _rightItems = @[addItem];
    }
    
    return _rightItems;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 20) {
        return 1;
    }
    return [self.dataArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 20) {
        return [self.searchDataSource count];
    }
    if (section == 0) {
        return 3;
    }
    
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 20) {
        static NSString *CellIdentifier = @"EaseUserCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.tableViewTag = 20;
        EaseUserModel *model = [self.searchDataSource objectAtIndex:indexPath.row];
        NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:model.buddy];
        if (dic) {
            model.nickname = nil ? model.buddy : dic[@"nickname"];
            model.avatarURLPath = [NSString stringWithFormat:@"%@%@", kHost, dic[@"avatar"]];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = model;
        cell.tableViewTag = 20;
        return cell;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.avatarView.imageCornerRadius = 3;
            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
            cell.titleLabel.text = @"申请与通知";
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        } else if (indexPath.row == 1) {
            NSString *CellIdentifier = @"commonCell";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.avatarView.imageCornerRadius = 3;
            cell.avatarView.image = [UIImage imageNamed:@"group1"];
            cell.titleLabel.text = @"群组";
            return cell;
        }
        
        NSString *CellIdentifier = @"blacklistCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.avatarView.imageCornerRadius = 3;
        cell.avatarView.image = [UIImage imageNamed:@"blacklist"];
        cell.titleLabel.text = @"黑名单";
        return cell;
    } else {
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
        NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:model.buddy];
        if (dic) {
            model.nickname = nil ? model.buddy : dic[@"nickname"];
            model.avatarURLPath = dic[@"avatar"];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        }
        cell.avatarView.imageCornerRadius = 15;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = model;
        cell.tableViewTag = 10;
        
        return cell;
    }}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag != 20) {
    return self.sectionTitles;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 20) {
        return 0.1;
    }
    if (section == 0)
    {
        return 0.0000001;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag != 20) {
        if (section == 0)
        {
            return nil;
        }
        
        UIView *contentView = [[UIView alloc] init];
        [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
        label.backgroundColor = [UIColor clearColor];
        [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
        [contentView addSubview:label];
        return contentView;
    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 20) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 20) {
        EaseUserModel *model = [self.searchDataSource objectAtIndex:indexPath.row];
        RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
        chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy;
        chatController.avatarURLPath = model.avatarURLPath;
        chatController.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:chatController animated:YES];
        [self searchBarCancelButtonClicked:_searchBar];
    } else {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (section == 0) {
            if (row == 0) {
                ApplyViewController *vc = [ApplyViewController shareController];
                vc.delegate = self;
                vc.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:vc animated:YES];
            } else if (row == 1) {
                GroupListViewController *groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
                groupController.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:groupController animated:YES];
            } else if (row == 2) {
                BlackListViewController *blackVC = [[BlackListViewController alloc] init];
                blackVC.delegate = self;
                blackVC.hidesBottomBarWhenPushed = YES;

                pushToControllerWithAnimated(blackVC)
            }
        } else {
            EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
            RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
            chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy;
            chatController.avatarURLPath = model.avatarURLPath;
            
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([model.buddy isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        self.indexPath = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除对话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.indexPath == nil)
    {
        return;
    }
    
    NSIndexPath *indexPath = self.indexPath;
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    self.indexPath = nil;
    
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.buddy];
        if (!error) {
            [self.tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.buddy];
            [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [ZQ_CallMethod setupNewMessageBoxCount];

        }
        else{
            [self showHint:[NSString stringWithFormat:@"删除失败:%@", error.errorDescription]];
            [self.tableView reloadData];
        }
    }
    else
    {
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.buddy];
        if (!error) {
            [[EMClient sharedClient].chatManager deleteConversation:model.buddy isDeleteMessages:YES completion:nil];
            
            [self.tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.buddy];
            [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [ZQ_CallMethod setupNewMessageBoxCount];

        }
        else{
            [self showHint:[NSString stringWithFormat:@"删除失败:%@", error.errorDescription]];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex || _currentLongPressIndex == nil) {
        return;
    } else {
        NSIndexPath *indexPath = _currentLongPressIndex;
        _currentLongPressIndex = nil;
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        [self showHudInView:self.view hint:@"请等待..."];
        __weak ContactListViewController *weakSelf = self;
        //model.buddy
        if (buttonIndex == 1) {
            EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:model.buddy relationshipBoth:YES];
            if (!error) {
                [[EMClient sharedClient].chatManager deleteConversation:model.buddy isDeleteMessages:YES completion:nil];
                [weakSelf hideHud];
                [weakSelf tableViewDidTriggerHeaderRefresh];
                [ZQ_CallMethod setupNewMessageBoxCount];

            }else{
                [weakSelf hideHud];
                [weakSelf showHint:[NSString stringWithFormat:@"拉黑失败:%@", error.errorDescription]];
                [weakSelf.tableView reloadData];
            }
        } else {
            EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.buddy];
            if (!error) {
                [[EMClient sharedClient].chatManager deleteConversation:model.buddy isDeleteMessages:YES completion:nil];
                [weakSelf hideHud];
//                [weakSelf.tableView beginUpdates];
//                [[weakSelf.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
//                [weakSelf.contactsSource removeObject:model.buddy];
//                if ([ZQ_CommonTool isEmptyArray:weakSelf.dataArray[indexPath.section - 1]]) {
//                    [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section - 1] withRowAnimation:UITableViewRowAnimationFade];
//                } else {
//                    [weakSelf.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }
//                [weakSelf.tableView endUpdates];
                [weakSelf tableViewDidTriggerHeaderRefresh];
                [ZQ_CallMethod setupNewMessageBoxCount];

            }else{
                [weakSelf hideHud];
                [weakSelf showHint:[NSString stringWithFormat:@"删除失败:%@", error.errorDescription]];
                [weakSelf.tableView reloadData];
            }
        }
    }
}

#pragma mark - EaseUserCellDelegate
- (void)portraitButtonClickAtIndexPath:(NSIndexPath *)indexPath WithTableViewTag:(NSInteger)tableViewTag
{
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:model.buddy];
    if ([dic[@"uModelid"] integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:dic[@"uid"]];
        pushToControllerWithAnimated(detailVc)
    } else if ([dic[@"uModelid"] integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:dic[@"uid"]];
        pushToControllerWithAnimated(vc)
    }
}

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath WithTableViewTag:(NSInteger)tableViewTag;
{
    if (tableViewTag == 10) {
        if (indexPath.section == 0) {
            return;
        }
        
        _currentLongPressIndex = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除好友"otherButtonTitles:@"拉入黑名单", nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
}

#pragma mark - action

- (void)addContactAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private
//搜索框
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.searchBarStyle=UISearchBarStyleDefault;
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

#pragma mark - UISearchBarDelegate
//搜索将要开始
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [_searchDataSource removeAllObjects];
    _label.hidden = YES;
    [_searchTableView reloadData];
    
    return YES;
}

//输入字时
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if ([searchText isEqualToString:@""]) {
        self.searchTableView.hidden = YES;
        _label.hidden = YES;
        [_searchDataSource removeAllObjects];
        [_searchTableView reloadData];
    } else {
        self.searchTableView.hidden = NO;
        [_searchDataSource removeAllObjects];
        for (int i = 0; i < self.dataArray.count; i ++) {
            NSArray *userSection = [self.dataArray objectAtIndex:i];
            for (EaseUserModel *model in userSection) {
                if ([model.nickname rangeOfString:searchText].location != NSNotFound) {
                    [_searchDataSource addObject:model];
                }
            }
        }
        if (_searchDataSource.count == 0) {
            _label.hidden = NO;
        } else {
            _label.hidden = YES;
        }
        [_searchTableView reloadData];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    self.searchTableView.hidden = YES;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    for (NSString *buddy in buddyList) {
        if (![blockList containsObject:buddy]) {
            [contactsSource addObject:buddy];
        }
    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    for (NSString *buddy in contactsSource) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        if (model) {
            NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:buddy];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            model.nickname = dic[@"nickname"];
            
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
            NSInteger section;
            if (firstLetter.length > 0) {
                section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            } else {
                section = [sortedArray count] - 1;
            }
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    [self showHudInView:self.view hint:@"加载中..."];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
        });
        if (!error) {
//            [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
//            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.contactsSource removeAllObjects];
                    [weakself.tableView reloadData];
                    
                    for (NSInteger i = (buddyList.count - 1); i >= 0; i--) {
                        NSString *username = [buddyList objectAtIndex:i];
                        [weakself.contactsSource addObject:username];
                    }
                    
                    [weakself userAvatars:weakself.contactsSource];
                });
//            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showHint:@"加载数据失败"];
                [weakself reloadDataSource];
            });
        }
        [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
    });
}

- (void)reloadData
{
    [self reloadDataSource];
}

#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
                for (NSString *buddy in aList) {
                    [weakself.contactsSource addObject:buddy];
                }
                [weakself userAvatars:self.contactsSource];
            });
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
                    }
                }
                [weakself _sortDataArray:self.contactsSource];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself hideHud];
        [weakself showHint:@"加载失败，请检查网络"];
    }];
}

- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController tableViewDidTriggerHeaderRefresh];
    }
}

- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}

@end
