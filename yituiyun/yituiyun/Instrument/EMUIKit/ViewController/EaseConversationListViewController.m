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

#import "EaseConversationListViewController.h"

#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseMessageViewController.h"
#import "NSDate+Category.h"
#import "EaseLocalDefine.h"

@interface EaseConversationListViewController ()<EaseConversationCellDelegate,UIActionSheetDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}
@end

@implementation EaseConversationListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.tableViewTag = 1;
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
    } else {
        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
        [_delegate conversationListViewController:self didSelectConversationModel:model];
    } else {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        EaseMessageViewController *viewController = [[EaseMessageViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
        viewController.title = model.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath WithTableViewTag:(NSInteger)tableViewTag
{
    if (tableViewTag == 1) {
        _currentLongPressIndex = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除会话" otherButtonTitles:nil, nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex || _currentLongPressIndex == nil) {
        return;
    }
    
    NSIndexPath *indexPath = _currentLongPressIndex;
    EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    _currentLongPressIndex = nil;
    
    [self showHudInView:self.view hint:@"请等待..."];
    __weak EaseConversationListViewController *weakSelf = self;
    [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        if (!aError) {
            [weakSelf hideHud];
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView endUpdates];
        }
        else{
            [weakSelf hideHud];
            [weakSelf showHint:[NSString stringWithFormat:@"删除失败:%@", aError.errorDescription]];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            if (!aError) {
                [self.tableView beginUpdates];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            else{
                [self showHint:[NSString stringWithFormat:@"删除失败:%@", aError.errorDescription]];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - data

-(void)refreshAndSortView
{
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {
            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:sorted];
        }
    }
    [self.tableView reloadData];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    if ([ZQ_CommonTool isEmptyArray:conversations]) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self tableViewDidFinishTriggerHeader:YES reload:NO];

    }
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           [obj1 updateMessageChange:message1 error:nil];
                           EMMessage *message2 = [obj2 latestMessage];
                           [obj2 updateMessageChange:message1 error:nil];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    [self userAvatars:sorted];
}

- (void)userAvatars:(NSArray *)array
{
    NSString *uids = nil;
    for (EMConversation *converstion in array) {
        EMMessage *lastMessage = [converstion latestMessage];
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
        NSString *str;
        
        if ([lastMessage.from integerValue] == [userModel.userID integerValue]) {
            str = lastMessage.to;
        } else {
            str = lastMessage.from;
        }
        if ([ZQ_CommonTool isEmpty:uids]) {
            uids = [NSString stringWithFormat:@"%@", str];
        } else {
            uids = [NSString stringWithFormat:@"%@,%@", uids, str];
        }
    }
    
    if ([ZQ_CommonTool isEmpty:uids]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uids"] = uids;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.avatars"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            [self.dataArray removeAllObjects];
            for (EMConversation *converstion in array) {
                UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
                EMMessage *lastMessage = [converstion latestMessage];
                if (converstion.type == EMConversationTypeChat) {
                    NSString *str;
                    if ([lastMessage.from integerValue] == [userModel.userID integerValue]) {
                        str = lastMessage.to;
                    } else {
                        str = lastMessage.from;
                    }
                    
                    
                    
                    if ([ZQ_CommonTool isEmptyArray:responseObject[@"rst"]]) {
                        [self showHint:@"环信消息列表异常"];
                        return ;
                    }
                    
                    
                    NSDictionary *infoDic = responseObject[@"rst"][str];
                    [ZQ_AppCache saveUserFriendInfo:infoDic WithName:str];
                    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:converstion];
                    model.avatarURLPath = [NSString stringWithFormat:@"%@", infoDic[@"avatar"]];
                    model.title = [NSString stringWithFormat:@"%@", infoDic[@"nickname"]];
                    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
                    [self.dataArray addObject:model];

                } else if (converstion.type == EMConversationTypeGroupChat) {
                    NSString *imageName = @"EaseUIResource.bundle/group";
                    if (![converstion.ext objectForKey:@"subject"])
                    {
                        NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:converstion.conversationId]) {
                                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:converstion.ext];
                                [ext setObject:group.subject forKey:@"subject"];
                                [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                                converstion.ext = ext;
                                break;
                            }
                        }
                    }
                    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:converstion];
                    NSDictionary *ext = converstion.ext;
                    model.title = [ext objectForKey:@"subject"];
                    model.avatarImage = [UIImage imageNamed:imageName];
                    [self.dataArray addObject:model];
                }
            }
        }
        [self.tableView reloadData];
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

@end
