//
//  ELoginViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"

@class EUserModel;

@interface ELoginViewModel : EBaseViewModel

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
                completion:(void(^)(EUserModel *model))completion;

/**
 获取验证码

 @param mobile 手机号
 */
+ (void)getCodeWithMobile:(NSString *)mobile
                  completion:(void(^)(BOOL isSuccess))completion;


/**
 完善基本资料

 @param userModel userModel
 */
+ (void)editMember:(EUserModel *)userModel
        completion:(void(^)(BOOL isSuccess, NSString *errmsg))completion;


/**
 用户登录 -->> 账号密码登录

 @param mobile 手机号
 @param password 密码
 @param completion 回调
 */
+ (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
             completion:(void(^)(EUserModel *model))completion;

/**
 用户登录 -->> 动态密码登录
 
 @param mobile 手机号
 @param verifyCode 密码
 @param completion 回调
 */
+ (void)loginWithMobile:(NSString *)mobile
               verifyCode:(NSString *)verifyCode
             completion:(void(^)(EUserModel *model,BOOL isSuccess))completion;


/**
 找回密码

 @param mobile 手机号
 @param verifyCode 验证码
 @param password 新的密码
 */
+ (void)findPasswordWithMobile:(NSString *)mobile
                    verifyCode:(NSString *)verifyCode
                      password:(NSString *)password
                    completion:(void(^)(BOOL isSuccess, NSString *errmsg))completion;



/**
 上传图片

 @param images 图片数组
 */
+ (void)uploadImage:(NSArray <UIImage *>*)images
         completion:(void(^)(BOOL isSuccess, NSString *errmsg,NSString *imagePath))completion;



/**
 修改手机号

 @param mobile 手机号
 @param userId userId
 @param verifyCode verifycode
 */
+ (void)updateMobileWithMobile:(NSString *)mobile
                         useId:(NSString *)userId
               verifyCode:(NSString *)verifyCode
             completion:(void(^)(void))completion;

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
                    rePassword:(NSString *)rePassword;


/**
 微信绑定手机号
 
 @param mobile 手机号
 @param verifyCode 验证码
 @param wxUid 微信openid
 */
+ (void)wxBindMobile:(NSString *)mobile
          verifyCode:(NSString *)verifyCode
               wxUid:(NSString *)wxUid
          completion:(void(^)(BOOL isSuccess))completion;


/**
  授权登录

 @param code 微信code
 @param completion isAuthorized 是否已经授权， 授权了直接登录，wxUid为nil；
 */
+ (void)authorizedLoginWithCode:(NSString *)code
                     completion:(void(^)(BOOL isAuthorized,NSString *wxUid))completion;





@end
