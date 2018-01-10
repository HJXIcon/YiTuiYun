//
//  EDocumentCenterModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 证件中心model
@interface EDocumentCenterModel : NSObject

@property (nonatomic, strong) NSString *userId;
/// 姓名
@property (nonatomic, strong) NSString *realName;
/// 健康证号
@property (nonatomic, strong) NSString *healthCertificateNo;
/// 身份证号
@property (nonatomic, strong) NSString *idcardNo;

/// 健康证图片地址
@property (nonatomic, strong) NSString *healthCertificate;
/// 身份证正面图片地址
@property (nonatomic, strong) NSString *idcardPositive;
/// 身份证反面图片地址
@property (nonatomic, strong) NSString *idcardBack;
/// 初次审核时间
@property (nonatomic, strong) NSString *addTime;
/// 最后更新时间
@property (nonatomic, strong) NSString *updateTime;
/// 0:审核中，1:审核失败，2:审核通过
@property (nonatomic, strong) NSString *status;

#pragma mark - *** UIImage
/// 健康证
@property (nonatomic, strong) UIImage *healthImage;
/// 身份证正面
@property (nonatomic, strong) UIImage *idcardImage;
/// 身份证反面
@property (nonatomic, strong) UIImage *idcardBackImage;


@end
