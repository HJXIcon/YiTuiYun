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

#import "ConversationListController.h"
#import "ChatViewController.h"

@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSMutableArray *conversationsArray;
@property(nonatomic,strong) UIImageView * nodataImageView;
@end

@implementation ConversationListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataSource];
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    [ZQ_CallMethod setupNewMessageBoxCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kUIColorFromRGB(0xf1f1f1);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:@"ConversationListController" object:nil];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //添加站位图片
//    [self.view addSubview:self.nodataImageView];
//    
//    [self.nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(@(WRadio(55)));
//        make.height.mas_equalTo(@(HRadio(65)));
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.top.mas_equalTo(self.view.mas_top).offset(HRadio(5));
//    }];
    
}

-(UIImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        _nodataImageView = [[UIImageView alloc]init];
        _nodataImageView.image = [UIImage imageNamed:@"NodataTishi"];
    }
    return _nodataImageView;
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//            ChatViewController *chatController = [[ChatViewController alloc]
//                                                  initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatController.title = conversationModel.title;
            if (conversation.type == EMConversationTypeChat) {
                chatController.avatarURLPath = conversationModel.avatarURLPath;
            }
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - EaseConversationListViewControllerDataSource

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
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
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", @"[@所有人]", latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, @"[@所有人]".length)];
            
        } else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", @"[有人@你]", latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, @"[有人@你]".length)];
        } else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}

//- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation{
//    
//    
//    
//}
@end
