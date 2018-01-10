//
//  NStringFormatJudgment.h
//  QJIPHONE
//
//  Created by Messi on 14-4-18.
//  Copyright (c) 2014年 QJCF. All rights reserved.
//
//正则判别宏
//用户密码判断
//6-16位的字母和数字
//#define kPredicatePassword @"^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9A-Za-z]{6,16}$"
//6-20位的字母/数字
#define kPredicatePassword @"(^[A-Za-z0-9]{6,16}$)"
//电子邮箱  判定
#define kPredicateEmail   @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
//名字为中文
#define KPredicateName    @"^[\u4E00-\u9FA5]+$"
//身份证判定
#define KPredicateCardID  @"/(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"
//手机号码判定
#define KPredicatePhoneNumber @"((\\(\\d{2,3}\\))|(\\d{3}\\-))?(1[3458]\\d{9})"
//验证非零的正整数：
#define KPredicateMoney  @"^\\+?[1-9]{1,}$"
#import <Foundation/Foundation.h>

@interface NStringFormatJudgment : NSObject
+(NStringFormatJudgment *)sharedNStringFormatJudgment;
//-----------------------登录时格式判断-----------------------//
-(BOOL)stringHaveOrNullLogin:(NSString *) strPhone andPass:(NSString *) strPass;
-(BOOL)stringPhoneFormatRightOrWrong:(NSString *)strPhone;
-(NSString *)stringPhonePassFormat:(NSString *) strPhone;
-(NSString *)stringPhoneNoPass:(NSString *) strPhone;
//-----------------------提交服务器格式判断---------------------//
-(BOOL)submitNewPassWordFormatJudgment:(NSString *)strCode andOnePass:(NSString *)strOnePass;
//-----------------------手机格式和是否同意协议判断---------------------//
-(BOOL)registerUser:(NSString *) stringPhone andAgree:(BOOL) isAgree;
//-----------------------绑卡时格式判断-----------------------//
-(BOOL)bindingUserCardID:(NSString *)strCardID andUserName:(NSString *)strName andCardNumber:(NSString *) strCard andBankName:(NSString *)strBank andAgree:(BOOL)isAgree;
@end
