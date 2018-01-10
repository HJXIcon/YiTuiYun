//
//  JXCheckTools.h
//  Easy
//
//  Created by yituiyun on 2017/11/16.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXCheckTool : NSObject

/**
 *  正则表达式检测邮箱
 *
 *  @param email 传入邮箱
 *
 *  @return 返回检测信息
 */
+ (BOOL) isEmail:(NSString *)email;

/**
 *  正则表达式检测手机号码
 *
 *  @param mobile 传入手机号码
 *
 *  @return 返回检测信息
 */
+ (BOOL) isMobile:(NSString *)mobile;
/**
 *  检测字符串是否是纯数字
 *
 *  @param string 传入字符串
 *
 *  @return 返回检测信息
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 检测身份证是否正确

 @param identityString 身份证字符
 @return 返回检测信息
 */
+(BOOL)isIdentity:(NSString *)identityString;
@end
