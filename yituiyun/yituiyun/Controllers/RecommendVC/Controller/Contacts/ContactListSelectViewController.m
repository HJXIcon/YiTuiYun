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

#import "ContactListSelectViewController.h"

#import "ChatViewController.h"
#import "RedPacketChatViewController.h"


@interface ContactListSelectViewController () <EMUserListViewControllerDelegate,EMUserListViewControllerDataSource>

@end

@implementation ContactListSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"选择联系人";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];

}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EMUserListViewControllerDelegate
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel
{
    if (self.messageModel) {
        if (self.messageModel.bodyType == EMMessageBodyTypeText) {
            EMMessage *message = [EaseSDKHelper sendTextMessage:self.messageModel.text to:userModel.buddy messageType:EMChatTypeChat messageExt:self.messageModel.message.ext];
            __weak typeof(self) weakself = self;
            [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
                if (!aError) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
                    chatController.title = userModel.nickname.length != 0 ? [userModel.nickname copy] : [userModel.buddy copy];
                    chatController.avatarURLPath = userModel.avatarURLPath;
                    if ([array count] >= 3) {
                        [array removeLastObject];
                        [array removeLastObject];
                    }
                    [array addObject:chatController];
                    [weakself.navigationController setViewControllers:array animated:YES];
                } else {
                    [self showHudInView:self.view hint:@"转发失败"];
                    [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                }
            }];
        } else if (self.messageModel.bodyType == EMMessageBodyTypeImage) {
            [self showHudInView:self.view hint:@"转发中..."];
            
            UIImage *image = self.messageModel.image;
            if (!image) {
                image = [UIImage imageWithContentsOfFile:self.messageModel.fileLocalPath];
            }
            
            if (!image) {
                [self hideHud];
                [self showHudInView:self.view hint:@"转发失败"];
                [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                return;
            }
            
            EMMessage *message= [EaseSDKHelper sendImageMessageWithImage:image to:userModel.buddy messageType:EMChatTypeChat messageExt:self.messageModel.message.ext];
            
            [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
                    chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
                    chatController.avatarURLPath = userModel.avatarURLPath;
                    if ([array count] >= 3) {
                        [array removeLastObject];
                        [array removeLastObject];
                    }
                    [array addObject:chatController];
                    [self.navigationController setViewControllers:array animated:YES];
                } else {
                    [self showHudInView:self.view hint:@"转发失败"];
                    [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                }
            }];
        } else {
            [self showHudInView1:self.view hint:@"转发中..."];
            
            NSData *data = [NSData dataWithContentsOfFile:self.messageModel.fileLocalPath];
            if (!data) {
                [[EMClient sharedClient].chatManager downloadMessageAttachment:self.messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
                    if (!error) {
                        EMFileMessageBody *fileBody = (EMFileMessageBody *)self.messageModel.firstMessageBody;
                        EMFileMessageBody *body = [[EMFileMessageBody alloc] initWithLocalPath:fileBody.localPath displayName:self.messageModel.fileName];
                        NSString *from = [[EMClient sharedClient] currentUsername];
                        EMMessage *message = [[EMMessage alloc] initWithConversationID:userModel.buddy from:from to:userModel.buddy body:body ext:self.messageModel.message.ext];
                        message.chatType = EMChatTypeChat;
                        [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                            if (!error) {
                                [self hideHud];
                                NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                                RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
                                chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
                                chatController.avatarURLPath = userModel.avatarURLPath;
                                if ([array count] >= 3) {
                                    [array removeLastObject];
                                    [array removeLastObject];
                                }
                                [array addObject:chatController];
                                [self.navigationController setViewControllers:array animated:YES];
                            } else {
                                [self hideHud];
                                [self showHudInView:self.view hint:@"转发失败"];
                                [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                            }
                        }];
                    }else{
                        [self hideHud];
                        [self showHudInView:self.view hint:@"转发失败"];
                        [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                    }
                }];
            } else {
                EMFileMessageBody *body = [[EMFileMessageBody alloc] initWithData:data displayName:self.messageModel.fileName];
                NSString *from = [[EMClient sharedClient] currentUsername];
                EMMessage *message = [[EMMessage alloc] initWithConversationID:userModel.buddy from:from to:userModel.buddy body:body ext:self.messageModel.message.ext];
                
                [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                    if (!error) {
                        [self hideHud];
                        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                        RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
                        chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
                        chatController.avatarURLPath = userModel.avatarURLPath;
                        if ([array count] >= 3) {
                            [array removeLastObject];
                            [array removeLastObject];
                        }
                        [array addObject:chatController];
                        [self.navigationController setViewControllers:array animated:YES];
                    } else {
                        [self hideHud];
                        [self showHudInView:self.view hint:@"转发失败"];
                        [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                    }
                }];
            }
        }
    }
}

#pragma mark - EMUserListViewControllerDataSource
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:model.buddy];
    if (dic) {
        model.nickname = nil ? buddy : dic[@"nickname"];
        model.avatarURLPath = dic[@"avatar"];
    }
    return model;
}

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath
{
    id<IUserModel> model = nil;
    model = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:model.buddy];
    if (dic) {
        model.nickname = nil ? model.buddy : dic[@"nickname"];
        model.avatarURLPath = dic[@"avatar"];
    }
    return model;
}

#pragma mark - action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
