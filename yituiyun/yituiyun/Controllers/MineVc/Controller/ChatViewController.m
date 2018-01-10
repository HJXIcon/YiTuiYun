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

#import "ChatViewController.h"
#import "EMChooseViewController.h"
#import "ChatPersonnelListViewController.h"
#import "FXPersonDetailController.h"
#import "FXCompanyDetailController.h"
#import "ContactSelectionViewController.h"
#import "ContactListSelectViewController.h"

@interface ChatViewController ()<UIAlertViewDelegate,EMClientDelegate, EMChooseViewDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic, assign) BOOL isPlayingAudio;
@property (nonatomic, assign) BOOL isShielding;
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) UIView *popUpView;
@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property (nonatomic, strong) NSMutableArray *membersArray;

@end

@implementation ChatViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_popUpView removeAllSubviews];
    [_popUpView removeFromSuperview];
    _popUpView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    self.membersArray = [NSMutableArray array];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"moreAndMore" selectedImage:@"moreAndMore" target:self action:@selector(rightBarButtonItem)];
    
    
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:self.conversation.conversationId includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            if (aGroup) {
                [_membersArray addObjectsFromArray:aGroup.occupants];
                if (aGroup.isBlocked == YES) {
                    _isShielding = YES;
                } else {
                    _isShielding = NO;
                }
                UserInfoModel *model = [ZQ_AppCache userInfoVo];
                if ([aGroup.owner isEqualToString:model.userID]) {
                    _isManager = YES;
                }
            }
        }
    }];
}

- (void)leftBarButtonItem{
    
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [ZQ_CallMethod setupNewMessageBoxCount];
}

#pragma mark 导航栏右侧按钮
- (void)rightBarButtonItem
{
    if (self.conversation.type == EMConversationTypeGroupChat) {
        if (_popUpView) {
            [_popUpView removeAllSubviews];
            [_popUpView removeFromSuperview];
            _popUpView = nil;
        } else {
            [self setUpPopUpView];
        }
    } else if (self.conversation.type == EMConversationTypeChat) {
        if (_popUpView) {
            [_popUpView removeAllSubviews];
            [_popUpView removeFromSuperview];
            _popUpView = nil;
        } else {
            [self setUpPopUpView1];
        }
    }
}

#pragma mark 导航栏右侧按钮点击之后出现的页面
- (void)setUpPopUpView
{
    self.popUpView = [[UIView alloc] initWithFrame:CGRectMake(ZQ_Device_Width - 112, 60, 100, 132)];
    _popUpView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _popUpView.layer.borderWidth = 0.5;
    _popUpView.layer.borderColor = kUIColorFromRGB(0xcccccc).CGColor;
    [self.navigationController.view addSubview:_popUpView];
    
    //成员
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    messageButton.frame = CGRectMake(0, 0, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/3 - 0.5);
    messageButton.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    messageButton.font = [UIFont systemFontOfSize:15];
    [messageButton setTitle:@"群组成员" forState:UIControlStateNormal];
    [messageButton setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_popUpView addSubview:messageButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(10, CGRectGetHeight(_popUpView.frame)/3 - 0.5, CGRectGetWidth(_popUpView.frame) - 20, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    [_popUpView addSubview:lineView];
    
    //消息屏蔽
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    collectionButton.frame = CGRectMake(0, CGRectGetHeight(_popUpView.frame)/3 + 0.5, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/3 - 0.5);
    collectionButton.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    collectionButton.font = [UIFont systemFontOfSize:15];
    [collectionButton setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_popUpView addSubview:collectionButton];
    if (_isShielding == YES) {
        [collectionButton setTitle:@"取消屏蔽" forState:UIControlStateNormal];
    } else {
        [collectionButton setTitle:@"屏蔽消息" forState:UIControlStateNormal];
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(10, CGRectGetHeight(_popUpView.frame)/3*2 - 0.5, CGRectGetWidth(_popUpView.frame) - 20, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [_popUpView addSubview:lineView1];
    
    UIButton *clearRecordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearRecordButton.frame = CGRectMake(0, CGRectGetHeight(_popUpView.frame)/3*2 + 0.5, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/3 - 0.5);
    clearRecordButton.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    clearRecordButton.font = [UIFont systemFontOfSize:15];
    [clearRecordButton setTitle:@"清除记录" forState:UIControlStateNormal];
    [clearRecordButton setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [clearRecordButton addTarget:self action:@selector(clearRecordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_popUpView addSubview:clearRecordButton];
    
    if (_isManager == YES) {
        
        _popUpView.frame = ZQ_RECT_CREATE(ZQ_Device_Width - 112, 60, 100, 176);
        messageButton.frame = CGRectMake(0, 0, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/4 - 0.5);
        lineView.frame = ZQ_RECT_CREATE(10, CGRectGetHeight(_popUpView.frame)/4 - 0.5, CGRectGetWidth(_popUpView.frame) - 20, 1);
        collectionButton.frame = CGRectMake(0, CGRectGetHeight(_popUpView.frame)/4 + 0.5, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/4 - 0.5);
        lineView1.frame = ZQ_RECT_CREATE(10, CGRectGetHeight(_popUpView.frame)/2 - 0.5, CGRectGetWidth(_popUpView.frame) - 20, 1);
        clearRecordButton.frame = CGRectMake(0, CGRectGetHeight(_popUpView.frame)/2 + 0.5, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/4 - 0.5);
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(10, CGRectGetHeight(_popUpView.frame)/4*3 - 0.5, CGRectGetWidth(_popUpView.frame) - 20, 1)];
        lineView2.backgroundColor = kUIColorFromRGB(0xcccccc);
        [_popUpView addSubview:lineView2];
        
        UIButton *invitationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        invitationButton.frame = CGRectMake(0, CGRectGetHeight(_popUpView.frame)/4*3 + 0.5, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame)/4 - 0.5);
        invitationButton.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        invitationButton.font = [UIFont systemFontOfSize:15];
        [invitationButton setTitle:@"邀请好友" forState:UIControlStateNormal];
        [invitationButton setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [invitationButton addTarget:self action:@selector(invitationButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_popUpView addSubview:invitationButton];
    }
    
}

- (void)setUpPopUpView1
{
    self.popUpView = [[UIView alloc] initWithFrame:CGRectMake(ZQ_Device_Width - 112, 60, 100, 44)];
    _popUpView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _popUpView.layer.borderWidth = 0.5;
    _popUpView.layer.borderColor = kUIColorFromRGB(0xcccccc).CGColor;
    [self.navigationController.view addSubview:_popUpView];
    
    UIButton *clearRecordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearRecordButton.frame = CGRectMake(0, 0, CGRectGetWidth(_popUpView.frame), CGRectGetHeight(_popUpView.frame));
    clearRecordButton.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    clearRecordButton.font = [UIFont systemFontOfSize:15];
    [clearRecordButton setTitle:@"清除聊天记录" forState:UIControlStateNormal];
    [clearRecordButton setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [clearRecordButton addTarget:self action:@selector(clearRecordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_popUpView addSubview:clearRecordButton];
}


- (void)messageButtonClick
{
    [_popUpView removeAllSubviews];
    [_popUpView removeFromSuperview];
    _popUpView = nil;
    ChatPersonnelListViewController *vc = [[ChatPersonnelListViewController alloc] initWithConversationId:self.conversation.conversationId];
    pushToControllerWithAnimated(vc)
}

- (void)collectionButtonClick:(UIButton *)button
{
    [_popUpView removeAllSubviews];
    [_popUpView removeFromSuperview];
    _popUpView = nil;
    if (_isShielding == YES) {
        [self showHudInView1:self.view hint:@"加载中..."];
        __weak ChatViewController *weakSelf = self;
        [[EMClient sharedClient].groupManager unblockGroup:self.conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
            [weakSelf hideHud];
            if (!aError) {
                _isShielding = NO;
                [button setTitle:@"屏蔽消息" forState:UIControlStateNormal];
            } else {
                [weakSelf showHint:@"取消失败"];
            }
        }];
    } else {
        [self showHudInView1:self.view hint:@"加载中..."];
        __weak ChatViewController *weakSelf = self;
        [[EMClient sharedClient].groupManager blockGroup:self.conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
            [weakSelf hideHud];
            if (!aError) {
                _isShielding = YES;
                [button setTitle:@"取消屏蔽" forState:UIControlStateNormal];
            } else {
                if (_isManager == YES) {
                    [weakSelf showHint:@"自己创建的群不可以屏蔽"];
                } else {
                    [weakSelf showHint:@"屏蔽失败"];
                }
            }
        }];
    }
}

- (void)clearRecordButtonClick
{
    self.messageTimeIntervalTag = -1;
    [self.conversation deleteAllMessages:nil];
    [self.dataArray removeAllObjects];
    [self.messsagesSource removeAllObjects];
    [self.tableView reloadData];
    [_popUpView removeAllSubviews];
    [_popUpView removeFromSuperview];
    _popUpView = nil;
}

- (void)invitationButtonClick
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_membersArray];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    NSInteger maxUsersCount = 2000;
    if ([selectedSources count] > (maxUsersCount - 1)) {
        [ZQ_UIAlertView showMessage:@"超过群组人数上限" cancelTitle:@"确定"];
        return NO;
    }
    
    [self showHudInView:self.view hint:@"发送中..."];
    
    NSMutableArray *source = [NSMutableArray array];
    for (NSString *username in selectedSources) {
        [source addObject:username];
    }
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSString *messageStr = [NSString stringWithFormat:@"%@ 邀请你加入群聊", model.nickname];
    [[EMClient sharedClient].groupManager addMembers:source toGroup:self.conversation.conversationId message:messageStr completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aGroup) {
            [self showHint:@"邀请发送成功"];
        }
    }];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom) {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    
    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:self.conversation.conversationId includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                NSString *str;
                if ([[ext objectForKey:@"subject"] length]){
                    str = [NSString stringWithFormat:@"%@(%zd)", [ext objectForKey:@"subject"], aGroup.occupants.count];
                } else {
                    str = [NSString stringWithFormat:@"%@(%zd)", aGroup.subject, aGroup.occupants.count];
                    
                }
                self.title = str;
            }
        }];
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:messageModel.message.from];
    if ([dic[@"uModelid"] integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:dic[@"uid"]];
        pushToControllerWithAnimated(detailVc)
    } else if ([dic[@"uModelid"] integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:dic[@"uid"]];
        pushToControllerWithAnimated(vc)
    }
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak ChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"获取成员..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:chatGroup.groupId includeMembersList:YES error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong ChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"获取成员失败 [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
                            //                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
                            //                            selectController.mulChoice = NO;
                            //                            selectController.delegate = self;
                            //                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
            //            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
            //            selectController.mulChoice = NO;
            //            selectController.delegate = self;
            //            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if ([infoModel.userID isEqualToString:message.from]) {
        model.avatarURLPath = [NSString stringWithFormat:@"%@%@", kHost, infoModel.avatar];
        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        model.nickname = infoModel.nickname;
    } else {
        model.avatarURLPath = [NSString stringWithFormat:@"%@%@", kHost, _avatarURLPath];
        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        model.nickname = self.title;
    }
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        //        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:self.conversation.conversationId];
        //        [self.navigationController pushViewController:detailController animated:YES];
    }
    else if (self.conversation.type == EMConversationTypeChatRoom)
    {
        //        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
        //        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:@"没有消息"];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:@"没有消息"];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


//转发
- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listVC = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listVC.messageModel = model;
        [listVC tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)viewControllerDidSelectBack:(EMChooseViewController *)viewController
{
    if (_selectedCallback) {
        _selectedCallback(nil);
    }
}

@end
