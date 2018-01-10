//
//  KNAlertView.m
//  FileManagerTest
//
//  Created by LUKHA_Lu on 15/10/21.
//  Copyright (c) 2015年 KNKane. All rights reserved.
//

#import "KNAlertView.h"

@interface KNAlertView()<UIAlertViewDelegate>

@end

@implementation KNAlertView

- (instancetype)init{
    if(self = [super init]){
        self.delegate = self;
    }
    return self;
}

+ (KNAlertView *)showMessage:(NSString *)message title:(NSString *)title cancelBtnTitle:(NSString *)cancelTitle alerViewStyle:(KNAlertViewStyle)alertViewStyle{
    return [self showMessage:message delegate:nil title:title cancelBtnTitle:cancelTitle otherButtonTitle:nil alertViewStyle:alertViewStyle];
}

+ (KNAlertView *)showMessage:(NSString *)message title:(NSString *)title cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherButtonTitle alerViewStyle:(KNAlertViewStyle)alertViewStyle{
    return [self showMessage:message delegate:nil title:title cancelBtnTitle:cancelTitle otherButtonTitle:otherButtonTitle alertViewStyle: alertViewStyle];
}

+ (KNAlertView *)showMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title cancelBtnTitle:(NSString *)cancelBtnTitle otherButtonTitle:(NSString *)otherButtonTitle alertViewStyle:(KNAlertViewStyle)alertViewStyle{
    KNAlertView *alert = [[KNAlertView alloc] initWithTitle:title?title:@"提示" message:message delegate:delegate cancelButtonTitle:cancelBtnTitle otherButtonTitles:otherButtonTitle,nil];
    alert.delegate = alert;
    
    switch (alertViewStyle) {
        case KNAlertViewStyleDefault:
            alert.alertViewStyle = UIAlertViewStyleDefault;
            break;
        case KNAlertViewStyleSecureTextInput:
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            break;
        case KNAlertViewStylePlainTextInput:
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            break;
        case KNAlertViewStyleLoginAndPasswordInput:
            alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            break;
        default:
            alert.alertViewStyle = UIAlertViewStyleDefault;
            break;
    }
    
    [alert show];
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(_alertCancelBlock){
            _alertCancelBlock();
        }
    }else{
        if(_alertOtherBlock){
            _alertOtherBlock();
        }
    }
}


@end
