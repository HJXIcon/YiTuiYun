//
//  EMineViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"
@class EDocumentCenterModel;

@interface EMineViewModel : EBaseViewModel

@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int dataCount;
@property (nonatomic, strong) NSMutableArray *models;
/// 实名model
@property (nonatomic, strong) EDocumentCenterModel *authenModel;

/**
 意见反馈

 @param content 内容
 */
+ (void)feedbackWithContent:(NSString *)content
                 completion:(void(^)(void))completion;

/**
 通知中心获取获取未读消息总数
 */
+ (void)getUnreadMsgCount:(void(^)(NSString *count))completion;


/**
 通知消息列表
 */
- (void)getMsgList:(void(^)(void))completion;


/**
 提交实名认证
 
 @param model 证件中心model
 */
+ (void)applyAuthenticationWithModel:(EDocumentCenterModel *)model
                          completion:(void(^)(void))completion;

/**
 获取实名数据，状态
 */
- (void)getAuthenticationInfo:(void(^)(void))completion;

/**
 升级成为带队身份
 */
+ (void)upgradeGroup:(void(^)(BOOL isSuccess))completion;

/**
 检查是否设置密码
 */
+ (void)checkIsSetPwd:(void(^)(BOOL isSetPwd))completion;


/**
 设置密码

 @param password 密码
 @param rePassword 确认密码
 @param code 验证码
 */
+ (void)setPassword:(NSString *)password
         rePassword:(NSString *)rePassword
               code:(NSString *)code
         completion:(void(^)(BOOL isSuccess))completion;
@end
