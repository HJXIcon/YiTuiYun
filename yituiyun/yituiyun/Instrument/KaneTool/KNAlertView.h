//
//  KNAlertView.h
//  FileManagerTest
//
//  Created by LUKHA_Lu on 15/10/21.
//  Copyright (c) 2015年 KNKane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KNAlertViewStyleDefault,
    KNAlertViewStyleSecureTextInput,
    KNAlertViewStylePlainTextInput,
    KNAlertViewStyleLoginAndPasswordInput
}KNAlertViewStyle;

/**
 *  取消的block回调
 */
typedef void(^KNKAlertCancelBlock)();

/**
 *  确定的block回调
 */
typedef void(^KNAlertOtherBlock)();


@interface KNAlertView : UIAlertView
/**
 *  弹出框 - 一个按钮
 *
 *  @param message     message
 *  @param title       提示语
 *  @param cancelTitle 按钮文字
 *
 *  @return 返回一个 alertView
 */
+ (KNAlertView *)showMessage:(NSString *)message title:(NSString *)title cancelBtnTitle:(NSString *)cancelTitle alerViewStyle:(KNAlertViewStyle)alertViewStyle;


/**
 *  弹出框 - 两个按钮
 *
 *  @param message          message
 *  @param title            提示语
 *  @param cancelTitle      取消文字
 *  @param otherButtonTitle 确定文字
 *
 *  @return 返回一个 alertView
 */
+ (KNAlertView *)showMessage:(NSString *)message title:(NSString *)title cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherButtonTitle alerViewStyle:(KNAlertViewStyle)alertViewStyle;

@property (nonatomic, copy) KNKAlertCancelBlock alertCancelBlock;
@property (nonatomic, copy) KNAlertOtherBlock alertOtherBlock;
@end
