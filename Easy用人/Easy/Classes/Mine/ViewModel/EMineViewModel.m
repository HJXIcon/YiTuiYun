//
//  EMineViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMineViewModel.h"
#import "EUserModel.h"
#import "ENotiCenterModel.h"
#import "EDocumentCenterModel.h"
#import "ELoginViewModel.h"


@implementation EMineViewModel

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (instancetype)init{
    if (self = [super init]) {
        self.currentPage = 1;
        self.totalPage = 2;
    }
    return self;
}

/**
 意见反馈
 
 @param content 内容
 */
+ (void)feedbackWithContent:(NSString *)content
                 completion:(void(^)(void))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"content"] = content;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kFeedback) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        [self showHint:responseObject[@"errmsg"]];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                completion();
            }
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 通知中心获取获取未读消息总数
 */
+ (void)getUnreadMsgCount:(void(^)(NSString *count))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kUnreadMsgCount) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion && [responseObject[@"rst"] intValue] > 0) {
                completion([NSString stringWithFormat:@"%d",[responseObject[@"rst"] intValue]]);
            }
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 通知消息列表
 */
- (void)getMsgList:(void(^)(void))completion{
    
    if (self.currentPage > self.totalPage) {
        [self showHint:@"没有更多了哦~"];
        if (completion) {
            completion();
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"page"] = @(self.currentPage);
    params[@"pageSize"] = @(10);
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kMsgList) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            self.dataCount = [responseObject[@"rst"][@"dataCount"] intValue];
            self.totalPage = [responseObject[@"rst"][@"totalPage"]intValue];
            self.currentPage = [responseObject[@"rst"][@"currentPage"]intValue];
            if (self.currentPage > 1) {
                [self.models addObjectsFromArray:[ENotiCenterModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]]];
            }else{
                self.models = [ENotiCenterModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"][@"dataList"]];
            }
            if (completion) {
                completion();
            }
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
    
}


/**
  提交实名认证

 @param model 证件中心model
 */
+ (void)applyAuthenticationWithModel:(EDocumentCenterModel *)model
                          completion:(void(^)(void))completion{
    
    __block dispatch_group_t group = dispatch_group_create();
    __block NSString *idCardImagePath = model.idcardPositive;
    __block NSString *idCardBackImagePath = model.idcardBack;
    __block NSString *healthImagePath = model.healthCertificate;
    
    if (model.healthImage) {
        dispatch_group_enter(group);
        [ELoginViewModel uploadImage:@[model.healthImage] completion:^(BOOL isSuccess, NSString *errmsg, NSString *imagePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                healthImagePath = imagePath;
                dispatch_group_leave(group);
            });
        }];
    }
    
    if (model.idcardImage) {
        dispatch_group_enter(group);
        [ELoginViewModel uploadImage:@[model.idcardImage] completion:^(BOOL isSuccess, NSString *errmsg, NSString *imagePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                idCardImagePath = imagePath;
                dispatch_group_leave(group);
            });
        }];
    }
    
    if (model.idcardBackImage) {
        dispatch_group_enter(group);
        [ELoginViewModel uploadImage:@[model.idcardBackImage] completion:^(BOOL isSuccess, NSString *errmsg, NSString *imagePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                idCardBackImagePath = imagePath;
                dispatch_group_leave(group);
            });
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [EUserInfoManager getUserInfo].userId;
        params[@"realName"] = model.realName;
        params[@"idcardNo"] = model.idcardNo;
        params[@"healthCertificateNo"] = model.healthCertificateNo;
        params[@"healthCertificate"] = healthImagePath;
        params[@"idcardPositive"] = idCardImagePath;
        params[@"idcardBack"] = idCardBackImagePath;
        
        [self jx_showLoadingAnimation];
        [PPNetworkHelper POST:E_ApiRequset(kApplyAuthentication) parameters:params success:^(NSDictionary *responseObject) {
            [self jx_dimissLoadingAnimation];
            [self showHint:responseObject[@"errmsg"]];
            
            if ([responseObject[@"errno"] intValue] == 0) {
                if (completion) {
                    completion();
                }
            }
            
            
        } failure:^(NSError *error) {
            [self jx_dimissLoadingAnimation];
            [self showFailureMsg];
        }];
        
    });
    
    
}

/**
 获取实名数据，状态
 */
- (void)getAuthenticationInfo:(void(^)(void))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;

    
    [PPNetworkHelper POST:E_ApiRequset(kGetAuthentication) parameters:params success:^(NSDictionary *responseObject) {

        if ([responseObject[@"errno"] intValue] != 0) {
            return ;
        }
        self.authenModel = [EDocumentCenterModel mj_objectWithKeyValues:responseObject[@"rst"]];
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error) {

    }];
    
}

/**
 升级成为带队身份
 */
+ (void)upgradeGroup:(void(^)(BOOL isSuccess))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    [self jx_showLoadingAnimation];
    
    [PPNetworkHelper POST:E_ApiRequset(kUpgradeGroup) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        [self showHint:responseObject[@"errmsg"]];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                completion(YES);
            }
            
        }else{
            if (completion) {
                completion(NO);
            }
        }
        
       
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 检查是否设置密码
 */
+ (void)checkIsSetPwd:(void(^)(BOOL isSetPwd))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    [PPNetworkHelper POST:E_ApiRequset(kCheckIsSetPwd) parameters:params success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"errno"] intValue] == 0) {
            
            if (completion) {
                completion([responseObject[@"rst"] boolValue]);
            }
        }
        
    } failure:^(NSError *error) {
        
        [self showFailureMsg];
    }];
}

/**
 设置密码
 
 @param password 密码
 @param rePassword 确认密码
 @param code 验证码
 */
+ (void)setPassword:(NSString *)password
         rePassword:(NSString *)rePassword
               code:(NSString *)code
         completion:(void(^)(BOOL isSuccess))completion{
    [self jx_showLoadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"password"] = password;
    params[@"rePassword"] = rePassword;
    params[@"code"] = code;
    [PPNetworkHelper POST:E_ApiRequset(kSetPassword) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        [self showHint:responseObject[@"errmsg"]];
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                completion(YES);
            }
        }
        else{
            if (completion) {
                completion(NO);
            }
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}
@end
