//
//  JXPunchClockHeaderView.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JXPunchClockHeaderViewStepNotCheck,// 未打卡
    JXPunchClockHeaderViewStepCheckIn,// 上班打卡
    JXPunchClockHeaderViewStepCheckOut,// 下班打卡
    JXPunchClockHeaderViewStepGetPaid, // 获得工资
} JXPunchClockHeaderViewStep;

@interface JXPunchClockHeaderView : UIView

/** 步骤 */
@property (nonatomic, assign) JXPunchClockHeaderViewStep step;
/** 描述文本 */
@property (nonatomic, strong) UILabel *desLabel;// 处理审核失败

/** 上班打卡时间*/
@property (nonatomic, strong) NSString *checkInTime;
/** 下班打卡时间*/
@property (nonatomic, strong) NSString *checkOutTime;
/** 获得工资时间*/
@property (nonatomic, strong) NSString *getPaidTime;
@end
