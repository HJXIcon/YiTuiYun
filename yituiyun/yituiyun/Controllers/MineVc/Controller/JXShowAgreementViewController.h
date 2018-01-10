//
//  JXShowAgreementViewController.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JXShowAgreementUserUse,// 用户协议
    JXShowAgreementFulltimeUser,// 平台服务协议
    JXShowAgreementFullDay,// 全日制协议
} JXShowAgreementStyle;
/**
 展示协议vc
 */
@interface JXShowAgreementViewController : UIViewController

/** 类别 */
@property (nonatomic, assign) JXShowAgreementStyle style;
@end
