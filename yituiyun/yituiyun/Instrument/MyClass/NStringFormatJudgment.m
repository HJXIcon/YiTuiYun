//
//  NStringFormatJudgment.m
//  QJIPHONE
//
//  Created by Messi on 14-4-18.
//  Copyright (c) 2014年 QJCF. All rights reserved.
//
#import "NSString+QJAddition.h"
#import "NStringFormatJudgment.h"

@implementation NStringFormatJudgment
static NStringFormatJudgment *sharedNStringFormatJudgment = nil;

static dispatch_once_t onceObject;
+(NStringFormatJudgment *)sharedNStringFormatJudgment
{
    dispatch_once(&onceObject, ^{
        sharedNStringFormatJudgment = [[self alloc] init];
    });
    return sharedNStringFormatJudgment;
}
/**************
****************************************************************
                        登录时手机号和密码格式判断
 ******************************************************************************/
#pragma mark
#pragma mark  判断登录时字符串格式
-(BOOL)stringHaveOrNullLogin:(NSString *) strPhone andPass:(NSString *) strPass;
{
    if ([NSString stringIsEmpty:strPhone]||[NSString stringIsEmpty:strPass]) {
        ALERT_MSG(@"提示",@"请填写全部信息");
        return NO;
    }
    
    if (![self stringPhoneFormatRightOrWrong:strPhone]) {
        return NO;
    }
    return YES;
}
#pragma mark
#pragma makr 手机号格式判断
-(BOOL)stringPhoneFormatRightOrWrong:(NSString *)strPhone
{
    //手机位判断
    if (strPhone.length<11) {
        ALERT_MSG(@"提示",@"请输入11位手机号");
        return NO;
    }
    //手机号码判断
//    if (![QJCommonTool isValidate:KPredicatePhoneNumber valueString:strPhone]) {
//        ALERT_MSG(@"提示",@"手机号段不存在");
//        return NO;
//    }
    
    return YES;
}
-(NSString *)stringPhoneNoPass:(NSString *) strPhone
{
    if ([strPhone rangeOfString:@"*"].location!=NSNotFound) {
        strPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"IPHONENUMBER"];
    }
    return strPhone;
}
#pragma mark
#pragma mark 手机号带*
-(NSString *)stringPhonePassFormat:(NSString *) strPhone
{
    if (![NSString stringIsEmpty:strPhone]) {
        strPhone=[strPhone stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
        return strPhone;
    }
    return nil;
}
/******************************************************************************
                             提交信息、手机格式和是否同意协议判断
 ******************************************************************************/
#pragma mark
#pragma mark  提交信息格式判断
-(BOOL)submitNewPassWordFormatJudgment:(NSString *)strCode andOnePass:(NSString *)strOnePass
{
    //是否为空判断
    if ([NSString stringIsEmpty:strCode]||[NSString stringIsEmpty:strOnePass]) {
        ALERT_MSG(@"提示",@"请填写您的验证码和密码");
        return NO;
    }
    //验证码是否4位
    if (strCode.length < 4 || strCode.length > 4) {
        ALERT_MSG(@"提示",@"请填写四位验证码");
        return NO;
    }
    //检查密码是否合法
    if (![ZQ_CommonTool isValidate:kPredicatePassword valueString:strOnePass]) {
        ALERT_MSG(@"提示",@"您输入的密码格式不正确(6-16位，包含数字、字母，不包含符号)");
        return NO;
    }
    return YES;
}
#pragma mark
#pragma mark  注册时手机格式和是否同意协议判断
-(BOOL)registerUser:(NSString *) stringPhone andAgree:(BOOL) isAgree
{
    //手机号码是否为空
    if ([NSString stringIsEmpty:stringPhone]) {
        ALERT_MSG(@"提示",@"请填写手机号码");
        return NO;
    }
    //手机位数检查
    if (stringPhone.length<11) {
        ALERT_MSG(@"提示",@"请输入11位手机号");
        return NO;
    }
    //手机号断判断
//    if (![QJCommonTool isValidate:KPredicatePhoneNumber valueString:stringPhone]) {
//        ALERT_MSG(@"提示",@"手机号段不存在");
//        return NO;
//    }
    //是否同意协议
    if (isAgree==NO) {
        ALERT_MSG(@"提示",@"请阅读使用条款和隐私政策");
        return NO;
    }
    return YES;
}
/******************************************************************************
                                绑卡时格式判断
 ******************************************************************************/

-(BOOL)bindingUserCardID:(NSString *)strCardID andUserName:(NSString *)strName andCardNumber:(NSString *) strCard andBankName:(NSString *)strBank andAgree:(BOOL)isAgree
{
    if ([NSString stringIsEmpty:strCardID]||[NSString stringIsEmpty:strName]||[NSString stringIsEmpty:strCard]||[NSString stringIsEmpty:strBank]) {
        ALERT_MSG(@"提示",@"请完善您的信息");
        return NO; 
    }
    //中文判断
    if (![ZQ_CommonTool isValidate:KPredicateName valueString:strName]) {
        ALERT_MSG(@"提示",@"请输入中文名字");
        return NO;
    }
    //身份证格式判断
    if (![ZQ_CommonTool isValidate:KPredicateCardID valueString:strCardID]) {
        ALERT_MSG(@"提示",@"身份证格式不正确");
        return NO;
    }
    //银行卡信息选择
    if ([NSString stringIsEmpty:strBank]) {
        ALERT_MSG(@"提示",@"请选择银行");
        return NO;
    }
    //是否同意协议
    if (!isAgree) {
        ALERT_MSG(@"提示",@"请阅读开户协议以及移动端第三方代销协议");
        return NO;
    }
    return YES;
}
@end
