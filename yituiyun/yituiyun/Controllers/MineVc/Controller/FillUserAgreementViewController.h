//
//  FillUserAgreementViewController.h
//  yituiyun
//
//  Created by NIT on 15-3-30.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol FillUserAgreementViewControllerDelegate <NSObject>

- (void)userAgreementWithCompanyName:(NSString *)companyName WithNeedsName:(NSString *)needsName;

@end

@interface FillUserAgreementViewController : ZQ_ViewController
@property (nonatomic, assign) id<FillUserAgreementViewControllerDelegate> delegate;

- (instancetype)initWithCompanyName:(NSString *)companyName WithNeedsName:(NSString *)needsName;
@end

