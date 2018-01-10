//
//  ELoginViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ELoginViewModel.h"
#import "EUserModel.h"

@implementation ELoginViewModel

/**
 注册
 
 @param mobile 手机号
 @param password 密码
 @param verifyCode 验证码
 @param type 用户类型：0:个人；1:酒店;2:人力
 */
+ (void)RegisterWithMobile:(NSString *)mobile
                  password:(NSString *)password
                verifyCode:(NSString *)verifyCode
                      type:(NSString *)type
                completion:(void(^)(EUserModel *model))completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    params[@"password"] = password;
    params[@"verifyCode"] = verifyCode;
    params[@"type"] = type;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kRegister) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        /// 注册成功
        if ([responseObject[@"errno"] integerValue] == 0) {
            if (completion) {
                EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
                completion(model);
            }
            
        }
        else{
            if (completion) {
                completion(nil);
            }
             [self showHint:responseObject[@"errmsg"]];
        }

        
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
    
    
}

/**
 获取验证码
 
 @param mobile 手机号
 */
+ (void)getCodeWithMobile:(NSString *)mobile
               completion:(void(^)(BOOL isSuccess))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kSendCode) parameters:params success:^(NSDictionary *responseObject) {
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


/**
 完善基本资料
 
 @param userModel userModel
 */
+ (void)editMember:(EUserModel *)userModel
        completion:(void(^)(BOOL isSuccess, NSString *errmsg))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = userModel.userId;
    params[@"mobile"] = userModel.mobile;
    params[@"sex"] = userModel.sex;
    params[@"avatar"] = userModel.avatar;
    params[@"name"] = userModel.name;
    params[@"birthday"] = userModel.birthday;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kEditMember) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        if (completion) {
            completion([responseObject[@"errno"] boolValue] == NO,responseObject[@"errmsg"]);
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 用户登录
 
 @param mobile 手机号
 @param password 密码
 @param completion 回调
 */
+ (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
             completion:(void(^)(EUserModel *model))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    params[@"password"] = password;
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kLogin) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
                completion(model);
            }
            
        }
        else{
            [self showHint:responseObject[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
    
}

/**
 用户登录 -->> 动态密码登录
 
 @param mobile 手机号
 @param verifyCode 密码
 @param completion 回调
 */
+ (void)loginWithMobile:(NSString *)mobile
             verifyCode:(NSString *)verifyCode
             completion:(void(^)(EUserModel *model,BOOL isSuccess))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    params[@"verifyCode"] = verifyCode;
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kLogin) parameters:params success:^(NSDictionary *responseObject) {
        
        [self jx_dimissLoadingAnimation];
        
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
                completion(model,YES);
            }
            
        }
        else{
            if (completion) {
                completion(nil,NO);
            }
             [self showHint:responseObject[@"errmsg"]];
        }
        
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
    
}

/**
 找回密码
 
 @param mobile 手机号
 @param verifyCode 验证码
 @param password 新的密码
 */
+ (void)findPasswordWithMobile:(NSString *)mobile
                    verifyCode:(NSString *)verifyCode
                      password:(NSString *)password
                    completion:(void(^)(BOOL isSuccess, NSString *errmsg))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    params[@"verifyCode"] = verifyCode;
    params[@"password"] = password;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kFindPassword) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        BOOL isSuc = NO;
        if ([responseObject[@"errno"] intValue] == 0) {
            isSuc = YES;
        }
        if (completion) {
            completion(isSuc,responseObject[@"errmsg"]);
        }
      
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 上传图片

 @param images 图片数组
 */
+ (void)uploadImage:(NSArray <UIImage *>*)images
         completion:(void(^)(BOOL isSuccess, NSString *errmsg,NSString *imagePath))completion{
    [self jx_showLoadingAnimation];
    [PPNetworkHelper uploadImagesWithURL:E_ApiRequset(kUploadUImage) parameters:nil name:@"file" images:images fileNames:nil imageScale:.5 imageType:@"jpg" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        [self jx_dimissLoadingAnimation];
        if (completion) {
            completion([responseObject[@"errno"] intValue] == 0,responseObject[@"errmsg"],responseObject[@"rst"]);
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 修改手机号
 
 @param mobile 手机号
 @param userId userId
 @param verifyCode verifycode
 */
+ (void)updateMobileWithMobile:(NSString *)mobile
                         useId:(NSString *)userId
                    verifyCode:(NSString *)verifyCode
                    completion:(void(^)(void))completion{
    
    [self jx_showLoadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"newMobile"] = mobile;
    params[@"verifycode"] = verifyCode;
    params[@"userId"] = userId;
    [PPNetworkHelper POST:E_ApiRequset(kEditMobile) parameters:params success:^(NSDictionary *responseObject) {
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
 修改密码
 
 @param userId userId
 @param oldPsd 旧密码
 @param newPsd 新密码
 @param rePassword 确认新密码
 */
+ (void)EditPasswordWithUserId:(NSString *)userId
                        oldPsd:(NSString *)oldPsd
                        newPsd:(NSString *)newPsd
                    rePassword:(NSString *)rePassword{
    
    [self jx_showLoadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = userId;
    params[@"oldPassword"] = oldPsd;
    params[@"password"] = newPsd;
    params[@"rePassword"] = rePassword;
    [PPNetworkHelper POST:E_ApiRequset(kEditPassword) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
         [self showHint:responseObject[@"errmsg"]];
    
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 微信绑定手机号

 @param mobile 手机号
 @param verifyCode 验证码
 @param wxUid 微信openid
 */
+ (void)wxBindMobile:(NSString *)mobile
          verifyCode:(NSString *)verifyCode
               wxUid:(NSString *)wxUid
          completion:(void(^)(BOOL isSuccess))completion{
    
    [self jx_showLoadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    params[@"verifyCode"] = verifyCode;
    params[@"wxUid"] = wxUid;
    [PPNetworkHelper POST:E_ApiRequset(kWxBindMobile) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        if ([responseObject[@"errno"] intValue] != 0) {
            [self showHint:responseObject[@"errmsg"]];
            if (completion) {
                completion(NO);
            }
            return ;
        }
        
        EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
        [EUserInfoManager saveUserInfo:model];
        
        if (completion) {
            completion(YES);
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
    
}


/**
 授权登录
 
 @param code 微信code
 @param completion isAuthorized 是否已经授权， 授权了直接登录，wxUid为nil；
 */
+ (void)authorizedLoginWithCode:(NSString *)code
                     completion:(void(^)(BOOL isAuthorized,NSString *wxUid))completion{
    
    [self jx_showLoadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code"] = code;
    [PPNetworkHelper POST:E_ApiRequset(kAuthorizedLogin) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        /// 微信登陆失败：
        if ([responseObject[@"errno"] intValue] == 2) {
            [self showHint:responseObject[@"errmsg"]];
            return ;
        }
        
        
        /// 需要注册绑定手机号的用户:
        if ([responseObject[@"errno"] intValue] == 1) {
            if (completion) {
                completion(NO,responseObject[@"rst"][@"wxUid"]);
            }
            return ;
        }
        
        /// 已经注册的用户返回：
        if ([responseObject[@"errno"] intValue] == 0) {
            EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
            [EUserInfoManager saveUserInfo:model];
            
            if (completion) {
                completion(YES,nil);
            }
        }
       
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

@end
