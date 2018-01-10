//
//  EDocumentCenterViewController.h
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewController.h"

typedef NS_ENUM(NSInteger,EDocumentCenterStatus) {
    
    EDocumentCenterStatusUnderReView = 0,/// 审核中
    EDocumentCenterStatusReViewFaild,   /// 审核失败
    EDocumentCenterStatusReViewSuceess, /// 审核成功
    EDocumentCenterStatusNone           /// 未上传
};

@class EDocumentCenterModel;

/**
 证件中心
 */
@interface EDocumentCenterViewController : EBaseViewController
@property (nonatomic, strong) EDocumentCenterModel *model;
@property (nonatomic, assign) EDocumentCenterStatus status;

@end
